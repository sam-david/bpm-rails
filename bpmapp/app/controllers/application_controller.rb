class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index()
  	@is_logged_in = false
  	client = Twitter::REST::Client.new do |config|
		  config.consumer_key        = Rails.application.secrets.twitter_consumer_key
		  config.consumer_secret     = Rails.application.secrets.twitter_consumer_secret
		  config.access_token        = Rails.application.secrets.twitter_access_token
		  config.access_token_secret = Rails.application.secrets.twitter_access_token_secret
		end
		@bpm_playlist = []
		bpm_tweets = client.user_timeline(247455247, :count => 100)
		bpm_tweets.each do |tweet|
			new_track = {}
			if /#BpmBreaker/.match(tweet.text) != nil
				new_track["breaker?"] = true
				new_track["title"] = /([^-]*)-([^-]*)-([^-]*)/.match(tweet.text)[2].rstrip.lstrip.chomp(" playing on #BPM").chomp(" #BpmBreaker").gsub(/&amp;/, '&')
				new_track["artist"] = /([^-]*)-([^-]*)-([^-]*)/.match(tweet.text)[1].rstrip.lstrip.chomp(" playing on #BPM").chomp(" #BpmBreaker").gsub(/&amp;/, '&')
			else
				new_track["breaker?"] = false
				p /^([^-]*)-([^-]*)/.match(tweet.text)
				p /^([^-]*)-([^-]*)/.match(tweet.text)[2].lstrip.chomp(" playing on #BPM ")
				new_track["title"] = /^([^-]*)-([^-]*)/.match(tweet.text)[2].lstrip.chomp(" playing on #BPM ")
				new_track["artist"] = /^([^-]*)-([^-]*)/.match(tweet.text)[1].rstrip
			end
			@bpm_playlist << new_track
		end
		@bpm_playlist
  	
  end
end
