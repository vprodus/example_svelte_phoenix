defmodule ExampleWeb.ProductLive.Index do
  use ExampleWeb, :live_view

  alias Example.{Shops, Products}
  alias Example.Products.Product

  @impl true
  def mount(%{"shop_id" => shop_id}, _session, socket) do
    products = Products.list_products(String.to_integer(shop_id))
    shop = Shops.get_shop!(shop_id)

    {
      :ok,
      socket
      |> stream(:products, products)
      |> assign(:shop_id, shop_id)
      |> assign(:shop, shop)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Products.get_product!(id))
  end

  defp apply_action(socket, :edit_shop, %{"shop_id" => id}) do
    socket
    |> assign(:page_title, "Edit Shop")
    |> assign(:blog, Shops.get_shop!(id))
    |> assign(:product, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_info({ExampleWeb.ProductLive.FormComponent, {:saved, product}}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Products.get_product!(id)
    {:ok, _} = Products.delete_product(product)

    {:noreply, stream_delete(socket, :products, product)}
  end
end
