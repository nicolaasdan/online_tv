defmodule OnlineTv.PageController do
  use OnlineTv.Web, :controller

  def index(conn, _params) do
    #brus_vids = OnlineTv.BrusVids.get
    #playtime = OnlineTv.BrusVids.play
    render(conn, "index.html")
  end

  def schedule(conn, _params) do
  	videos = OnlineTv.StoreVids.get

  	render(conn, "schedule.html", videos: videos)
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end
end
