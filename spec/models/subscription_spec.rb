# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Subscription do

  context ".matches" do
    let(:tweet) { Factory.build(:tweet, :text => "test UNO! Due! #tre quattrocinque") }

    it "matches a single word" do
      Factory(:subscription, :query => "uno").match?(tweet).should be_true
      Factory(:subscription, :query => "due").match?(tweet).should be_true
      Factory(:subscription, :query => "tre").match?(tweet).should be_true
      Factory(:subscription, :query => "quattro").match?(tweet).should be_false
    end

    it "matches on a single AND operation" do
      Factory(:subscription, :query => "TEST uno").match?(tweet).should be_true
      Factory(:subscription, :query => "uno tre").match?(tweet).should be_true
      Factory(:subscription, :query => "due tre test").match?(tweet).should be_true
      Factory(:subscription, :query => "quattro tre test").match?(tweet).should be_false
    end

    it "matches multiple AND operations" do
      Factory(:subscription, :query => "TEST,uno").match?(tweet).should be_true
      Factory(:subscription, :query => "uno tre, quattro").match?(tweet).should be_true
      Factory(:subscription, :query => "uno,sei").match?(tweet).should be_true
      Factory(:subscription, :query => "quattro,cinque").match?(tweet).should be_false
    end

  end

end