
function searchSpotify(queryText, divId) {
	$.ajax({
	    url: "/spotify/search",
	    data: {track_title: queryText}
	  }).success(function(data) {
	    console.log("Retrieved Track:" + data);
	    appendSpotifyTracks(data, divId);
	    console.log(data);
	  }).fail(function() {
	    console.log("failed to get track");
	  })
}

function parseSpotifyTracks(trackData) {
	for (var i = 0; i <= trackData.length; i++) {
	}

}

function appendSpotifyTracks(trackData, divId) {
	var divName = '#' + divId;
	headerDiv = "<div class='row'><div class='large-12'><hr class='spotify-border'><h3 class='spotify-header-text'>Spotify Tracks</h3> </div></div>";
	titleDiv = "<div class='row'><div class='large-4 columns column-heading'>Title</div><div class='large-4 columns column-heading'>Artist</div><div class='large-2 left columns column-heading'>Popularity</div></div>";
	$(divName).append(headerDiv);
	$(divName).append(titleDiv);
	for (i = 0; i < trackData.length && i < 3; i++) {
		artists = trackData[i].artists.toString();
    newDiv = "<div class='row'><div class='large-4 columns'><p class='spotify-track-text'>"+ trackData[i].title + "</p></div><div class='large-4 columns'><p class='spotify-artist-text'>" + artists + "</p></div><div class='large-2 columns'><p class='spotify-popularity-text'>" + trackData[i].popularity + "</p></div><div class='large-2 columns'><p>Add to playlist</p></div></div>";
    $(divName).append(newDiv)
  }
}