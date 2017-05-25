let Player = {
	player: null,

	init(domId, playerId, onReady){
		window.onYouTubeIframeAPIReady = () => {
			this.onIframeReady(domId, playerId, onReady)
			console.log("init function werkt")
		}
		let youtubeScriptTag = document.createElement("script")
		youtubeScriptTag.src = "//www.youtube.com/iframe_api"
		document.head.appendChild(youtubeScriptTag)
	},

	onIframeReady(domId, playerId, onReady){
		this.player = new YT.Player(domId, {
			videoId: playerId,
			playerVars: {
				autoplay: 1,
				controls: 0,
				modestbranding: 1,
				rel: 0,
				showinfo: 0,
				disablekb: 0
			},
			events: {
				"onReady": (event => onReady(event) ),
				"onStateChange": (event => this.onPlayerStateChange(event) )
			},
		})
		$("#toggles").append("<span id='mute-toggle'><i class='fa fa-volume-up'> </i></span>")
		
		$('#mute-toggle').click(function(){
			Player.mute()
		    $(this).find('i').toggleClass('fa-volume-up fa-volume-off')
		});

		$("#mobile").append("<span id='mobile-play'>If you are on mobile, click here to start the video</span>")

	},

	onPlayerStateChange(event) {
		//if (event.data == YT.PlayerState.ENDED) {
        	//Get rid of the player
        	//event.target.destroy();
    	//}
	},

    removePlayer() {
    	console.log("destroyy")
    	this.player.destroy()
    	$("#mute-toggle").remove()
    	$('#mobile-play').remove()
    },
    go_to(seconds) {
    	console.log(seconds + "secs in")
    	this.player.seekTo(Number(seconds))
    },

    mute() {
    	console.log("mute")
    	if(this.player.isMuted()){
    		this.player.unMute();
    	}
    	else {
    		this.player.mute();
    	}
    },
}

export default Player