// $(document).on('page:load', ready)

	// $('.search-soundcloud-link').click(function(e) {
	// 	e.preventDefault();
	//   console.log(e);
	//   $.ajax({
	//     url: "search_track",
	//     data: {query: this.id},
	//     contentType: "application/json",
	//   }).success(function(data) {
	//   	// window.scrollTo(0, top); 
	//     // loadSoundcloudWidget(data);
	//     console.log("Retrieved Track:" + data);
	//     for (i = 0; i < data.length; i++) {
	//       console.log(data[i]);
	//     }
	//   }).fail(function() {
	//     console.log("failed to get track");
	//   });
	// })

$(document).foundation({
    accordion: {
      callback : function (accordion) {
        $(accordion[0].previousSibling.previousElementSibling).css('margin-bottom',"0px");
        searchSoundcloud(accordion[0].parentNode.firstElementChild.innerText, accordion[0].id);
        console.log(accordion[0].parentNode.firstElementChild.innerText);
      }
    }
  });

function searchSoundcloud(queryText, divId) {
  $.ajax({
      url: "/soundcloud/query",
      data: {title: queryText}
    }).success(function(data) {
      // window.scrollTo(0, top); 
      // loadSoundcloudWidget(data);
      console.log("Retrieved Track:" + data);
      appendSoundcloudTracks(data, divId);
      // for (i = 0; i < data.length; i++) {
      //   console.log(data[i]);
      // }
    }).fail(function() {
      console.log("failed to get track");
    });
}

loadSoundcloudWidget = function(url) {
	var widgetIframe = document.getElementById('sc-widget'),
      widget       = SC.Widget(widgetIframe);

   widget.load(url, {
   		show_comments: false
   });
}

function appendSoundcloudTracks(trackData, divId) {
  divName = '#' + divId;
  headerDiv = "<div class='row'><div class='large-12'><h3 class='header-text'>Select a Track</h3></div></div>";
  titleDiv = "<div class='row'><div class='large-3 columns'>Image</div><div class='large-3 columns'>User</div><div class='large-3 columns'>Track Title</div><div class='large-3 columns'>Play Count</div></div>";
  $(divName).empty();
  $(divName).append(headerDiv);
  $(divName).append(titleDiv);
  for (i = 0; i < trackData.length && i < 5; i++) {
    trackUri = trackData[i].uri.replace("/", "\/");
    console.log(trackUri);
    newDiv = "<div class='row'><div class='large-2 columns'><img src='"+ trackData[i].artwork + "'></div><div class='large-2 columns'>" + trackData[i].artist + "</div><div class='large-3 columns'>" + trackData[i].title + "</div><div class='large-3 columns'>" + trackData[i].count + "</div><div class='large-2 columns'><i onclick='playSoundcloud(this)' class='fi-play'></i></div><div class='hidden-uri'>"+ trackData[i].uri + "</div></div>";
    $(divName).append(newDiv)
  }
}

function playSoundcloud(element) {
  uri = $(element).parent()[0].nextSibling.innerText;
  window.scrollTo(0, 0); 
  loadSoundcloudWidget(uri);
  console.log(uri);
}