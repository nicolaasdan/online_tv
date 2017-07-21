defmodule OnlineTv.PageView do
  use OnlineTv.Web, :view

  @channels [{:Kurzgesagt, "UCsXVk37bltHxD1rDPwtNM8Q"}]

  defp player_id(link) do
    ~r{^.*(?:youtu\.be/|\w+/|v=)(?<id>[^#&?]*)}
    |> Regex.scan(link)
    |> List.last
    |> List.last
  end

  def hour(hour) do
  	if hour > 24 do
  		hour - 24
  	end
  end


  def getvid do
    IO.puts("getvid werkt!")
    video = Tubex.Video.search_by_query("", [maxResults: 25, channelId: elem(Enum.random(@channels), 1), videoDuration: "medium"] )
    video = elem(video, 1)
    video = Enum.random(video)
    duration = get_dur(video.video_id)
    duration.second

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