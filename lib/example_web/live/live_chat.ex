defmodule ExampleWeb.LiveExample6 do
  use ExampleWeb, :live_view
  use LiveSvelte.Components

  @topic "public"
  @event_new_message "new_message"

  on_mount({ExampleWeb.UserAuth, :mount_current_user})

  def mount(_session, _params, socket) do
    ExampleWeb.Endpoint.subscribe(@topic)

    name = if socket.assigns.current_user, do: socket.assigns.current_user, else: nil

    socket =
      socket
      |> assign(:messages, [])
      |> assign(:name, name)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.Chat
      :if={@name}
      messages={@messages}
      name={@name}
      class="w-full h-full flex justify-center items-center"
      socket={@socket}
    />

    <div :if={!@name} class="flex justify-center items-center h-full w-full">
      <form :if={!@name} phx-submit="set_name">
        <!-- svelte-ignore a11y-autofocus -->
        <input
          type="text"
          placeholder="Name"
          name="name"
          class="rounded"
          autofocus
          autocomplete="name"
        />
        <button class="py-2 px-4 bg-black text-white rounded">Join</button>
      </form>
    </div>
    """
  end

  def handle_event("set_name", %{"name" => ""}, socket), do: {:noreply, socket}

  def handle_event("set_name", %{"name" => name}, socket),
    do: {:noreply, assign(socket, name: name)}

  def handle_event("send_message", payload, socket) do
    payload =
      payload
      |> Map.put(:name, socket.assigns.name)
      |> Map.put(:id, System.unique_integer([:positive]))

    ExampleWeb.Endpoint.broadcast(@topic, @event_new_message, payload)

    {:noreply, socket}
  end

  def handle_info(%{topic: @topic, event: @event_new_message, payload: payload}, socket) do
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [payload])}
  end
end
