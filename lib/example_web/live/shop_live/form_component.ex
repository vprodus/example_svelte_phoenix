defmodule ExampleWeb.ShopLive.FormComponent do
  use ExampleWeb, :live_component

  alias Example.Shops

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Form to manage shops</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="shop-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:custom_domain]} type="text" label="Custom domain" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Shop</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{shop: shop} = assigns, socket) do
    changeset = Shops.change_shop(shop)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"shop" => shop_params}, socket) do
    changeset =
      socket.assigns.shop
      |> Shops.change_shop(shop_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"shop" => shop_params}, socket) do
    save_shop(socket, socket.assigns.action, shop_params)
  end

  defp save_shop(socket, :edit, shop_params) do
    case Shops.update_shop(socket.assigns.shop, shop_params) do
      {:ok, shop} ->
        notify_parent({:saved, shop})

        {:noreply,
         socket
         |> put_flash(:info, "Shop updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_shop(socket, :new, shop_params) do
    case Shops.create_shop(socket.assigns.user_id, shop_params) do
      {:ok, shop} ->
        notify_parent({:saved, shop})

        {:noreply,
         socket
         |> put_flash(:info, "Shop created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
