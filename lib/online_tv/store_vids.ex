defmodule OnlineTv.StoreVids do
  use GenServer
  # API
  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :store_vids)
  end

  def click(pid) do
    GenServer.call(pid, :click)
  end

  def set(pid, new_value) do
    GenServer.call(pid, {:set, new_value})
  end

  def get do
    GenServer.call(:store_vids, :get)
  end

  # GenServer callbacks

  # init(arguments) -> {:ok, state}
  # see http://elixir-lang.org/docs/v1.0/elixir/GenServer.html
  def init(state) do
    state = []
    {:ok, state}
  end

  # handle_call(message, from_pid, state) -> {:reply, response, new_state}
  # see http://elixir-lang.org/docs/v1.0/elixir/GenServer.html
  def handle_call(:click, _from, n) do
    {:reply, n + 1, n + 1}
  end

  def handle_call(:get, _from, n) do
    IO.puts("Getting todays videos")
    {:reply, n, n}
  end

  def handle_call({:set, new_value}, _from, _state) do
    {:reply, :ok, new_value}
  end
end