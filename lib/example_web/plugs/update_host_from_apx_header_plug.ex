defmodule ExampleWeb.UpdateHostFromApxHeaderPlug do
  @moduledoc """
  This plug will *also* work if you don't use this the separate header approach, so no harm to have it.
  """
  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    {_, apx_incoming_host} =
      Enum.find(conn.req_headers, {false, false}, fn {header, _value} ->
        header == "apx-incoming-host"
      end)

    IO.inspect(apx_incoming_host)

    case apx_incoming_host do
      false ->
        conn

      _ ->
        # sets the host for the request as the custom domain,
        # because the router will scope routes by matching hosts.
        %Plug.Conn{conn | host: apx_incoming_host}
    end
  end
end
