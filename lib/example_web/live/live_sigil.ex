defmodule ExampleWeb.LiveSigil do
  use ExampleWeb, :live_view

  def render(assigns) do
    ~V"""

    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :number, 10)}
  end

  def handle_event("increment", _values, socket) do
    {:noreply, assign(socket, :number, socket.assigns.number + 1)}
  end
end
