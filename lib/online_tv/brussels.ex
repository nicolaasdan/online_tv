defmodule OnlineTv.Brussels do
	use GenServer
	use Timex
	alias Rumbl.Repo
	alias Rumbl.Video
	import Ecto
	import Ecto.Query

	def start_link do
		GenServer.start_link(__MODULE__, %{}, name: :brussels)
	end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  def current_vid do
  	time = DateTime.utc_now
		videos = drop_nil(playing_now(OnlineTv.StoreVids.get, time))
    IO.inspect(videos)
		video = List.first(videos)
    IO.inspect(video)
  end

  defp schedule_work() do
    new_video = current_vid
    IO.inspect(current_vid)
#    new_vid = check_if_vid_changes(cur_vid)
    stored_video = OnlineTv.BrusVids.get
    IO.inspect(stored_video)

#    if new_vid != nil do
#      vid_id = player_id(new_vid.url)
#      OnlineTv.BrusVids.set(:brus_vids, new_vid)
#      OnlineTv.Endpoint.broadcast! "room", "brussels", %{msg: vid_id}
#    else
#      OnlineTv.BrusVids.set(:brus_vids, "no video")
#      OnlineTv.Endpoint.broadcast! "room", "brussels", %{msg: "no video"}      
#    end

    case {OnlineTv.BrusVids.get, current_vid} do
      {nil, nil} ->
        :ok
        #OnlineTv.Endpoint.broadcast! "room", "brussels", %{msg: "new video en stored video is allebei nil"}
      {_, nil} ->
        #OnlineTv.Endpoint.broadcast! "room", "brussels", %{msg: "video stopt en wordt nu nil"}
        OnlineTv.BrusVids.set(:brus_vids, nil)
      {nil, current_vid} ->
        #OnlineTv.Endpoint.broadcast! "room", "brussels", %{msg: "nil -> current video"}
        OnlineTv.BrusVids.set(:brus_vids, new_video)
      _ ->
        :ok
        #OnlineTv.Endpoint.broadcast! "room", "brussels", %{msg: "er gebeurt niks, want videos zijn gelijk"}
    end


    Process.send_after(self(), :work, 5000) # In 2 hours
  end

  defp playing_now(list, now) do
    Enum.map(list, fn(x) ->
      if DateTime.to_unix(x.start) - 7200 < DateTime.to_unix(now) and DateTime.to_unix(now) < DateTime.to_unix(x.end) -7200 do
        x
      end
    end)
  end

  defp drop_nil(list) do
    Enum.filter(list, fn(x) -> x != nil end)
  end

  defp check_if_vid_changes(cur_vid) do
    new_vid = current_vid
    if cur_vid == new_vid do
      cur_vid
    else
      new_vid
    end
  end

  defp player_id(link) do
    ~r{^.*(?:youtu\.be/|\w+/|v=)(?<id>[^#&?]*)}
    |> Regex.scan(link)
    |> List.last
    |> List.last
  end

end