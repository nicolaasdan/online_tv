defmodule OnlineTv.BrusVids do
  use GenServer
  # API
  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :brus_vids)
  end

  def click(pid) do
    GenServer.call(pid, :click)
  end

  def set(pid, new_value) do
    GenServer.call(pid, {:set, new_value})
    case get do
      nil ->
        OnlineTv.Endpoint.broadcast! "room", "brussels", %{msg: "video is nil"}      
      _->
        url = get.url |> player_id
        OnlineTv.Endpoint.broadcast! "room", "brussels", %{msg: url}      
    end
  end

  def get do
    GenServer.call(:brus_vids, :get)
  end

  def play do
    
    case GenServer.call(:brus_vids, :get) do
      nil ->
        nil
      _->
        video = GenServer.call(:brus_vids, :get)
        time = DateTime.utc_now
        time = DateTime.to_unix(time) + 7190 |> DateTime.from_unix!()
        playtime(time, video.start)        
    end
  end

  def on_join do
    case GenServer.call(:brus_vids, :get) do
      nil ->
        nil
      _->
        video = GenServer.call(:brus_vids, :get)
        video.url |> player_id
    end
  end

  defp playtime(time, start) do
    diff = Timex.diff(time, start, :seconds)
  end

  defp player_id(link) do
    ~r{^.*(?:youtu\.be/|\w+/|v=)(?<id>[^#&?]*)}
    |> Regex.scan(link)
    |> List.last
    |> List.last
  end

  # GenServer callbacks

  # init(arguments) -> {:ok, state}
  # see http://elixir-lang.org/docs/v1.0/elixir/GenServer.html
  def init(state) do
    state = nil
    {:ok, state}
  end

  # handle_call(message, from_pid, state) -> {:reply, response, new_state}
  # see http://elixir-lang.org/docs/v1.0/elixir/GenServer.html
  def handle_call(:click, _from, n) do
    {:reply, n + 1, n + 1}
  end

  def handle_call(:get, _from, n) do
    {:reply, n, n}
  end

  def handle_call({:set, new_value}, _from, _state) do
    {:reply, :ok, new_value}
  end
end