defmodule ExampleWeb.CustomDomainLiveviewHooks do
  @moduledoc """
  On mount hooks for assigning a custom domain if there is one,
  and assigning the appropriate shop if needed.
  """
  import Phoenix.Component
  alias Example.Shops
  alias Example.Shops.Shop

  def on_mount(:load_shop_for_custom_domain, _params, session, socket) do
    custom_domain = Map.get(session, "custom_domain")

    shop =
      Example.SimpleCache.get(
        Shops,
        :get_shop_by_custom_domain,
        [custom_domain],
        ttl: 600
      )

    case shop do
      %Shop{} = shop ->
        {
          :cont,
          assign(
            socket,
            %{
              custom_domain: custom_domain,
              shop: shop
            }
          )
        }

      _ ->
        raise Ecto.NoResultsError
    end
  end
end
