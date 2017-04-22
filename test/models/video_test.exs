defmodule OnlineTv.VideoTest do
  use OnlineTv.ModelCase

  alias OnlineTv.Video

  @valid_attrs %{duration: %{hour: 14, min: 0, sec: 0}, title: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Video.changeset(%Video{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Video.changeset(%Video{}, @invalid_attrs)
    refute changeset.valid?
  end
end
