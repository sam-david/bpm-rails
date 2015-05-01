class SoundcloudController < ApplicationController
	def show
		@track_list = []
		client = Soundcloud.new(:client_id => Rails.application.secrets.soundcloud_client_id,
                        :client_secret => Rails.application.secrets.soundcloud_client_secret,
                        :redirect_uri => 'http://localhost:3000/')
		new_track = client.get('/tracks', :q => "#{params[:title]}", :licence => 'cc-by-sa')
		# p new_track.first
		new_track.each do |track|
			if track.playback_count == nil
				@track_list.push({title: track.title, artist: track.user.username, artwork: track.artwork_url, count: 0, uri: track.uri})
			else
				@track_list.push({title: track.title, artist: track.user.username, artwork: track.artwork_url, count: track.playback_count, uri: track.uri})
			end
		end
		p @track_list
		@track_list.sort_by! {|track| track[:count]}.reverse.to_json
		render :nothing => true
	end
end
