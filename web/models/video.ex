defmodule OnlineTv.Video do
  use OnlineTv.Web, :model

  schema "videos" do
    field :url, :string
    field :title, :string
    field :duration, :time
    field :start, :utc_datetime
    field :end, :utc_datetime
    belongs_to :user, OnlineTv.User
    belongs_to :category, OnlineTv.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :title, :duration, :start, :end, :category_id])
    |> validate_required([:url, :title, :duration, :start])
    |> add_dur
    #|> add_end
  end

  def add_dur(changeset) do
    if video_id = get_change(changeset, :url) do
      dur = video_id |> player_id |> get_dur 
      put_change(changeset, :duration, dur)
    else
      changeset
    end
  end

  def add_end(changeset) do
    if video_id = get_change(changeset, :url) do
      start = get_change(changeset, :start)
      dur = video_id |> player_id |> get_dur 
      put_change(changeset, :end, Timex.shift(start, hours: dur.hour, minutes: dur.minute, seconds: dur.second))

    else
      changeset
    end    
  end

  def player_id(link) do
    ~r{^.*(?:youtu\.be/|\w+/|v=)(?<id>[^#&?]*)}
    |> Regex.scan(link)
    |> List.last
    |> List.last
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
