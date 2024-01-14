defmodule ExampleWeb.CustomDomainProductLive do
  alias Example.Products
  use ExampleWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class=""><%= @product.title %></div>
    <div class="text-sm mt-1 mb-2 text-gray-500"><%= @product.description %></div>
    <div class="text-sm mt-1 mb-2 text-gray-500"><%= @product.price %></div>
    """
  end

  def mount(
        %{"product_slug" => product_slug},
        _session,
        socket = %{assigns: %{custom_domain: _custom_domain, shop: shop}}
      ) do
    product = Products.get_product_by_shop_and_slug(shop.id, product_slug)

    {:ok,
     socket
     |> assign(:product, product)}
  end
end
