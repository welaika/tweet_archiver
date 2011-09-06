class TweetsController < ApplicationController
  inherit_resources
  actions :only => :index
  belongs_to :subscription

  def export
    @tweets = Subscription.find(params[:subscription_id]).tweets
    from = Time.local params["filter"]["from(1i)"].to_i, params["filter"]["from(2i)"].to_i, params["filter"]["from(3i)"].to_i, params["filter"]["from(4i)"].to_i, params["filter"]["from(5i)"].to_i
    to = Time.local params["filter"]["to(1i)"].to_i, params["filter"]["to(2i)"].to_i, params["filter"]["to(3i)"].to_i, params["filter"]["to(4i)"].to_i, params["filter"]["to(5i)"].to_i

    @tweets = @tweets.where("posted_at >= ? AND posted_at <= ?", from, to)

    respond_to do |format|
      format.xls {
        tempfile = Tempfile.new(Digest::MD5.hexdigest(rand(12).to_s))
        Tweet.generate_report(@tweets, tempfile)
        tempfile.close
        send_file tempfile.path, :filename => "tweets.xls"
      }
      format.json { render :json => @tweets }
    end
  end

  protected

  def collection
    @tweets ||= end_of_association_chain.page(params[:page])
  end

end