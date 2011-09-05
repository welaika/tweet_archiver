# -*- encoding : utf-8 -*-
module FieldsGroupsTesterMethods

  class FieldsGroupTester

    class FieldTester < Struct.new(:type, :attribute, :label, :fill_in_value, :expected_value)
    end

    include Blockenspiel::DSL

    attr_reader :expectation_context
    attr_reader :fields
    attr_reader :within
    attr_reader :befores
    attr_reader :afters

    def initialize(options = {})
      @fields = []
      @befores = []
      @afters = []
      @within = options[:within] || "body"
    end

    def fill(*args)
      @fields << FieldTester.new(*args)
    end

    def and_expect_changes_on(&block)
      @expectation_context = block
    end

    def before_click(&block)
      @befores << block
    end

    def after_click(&block)
      @afters << block
    end

  end

  class FieldsGroupsTester
    include Blockenspiel::DSL

    attr_reader :groups

    def initialize()
      @groups = []
    end

    def group(options = {}, &block)
      group = FieldsGroupTester.new(options)
      @groups << group
      Blockenspiel.invoke(block, group)
    end

  end

  def check_expectation_on_group(group)
    context = group.expectation_context.call
    group.fields.each do |field|
      context.send(field.attribute).should_not be_nil
      if field.type == :upload
        context.send(field.attribute).should be_a(CarrierWave::Uploader::Base)
      else
        context.send(field.attribute).should == (field.expected_value || field.fill_in_value)
      end
    end
  end

  def fill_in_fields_for_group(group)
    within group.within do
      group.fields.each do |field|
        if field.type == :select
          select field.fill_in_value, :from => field.label
        elsif field.type == :text
          fill_in field.label, :with => field.fill_in_value
        elsif field.type == :date
          select_date field.fill_in_value, :from => field.label
        elsif field.type == :boolean
          if field.fill_in_value
            check field.label
          else
            uncheck field.label
          end
        elsif field.type == :upload
          attach_file field.label, field.fill_in_value
        end
      end
      group.befores.each do |before|
        before.call
      end
    end
  end

  def test_fields_after_clicking_on(label, options = {}, &block)
    group = FieldsGroupTester.new(options)
    Blockenspiel.invoke(block, group)
    fill_in_fields_for_group(group)
    click_on label
    group.afters.each do |after|
      after.call
    end
    check_expectation_on_group(group)
  end

  def test_groups_of_fields_after_clicking_on(label, &block)
    groups = FieldsGroupsTester.new
    Blockenspiel.invoke(block, groups)
    groups.groups.each do |group|
      fill_in_fields_for_group(group)
    end
    click_on label
    groups.groups.each do |group|
      group.afters.each do |after|
        after.call
      end
    end
    groups.groups.each do |group|
      check_expectation_on_group(group)
    end
  end

end

RSpec.configuration.include FieldsGroupsTesterMethods, :type => :request