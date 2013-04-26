//<![CDATA[

var playlist = null;
var song_list = [];
var song_element_list = [];
var song_obj = {"title":0, "time":1, "artist":2, "album":3, "genre":4, "location":5}

$(document).ready(function() {
    
    init_player();
    init_add_function();
    get_song_list();

});


function init_add_function() {

    $("tr.song").live("click", function() {
    	var location = $(this).data("location");
    	var fields = $(this).find("td");

	console.log("Adding song location:" + location)

    	playlist.add({
    	    title:fields[song_obj["title"]].innerHTML,
    	    artist:fields[song_obj["artist"]].innerHTML,
    	    mp3:location
    	});
    });
}


function init_player() {

    playlist = new jPlayerPlaylist({
	jPlayer: "#jquery_jplayer",
	cssSelectorAncestor: "#jp_container"
    }, [ 
	// placeholder song so we load properly
	{ title: "placeholder" }
    ], {
	playlistOptions: {
            enableRemoveControls: true,
	    autoPlay: true
	},
	swfPath: "js",
	supplied: "m4a, mp3",
	wmode: "window"
    });
    // remove the placeholder
    playlist.remove();
}


function create_song_table_entry(song, song_tab, odd) {

    // create elements.. is there a better way to do this?
    var entry = $(document.createElement("tr"));
    var title = $(document.createElement("td"));
    var time = $(document.createElement("td"));
    var artist = $(document.createElement("td"));
    var album = $(document.createElement("td"));
    var genre = $(document.createElement("td"));

    entry.addClass("song");
    if (odd) {
	entry.addClass("odd");
    }
    entry.data("location", song.location);

    title.html(song.title);
    time.html(song.time);
    artist.html(song.artist);
    album.html(song.album);
    genre.html(song.genre);

    entry.append(title);
    entry.append(time);
    entry.append(artist);
    entry.append(album);
    entry.append(genre);

    song_tab.append(entry);

    return entry;
}


function populate_song_table(songs) {

    //song_list = song_list.concat(songs);
    var song_tab = $("#song-tab-data");

    for (var i = 0; i < songs.length; i++) {
	var entry = create_song_table_entry(songs[i], song_tab, i % 2);
	song_element_list.push(entry);
    }
}


function get_song_list() {

    $.getJSON("Song/List", function(data, status) {
	console.log("Songs:" + data.length);
	populate_song_table(data);
    }).fail(function(data) {
	// song list returns application/json so if we fail chances are its
	// a malformed json string, so lets try parsing it
	console.log("ajax request failed");
	console.log(data.responseText);
	JSON.parse(data.responseText);
    });
}
//]]>