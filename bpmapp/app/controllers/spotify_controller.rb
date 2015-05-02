class SpotifyController < ApplicationController
	def show
        @is_logged_in = true
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

		p "R-spotify Login initiated"
		RSpotify::authenticate(Rails.application.secrets.spotify_client_id, Rails.application.secrets.spotify_client_secret)
		@spotify_user = RSpotify::User.new(request.env['omniauth.auth'])

        p "User Playlists"
        @playlists = @spotify_user.playlists 
    # p playlists[0]
    # playlists.each do |playlist|
    # 	p playlist.name
    # 	p playlist.public
    # end
    # p spotify_user.email 
		
	end
    def search
        final_tracks = []
        p tracks = RSpotify::Track.search(params[:track_title])
        tracks.each do |track|
            artists_final = []
            track.artists.each do |artist|
                artists_final.push(artist.name)
            end
            final_tracks.push({title: track.name, artists: artists_final, spotify_id: track.id, popularity: track.popularity})
        end
        render json: final_tracks
    end
    def add
        # add track to user playlist, implies track object exists
        track = RSpotify::Track.search(params[:spotify_id])
        @spotify_user.add_tracks!(track)
        
    end
end
