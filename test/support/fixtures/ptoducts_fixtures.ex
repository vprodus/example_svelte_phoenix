defmodule Example.PtoductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Example.Ptoducts` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        price: 42,
        slug: "some slug",
        title: "some title"
      })
      |> Example.Ptoducts.create_product()

    product
  end
end
