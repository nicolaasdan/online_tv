defmodule OnlineTv.RoomChannel do
  use Phoenix.Channel

  def join("room", _payload, socket) do
    seconds = %{vid: elem(OnlineTv.BrusVids.on_join, 0), sec: OnlineTv.BrusVids.play, title: elem(OnlineTv.BrusVids.on_join, 1)}
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