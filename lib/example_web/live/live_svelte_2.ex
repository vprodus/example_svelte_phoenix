defmodule ExampleWeb.LiveSvelte2 do
  use ExampleWeb, :live_view
  use LiveSvelte.Components

  def render(assigns) do
    ~H"""
    <div class="mt-2 flex flex-col">
      <%!-- Both work --%>
      <.link navigate={~p"/svelte-1"}>svelte-1 with navigate</.link>
      <.link patch={~p"/svelte-1"}>svelte-1 with patch</.link>
    </div>
    <.StoreExample2 />
    """
  end
end
