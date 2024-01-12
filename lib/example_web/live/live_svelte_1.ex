defmodule ExampleWeb.LiveSvelte1 do
  use ExampleWeb, :live_view
  use LiveSvelte.Components

  def render(assigns) do
    ~H"""
    <div class="mt-2 flex flex-col">
      <%!-- Both work --%>
      <.link navigate={~p"/svelte-2"}>svelte-2 with navigate</.link>
      <.link patch={~p"/svelte-2"}>svelte-2 with patch</.link>
    </div>
    <.StoreExample1 />
    """
  end
end
