defmodule App.Restrict.AllowIframe do
  @moduledoc """
  Allows affected ressources to be open in iframe.
  """
  alias Plug.Conn

  def init(opts \\ %{}), do: Enum.into(opts, %{})

  def call(conn, _opts) do
    Conn.put_resp_header(conn,"x-frame-options","ALLOW-FROM https://www.stumbleupon.com")
  end

end