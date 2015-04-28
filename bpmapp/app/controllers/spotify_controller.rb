class SpotifyController < ApplicationController
	def show
		p "R-spotify Test"
		p artists = RSpotify::Artist.search('Arctic Monkeys')
		p RSpotify::authenticate(Rails.application.secrets.spotify_client_id, Rails.application.secrets.spotify_client_secret)
		
	end
end
