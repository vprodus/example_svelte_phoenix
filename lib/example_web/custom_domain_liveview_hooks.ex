defmodule ExampleWeb.CustomDomainLiveviewHooks do
  @moduledoc """
  On mount hooks for assigning a custom domain if there is one,
  and assigning the appropriate shop if needed.
  """
  import Phoenix.Component
  alias Example.Shops

  def on_mount(:assign_custom_domain, _params, session, socket) do
    {:cont, assign(socket, :custom_domain, Map.get(session, "custom_domain"))}
  end

  def on_mount(:load_shop_for_custom_domain, _params, session, socket) do
    # This will return an Ecto.NoResultsError if there's no match,
    # which Phoenix will convert to a 404 response
    shop = Shops.get_shop_by_custom_domain!(Map.get(session, "custom_domain"))

    {
      :cont,
      assign(
        socket,
        %{
          custom_domain: Map.get(session, "custom_domain"),
          shop: shop
        }
      )
    }
  end
end
