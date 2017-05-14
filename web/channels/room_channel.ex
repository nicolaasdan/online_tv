defmodule OnlineTv.RoomChannel do
  use Phoenix.Channel

  def join("room", _payload, socket) do
    seconds = %{vid: OnlineTv.BrusVids.on_join, sec: OnlineTv.BrusVids.play}
    {:ok, seconds, socket}
  end

  def handle_in("brussels", payload, socket) do
  	broadcast! socket, "brussels", payload.msg
  	{:noreply, socket}
  end

  def handle_in("seconds", payload, socket) do
    push socket, "seconds", %{ seconds: OnlineTv.BrusVids.play }
    {:noreply, socket}
  end

  def handle_in("joined", payload, socket) do
    push socket, "joined", payload
    {:noreply, socket}
  end

end