defmodule OnlineTv.TweetChannel do
	use Phoenix.Channel

	alias OnlineTv.TweetStreamer

	def join("tweets", _payload, socket) do
		send(self, :after_join)
    {:ok, socket}
  end

  def handle_in("message", payload, socket) do
    broadcast! socket, "message", payload
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
  	pid = spawn(fn ->
		  stream = ExTwitter.stream_filter(track: "apple")
		  for tweet <- stream do
		    IO.puts tweet.text
		    handle_in("message", tweet, socket)
		    :timer.sleep(10000)
		  end
		end)
    {:noreply, socket}
  end

end
