#!/usr/bin/env ruby

ENV['RAILS_ENV'] = "production"

ARGV.each do |arg|
  if arg.include?('=')
    key, val = arg.split('=', 2)
    ENV[key] = val
  end
end

require File.expand_path("../../../config/environment", __FILE__)
require 'twitter/json_stream'

class TwitterLogger

  def self.start
    @current_logger = nil
    @current_terms = nil
    @current_subscriptions = nil
    EM.epoll
    EM.run do
      EventMachine::PeriodicTimer.new(5) do
        @current_subscriptions = Subscription.order(:id).all
        terms = @current_subscriptions.inject([]) { |terms, s| terms << s.query }.join(",")
        if @current_terms != terms
          puts "#{Time.now}: Cambiati i termini: #{terms}"
          @current_logger.stop if @current_logger.present?
          @current_terms = terms
          @current_logger = Twitter::JSONStream.connect(
            :path    => '/1/statuses/filter.json',
            :auth    => 'steffoz:maglione',
            :method  => 'POST',
            :content => "track=#{terms}"
          )
          @current_logger.each_item do |item|
            tweet = Tweet.initialize_from_api(item)
            @current_subscriptions.each do |subscription|
              if subscription.match?(tweet)
                tweet.subscription = subscription
              end
            end
            tweet.save
            unless tweet.valid?
              puts "#{Time.now}: #{tweet.text}"
            end
          end

          @current_logger.on_error { |error| puts error }
          @current_logger.on_reconnect { |timeout, retries| puts "reconnecting in #{timeout} seconds..." }
          @current_logger.on_max_reconnects { |timeout, retries| puts "Failed after #{retries} failed reconnects" }
        end
      end
    end
  end

end

pwd  = File.dirname(File.expand_path(__FILE__))

Daemons.run_proc(
  'twitter_logger',
  :multiple => false,
  :dir => pwd,
  :backtrace => true,
  :log_output => true
) do
  Rails.logger = ActiveSupport::BufferedLogger.new(pwd + "/active_support.log")
  TwitterLogger.start
end