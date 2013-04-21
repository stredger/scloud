//<![CDATA[

var playlist = null;
var song_list = null;
var song_obj = {"title":0, "time":1, "artist":2, "album":3, "genre":4}

$(document).ready(function(){
    
    init_player()
    get_song_list();
    init_add_function();
});


function init_add_function() {

    $("tr").click(function () {
	var location = $(this).attr("location")
	var fields = $(this).find("td");

    	playlist.add({
    	    title:fields[song_obj["title"]].innerHTML,
    	    artist:fields[song_obj["artist"]].innerHTML,
    	    mp3:location
    	});
    });
}


function init_player() {

    playlist = new jPlayerPlaylist({
	jPlayer: "#jquery_jplayer_1",
	cssSelectorAncestor: "#jp_container_1"
    }, [ 
	// remove this after we init it
	{ title: "placeholder" }
    ], {
	playlistOptions: {
            enableRemoveControls: true
	},
	swfPath: "js",
	supplied: "m4a, mp3",
	wmode: "window"
    });
}

function get_song_list() {

    $.get("Song/List", function(data, status) {	
	populate_song_table(data);
    });
}

function populate_song_table(songs) {
    song_list = songs;
}
//]]>