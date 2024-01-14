defmodule Example.ShopsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Example.Shops` context.
  """

  @doc """
  Generate a shop.
  """
  def shop_fixture(attrs \\ %{}) do
    {:ok, shop} =
      attrs
      |> Enum.into(%{
        custom_domain: "some custom_domain",
        name: "some name"
      })
      |> Example.Shops.create_shop()

    shop
  end
end
