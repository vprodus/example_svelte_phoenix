defmodule ExampleWeb.ProductLive.Show do
  use ExampleWeb, :live_view

  alias Example.Products

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"shop_id" => shop_id, "product_id" => product_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:shop_id, shop_id)
     |> assign(:product, Products.get_product!(product_id))}
  end

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"
end
