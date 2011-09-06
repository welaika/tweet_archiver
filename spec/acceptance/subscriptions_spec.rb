# -*- encoding : utf-8 -*-
require 'spec_helper'

describe "the twitter subscriptions", :type => :request do

  context "index" do
    it "shows me all the created twitter subscriptions" do
      15.times { Factory.create(:subscription) }
      visit subscriptions_path
      page.should have_css '.subscription', :count => 10
    end
    it "shows me a button to create a new twitter subscription" do
      visit subscriptions_path
      page.should have_content "Crea Sottoscrizione"
    end
  end

  context "new" do
    it "creates new twitter subscription" do
      visit new_subscription_path

      test_fields_after_clicking_on "Crea Sottoscrizione" do
        fill :text, :query, "Hashtag", "Test 123"
        and_expect_changes_on { Subscription.first }
      end

      page.should have_notice("Sottoscrizione: creazione avvenuta con successo!")
    end
  end

end