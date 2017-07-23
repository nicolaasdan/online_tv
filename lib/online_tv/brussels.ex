defmodule OnlineTv.Brussels do
	use GenServer
	use Timex
	alias OnlineTv.Repo
	alias OnlineTv.Video
	import Ecto
	import Ecto.Query

  @channels [{:Kurzgesagt, "UCsXVk37bltHxD1rDPwtNM8Q"}, {:trasher_mag, "UCt16NSYjauKclK67LCXvQyA"}, {:casey_neistat, "UCtinbF-Q-fVthA0qrFQTgXQ"}, {:kaptainkristian, "UCuPgdqQKpq4T4zeqmTelnFg"}, {:react, "UCHEf6T_gVq4tlW5i91ESiWg"}, {:omeleto, "UCTMt7iMWa7jy0fNXIktwyLA"}, {:Vsauce, "UC6nSFpj9HTCZ5t-N3Rm3-HA"}, {:you_suck_at_cooking, "UCekQr9znsk2vWxBo3YiLq2w"}, {:yes_theory, "UCvK4bOhULCpmLabd2pDMtnA"}, {:screen_junkies, "UCOpcACMWblDls9Z6GERVi1A"}, {:soulpancake, "UCaDVcGDMkvcRb4qGARkWlyg"}, {:primitive_technology, "UCUK0HBIBWgM2c4vsPhkYY4w"}, {:CGP_grey, "UC2C_jShtL725hvbm1arSV9w"}, {:school_of_life, "UC6-ymYjG0SU0jUWnWh9ZzEQ"}, {:funny_or_die, "UCzS3-65Y91JhOxFiM7j6grg"}, {:the_late_late_show_w_james_corden, "UCJ0uqCI0Vqr2Rrt1HseGirg"}, {:bad_lip_reading, "UC67f2Qf7FYhtoUIF4Sf29cA"}, {:dude_perfect, "UCRijo3ddMTht_IHyNSNXpNQ"}, {:vice, "UCn8zNIfYAQNdrFRrr8oibKw"}, {:pewdiepie, "UC-lHJZR3Gqxm24_Vd_AJ5Yw"}, {:every_frame_a_painting, "UCjFqcJQXGZ6T6sxyFB-5i6A"}, {:lemmino, "UCRcgy6GzDeccI7dkbbBna3Q"}, {:the_great_war, "UCUcyEsEjhPEDf69RRVhRh4A"}]

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
        #:ok
        getvid
        #OnlineTv.Endpoint.broadcast! "room", "brussels", %{msg: "new video en stored video is allebei nil"}
      {_, nil} ->
        #OnlineTv.Endpoint.broadcast! "room", "brussels", %{msg: "video stopt en wordt nu nil"}
        OnlineTv.BrusVids.set(:brus_vids, nil)
        :timer.sleep(1000)
        Repo.delete_all(Video)
        getvid
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

  def getvid do
    IO.puts("getvid werkt!")
    video = Tubex.Video.search_by_query("", [maxResults: 25, channelId: elem(Enum.random(@channels), 1), videoDuration: "medium"] )
    video = elem(video, 1)
    video = Enum.random(video)
    duration = get_dur(video.video_id)
    Repo.insert!(%Video{title: video.title, start: Timex.shift(DateTime.utc_now, hours: 2), url: "https://www.youtube.com/watch?v=" <> video.video_id, end: Timex.shift(DateTime.utc_now, hours: 2, minutes: duration.minute + 1)})
  end

  def get_dur(video_id) do
    Tubex.Video.detail(video_id)
    |> Map.get("items")
    |> List.first
    |> Map.get("contentDetails")
    |> Map.get("duration")
    |> to_list
    |> to_time
  end

  def to_list(duration) do
    ~r/[A-Z]/
    |> Regex.split(duration, trim: true)
    # Returns list in format: ["23", "21", "3"] of ["12", "32"]
  end

  def to_time(list) do
    case list do
      [min, sec] ->
        Time.new(0, String.to_integer(min), String.to_integer(sec), 0)
      [hour, min, sec] ->
        Time.new(String.to_integer(hour), String.to_integer(min), String.to_integer(sec), 0)
      _->
        {:error}
    end
    |> Tuple.to_list
    |> List.last
  end


end