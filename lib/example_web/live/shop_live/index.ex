defmodule ExampleWeb.ShopLive.Index do
  use ExampleWeb, :live_view

  alias Example.Shops
  alias Example.Shops.Shop

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :shops, Shops.list_shops())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Shop")
    |> assign(:shop, Shops.get_shop!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Shop")
    |> assign(:shop, %Shop{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Shops")
    |> assign(:shop, nil)
  end

  @impl true
  def handle_info({ExampleWeb.ShopLive.FormComponent, {:saved, shop}}, socket) do
    {:noreply, stream_insert(socket, :shops, shop)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    shop = Shops.get_shop!(id)
    {:ok, _} = Shops.delete_shop(shop)

    Task.start(fn ->
      unless is_nil(shop.custom_domain) or String.trim(shop.custom_domain) == "" do
        Example.Approximated.delete_vhost(shop.custom_domain)
      end
    end)

    {:noreply, stream_delete(socket, :shops, shop)}
  end
end
