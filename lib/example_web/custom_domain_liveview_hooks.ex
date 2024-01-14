defmodule ExampleWeb.CustomDomainLiveviewHooks do
  @moduledoc """
  On mount hooks for assigning a custom domain if there is one,
  and assigning the appropriate shop if needed.
  """
  import Phoenix.Component
  alias Example.Shops
  alias Example.Shops.Shop

  def on_mount(:load_shop_for_custom_domain, _params, session, socket) do
    shop =
      Example.SimpleCache.get(
        Shops,
        :get_shop_by_custom_domain,
        [Map.get(session, "custom_domain")],
        # 5 mins
        ttl: 300
      )

    case shop do
      %Shop{} = shop ->
        {
          :cont,
          assign(
            socket,
            %{
              custom_domain: Map.get(session, "custom_domain"),
              # for our use case, the shop struct is pretty lightweight
              # so we assign the entire thing. In your use case, you might want to
              # assign just the id and load/stream it as needed in the actual liveview.
              shop: shop
            }
          )
        }

      _ ->
        # This converts to a 404 in phoenix
        raise Ecto.NoResultsError
    end
  end
end
