//<![CDATA[
$(document).ready(function(){

	var playlist = new jPlayerPlaylist({
		jPlayer: "#jquery_jplayer_1",
		cssSelectorAncestor: "#jp_container_1"
	}, [
		{
			title:"Vancouver Beatdown",
                        artist:"Zomboy",
		//	mp3:"http://localhost:7654/Song/p.mp3"
			mp3:"http://10.0.1.8:8000/p.mp3"
		},
		{
			title:"Hoedown",
                        artist:"Zomboy",
		//	mp3:"http://localhost:7654/Song/b.mp3"
			mp3:"http://10.0.1.8:8000/b.mp3"
		}
	], {
		playlistOptions: {
                    enableRemoveControls: true
		},
		swfPath: "js",
		supplied: "m4a, mp3",
		wmode: "window"
	});

	$("#playlist-add-hoedown").click(function() {
		playlist.add({
			title:"b",
			artist:"b",
			mp3:"http://localhost:8000/b.mp3"
		});
	});

});
//]]>