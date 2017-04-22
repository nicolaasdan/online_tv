defmodule OnlineTv.GetVids do
  use GenServer
  alias OnlineTv.Repo
  alias OnlineTv.Video
  import Ecto
  import Ecto.Query

  def start_link do
    GenServer.start_link(__MODULE__, name: :today)
  end

  def init(state) do
    schedule_work() # Schedule work to be performed on start
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the desired work here
    OnlineTv.StoreVids.set(:store_vids, todays_vids)
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 2000) # In 2 hours
  end

  defp todays_vids() do
    today = Timex.today
            |> Timex.to_datetime

    tomorrow = Timex.today
               |> Timex.shift(days: 1)
               |> Timex.to_datetime

    Video
    |> where([v], v.start > ^today and v.start < ^tomorrow)
    |> order_by([v], v.start)
    |> Repo.all
  end

end