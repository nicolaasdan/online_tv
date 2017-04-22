defmodule OnlineTv.PageView do
  use OnlineTv.Web, :view

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
end
