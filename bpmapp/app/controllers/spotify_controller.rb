class SpotifyController < ApplicationController
	def show
		p "R-spotify Login initiated"
		RSpotify::authenticate(Rails.application.secrets.spotify_client_id, Rails.application.secrets.spotify_client_secret)
		spotify_user = RSpotify::User.new(request.env['omniauth.auth'])

    p "User Playlists"
    @playlists = spotify_user.playlists 
    # p playlists[0]
    # playlists.each do |playlist|
    # 	p playlist.name
    # 	p playlist.public
    # end
    # p spotify_user.email 
		
	end
end
