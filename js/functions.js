//<![CDATA[

var playlist = null;
var song_list = null;

$(document).ready(function(){
    
    init_player()
    get_song_list();

    $("#playlist-add-b").click(function() {
	playlist.add({
	    title:"b",
	    artist:"b",
	    mp3:"http://localhost:8000/b.mp3"
	});
    });
    $("#playlist-add-p").click(function() {
	playlist.add({
	    title:"p",
	    artist:"p",
	    mp3:"http://localhost:8000/p.mp3"
	});
    });

});


function init_player() {

    playlist = new jPlayerPlaylist({
	jPlayer: "#jquery_jplayer_1",
	cssSelectorAncestor: "#jp_container_1"
    }, [ 
	{ title: "placeholder" }
	// {
	//     title:"Vancouver Beatdown",
        //     artist:"Zomboy",
	//     //	mp3:"http://localhost:7654/Song/p.mp3"
	//     mp3:"http://10.0.1.8:8000/p.mp3"
	// },
	// {
	//     title:"Hoedown",
        //     artist:"Zomboy",
	//     //	mp3:"http://localhost:7654/Song/b.mp3"
	//     mp3:"http://10.0.1.8:8000/b.mp3"
	// }
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
    alert(JSON.stringify(song_list));
}
//]]>