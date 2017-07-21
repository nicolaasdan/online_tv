var flag = true;

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
				// autoplay: 1,
				controls: 0,
				modestbranding: 1,
				rel: 0,
				showinfo: 0,
				disablekb: 1,
				fs: 0,
				iv_load_policy: 3,
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

		$("#mobile").append("<span id='mobile-play'><i class='fa fa-refresh'> </i></span>")

	},

	onPlayerStateChange(event) {
		if (event.data == YT.PlayerState.PLAYING) {
			if(flag) {
				window.channel.push('seconds')
	        	//$("#cover").css("pointer-events", "none")
	        	flag = false
        	}
    	}
    	if (event.data == YT.PlayerState.ENDED) {
    		$(".video-container").css("z-index", "-1")
    	}
	},

    removePlayer() {
    	this.player.destroy()
    	$("#mute-toggle").remove()
    	$('#mobile-play').remove()
    	$('.video-container').css("z-index", "0")
    	flag = true
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

    getPlayerState() {
    	this.player.getPlayerState();
    },


}

export default Player