defmodule Example.PtoductsTest do
  use Example.DataCase

  alias Example.Ptoducts

  describe "products" do
    alias Example.Ptoducts.Product

    import Example.PtoductsFixtures

    @invalid_attrs %{description: nil, title: nil, price: nil, slug: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Ptoducts.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Ptoducts.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{description: "some description", title: "some title", price: 42, slug: "some slug"}

      assert {:ok, %Product{} = product} = Ptoducts.create_product(valid_attrs)
      assert product.description == "some description"
      assert product.title == "some title"
      assert product.price == 42
      assert product.slug == "some slug"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ptoducts.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", price: 43, slug: "some updated slug"}

      assert {:ok, %Product{} = product} = Ptoducts.update_product(product, update_attrs)
      assert product.description == "some updated description"
      assert product.title == "some updated title"
      assert product.price == 43
      assert product.slug == "some updated slug"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Ptoducts.update_product(product, @invalid_attrs)
      assert product == Ptoducts.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Ptoducts.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Ptoducts.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Ptoducts.change_product(product)
    end
  end
end
