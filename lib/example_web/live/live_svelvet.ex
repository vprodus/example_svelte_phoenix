defmodule ExampleWeb.LiveSvelvet do
  use ExampleWeb, :live_view
  use LiveSvelte.Components

  def render(assigns) do
    ~H"""
    <.Svelte3 socket={@socket} />
    """
  end

  def mount(_session, _params, socket) do
    {:ok, assign(socket, %{svelte_opts: %{ssr: false}})}
  end
end
