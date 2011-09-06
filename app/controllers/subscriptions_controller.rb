class SubscriptionsController < ApplicationController
  inherit_resources
  actions :all, :except => [:edit, :update, :show]

  protected

  def collection
    @subscriptions ||= end_of_association_chain.page(params[:page])
  end

end