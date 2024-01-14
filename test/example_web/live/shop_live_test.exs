defmodule ExampleWeb.ShopLiveTest do
  use ExampleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Example.ShopsFixtures

  @create_attrs %{name: "some name", custom_domain: "some custom_domain"}
  @update_attrs %{name: "some updated name", custom_domain: "some updated custom_domain"}
  @invalid_attrs %{name: nil, custom_domain: nil}

  defp create_shop(_) do
    shop = shop_fixture()
    %{shop: shop}
  end

  describe "Index" do
    setup [:create_shop]

    test "lists all shops", %{conn: conn, shop: shop} do
      {:ok, _index_live, html} = live(conn, ~p"/shops")

      assert html =~ "Listing Shops"
      assert html =~ shop.name
    end

    test "saves new shop", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/shops")

      assert index_live |> element("a", "New Shop") |> render_click() =~
               "New Shop"

      assert_patch(index_live, ~p"/shops/new")

      assert index_live
             |> form("#shop-form", shop: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#shop-form", shop: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/shops")

      html = render(index_live)
      assert html =~ "Shop created successfully"
      assert html =~ "some name"
    end

    test "updates shop in listing", %{conn: conn, shop: shop} do
      {:ok, index_live, _html} = live(conn, ~p"/shops")

      assert index_live |> element("#shops-#{shop.id} a", "Edit") |> render_click() =~
               "Edit Shop"

      assert_patch(index_live, ~p"/shops/#{shop}/edit")

      assert index_live
             |> form("#shop-form", shop: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#shop-form", shop: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/shops")

      html = render(index_live)
      assert html =~ "Shop updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes shop in listing", %{conn: conn, shop: shop} do
      {:ok, index_live, _html} = live(conn, ~p"/shops")

      assert index_live |> element("#shops-#{shop.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#shops-#{shop.id}")
    end
  end

  describe "Show" do
    setup [:create_shop]

    test "displays shop", %{conn: conn, shop: shop} do
      {:ok, _show_live, html} = live(conn, ~p"/shops/#{shop}")

      assert html =~ "Show Shop"
      assert html =~ shop.name
    end

    test "updates shop within modal", %{conn: conn, shop: shop} do
      {:ok, show_live, _html} = live(conn, ~p"/shops/#{shop}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Shop"

      assert_patch(show_live, ~p"/shops/#{shop}/show/edit")

      assert show_live
             |> form("#shop-form", shop: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#shop-form", shop: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/shops/#{shop}")

      html = render(show_live)
      assert html =~ "Shop updated successfully"
      assert html =~ "some updated name"
    end
  end
end
