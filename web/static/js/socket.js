// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix"
import Player from "./player"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

let list    = $('#chat');
let message = $('#message');
let title   = $('#title');
let name    = $('#name');
let video = document.getElementById("video")


// Now that you are connected, you can join channels with a topic:
window.channel = socket.channel("room", {})
channel.join()
  .receive("ok", resp => {
    if (Player.player != undefined) {
      Player.cueVideoById(resp.vid)
      Player.go_to(resp.sec)
      $('#title').text(resp.title)
      $('.video-container').css("z-index", "0")     
    } 
    else {
      Player.init(video.id, resp.vid, () => {}) //Player.go_to(resp.sec)
      $('#title').text(resp.title)      
    }
    console.log(Player.player)

    console.log("joined successfully!", resp)
    /*
    if(resp.vid) {
      Player.init(video.id, resp.vid, () => {Player.removePlayer()}) //Player.go_to(resp.sec)
      Player.init(video.id, resp.vid, () => {}) //Player.go_to(resp.sec)
      $('#name').remove()
      $('#message').remove()
      $('#title').text(resp.title)
    } else {
      Player.init(video.id, resp.vid, () => {Player.removePlayer()})
    }
*/
  })

  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket

///////////////// custom /////////////////:

/*
channel.on('brussels', payload => {
  var json = JSON.parse(JSON.stringify(payload));
  //list.append(`<b>${json.name || 'Anonymous'}:</b> ${json.msg}<br>`);
  //title.html(`${json.msg}`);
  if(json.msg == "video is nil") {
    Player.removePlayer()
    $("#chat-input").append("<div class='col-md-3'><input type='text' id='name' class='form-control' placeholder='Name' /></div><div class='col-md-9'><input type='text' id='message' class='form-control' placeholder='Message' /></div>")

    let message = $('#message');
    let name    = $('#name');

  } else {
    Player.onIframeReady(video.id, json.msg, () => {})
    $("#name").remove()
    $("#message").remove()
  }
});

*/

channel.on('brussels', payload => {
  if(payload.msg != "video is nil") {
    $('.video-container').css("z-index", "0")
  }
  Player.cueVideoById(payload.msg)
  //console.log(payload.msg)
})

channel.on('seconds', payload => {
  Player.go_to(payload.seconds)
});

$("#mobile").click(function(){
  channel.push('seconds')
  //console.log(Player.getPlayerState())
});

channel.on('title', payload => {
  $('#title').text(payload.msg)
  //console.log(payload.msg)
})

////////////////// TWEETS //////////////////
let tweets_channel = socket.channel("tweets", {})

tweets_channel.join()
  .receive("ok", resp => {
    //console.log("joined tweets channel", resp)
  })
  .receive("error", resp => { })//console.log("Unable to join tweets channel", resp) })

tweets_channel.on('message', payload => {
  $("#tweetuser").text(payload.user.name + ": ").hide().fadeIn()
  $("#tweetmsg").text(payload.text).hide().fadeIn()
});