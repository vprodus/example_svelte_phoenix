defmodule ExampleWeb.CustomDomainShopLive do
  alias Example.Products
  use ExampleWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-bold"><%= @shop.name %></h1>
    <%= for {dom_id, product} <- @streams.products do %>
      <div id={dom_id} class="pt-4 mt-4 max-w-3xl">
        <div class=""><%= product.title %></div>
        <div class="text-sm mt-1 mb-2 text-gray-500">
          <%= "#{String.slice(product.description, 0..140)}..." %>
        </div>
        <.link class="text-xs text-gray-500 hover:text-gray-800" navigate={~p"/#{product.slug}"}>
          See product details
        </.link>
      </div>
    <% end %>

    <div class="mt-8 pt-8 border-t">
      <h3 class="text-lg">Shop Guestbook</h3>
      <p class="text-xs text-gray-500 mb-4">
        This is just here to show that liveview websockets work.<br />
        Names will disappear on reload because we don't save them.
      </p>
      <form id="guest-form" phx-submit="sign guestbook" class="mb-4">
        <input type="text" name="name" class="rounded" />
        <.button>Sign Guestbook</.button>
      </form>
      <%= for guest <- @guests do %>
        <div class="mt-4"><%= guest %></div>
      <% end %>
    </div>
    """
  end

  def mount(_, _session, socket = %{assigns: %{custom_domain: _custom_domain, shop: shop}}) do
    products = Products.list_products(shop.id)

    {:ok,
     socket
     |> stream(:products, products)
     |> assign(:guests, [])}
  end

  def handle_event("sign guestbook", %{"name" => name}, socket) do
    {:noreply,
     socket
     |> assign(:guests, [name | socket.assigns.guests])}
  end
end
