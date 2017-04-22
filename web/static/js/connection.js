$('#play-toggle').click(function(){
		  if($(this).find('i').hasClass('fa fa-pause')){
		    Player.pause()
		  } else {
		    socket.channel("room", {}).push('seconds', {name: "jow"});
		  }
		    $(this).find('i').toggleClass('fa-play fa-pause')
		});
