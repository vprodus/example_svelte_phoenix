defmodule ExampleWeb.UpdateHostFromHeaderPlug do
  @moduledoc """
  This plug will *also* work if you don't use this the separate header approach, so no harm to have it.
  """
  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    {_, incoming_host} =
      Enum.find(conn.req_headers, {false, false}, fn {header, _value} ->
        header == "apx-incoming-host"
      end)

    IO.inspect("received the incoming_host: #{incoming_host}")
    IO.inspect("received the host: #{conn.host}")

    case incoming_host do
      false ->
        conn

      _ ->
        # sets the host for the request as the custom domain,
        # because the router will scope routes by matching hosts.
        %Plug.Conn{conn | host: incoming_host}
    end
  end
end
