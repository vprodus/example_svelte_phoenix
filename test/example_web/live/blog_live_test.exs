defmodule ExampleWeb.BlogLiveTest do
  use ExampleWeb.ConnCase

  import Phoenix.LiveViewTest
  import Example.BlogsFixtures

  @create_attrs %{name: "some name", custom_domain: "some custom_domain"}
  @update_attrs %{name: "some updated name", custom_domain: "some updated custom_domain"}
  @invalid_attrs %{name: nil, custom_domain: nil}

  defp create_blog(_) do
    blog = blog_fixture()
    %{blog: blog}
  end

  describe "Index" do
    setup [:create_blog]

    test "lists all blogs", %{conn: conn, blog: blog} do
      {:ok, _index_live, html} = live(conn, ~p"/blogs")

      assert html =~ "Listing Blogs"
      assert html =~ blog.name
    end

    test "saves new blog", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/blogs")

      assert index_live |> element("a", "New Blog") |> render_click() =~
               "New Blog"

      assert_patch(index_live, ~p"/blogs/new")

      assert index_live
             |> form("#blog-form", blog: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#blog-form", blog: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/blogs")

      html = render(index_live)
      assert html =~ "Blog created successfully"
      assert html =~ "some name"
    end

    test "updates blog in listing", %{conn: conn, blog: blog} do
      {:ok, index_live, _html} = live(conn, ~p"/blogs")

      assert index_live |> element("#blogs-#{blog.id} a", "Edit") |> render_click() =~
               "Edit Blog"

      assert_patch(index_live, ~p"/blogs/#{blog}/edit")

      assert index_live
             |> form("#blog-form", blog: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#blog-form", blog: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/blogs")

      html = render(index_live)
      assert html =~ "Blog updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes blog in listing", %{conn: conn, blog: blog} do
      {:ok, index_live, _html} = live(conn, ~p"/blogs")

      assert index_live |> element("#blogs-#{blog.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#blogs-#{blog.id}")
    end
  end

  describe "Show" do
    setup [:create_blog]

    test "displays blog", %{conn: conn, blog: blog} do
      {:ok, _show_live, html} = live(conn, ~p"/blogs/#{blog}")

      assert html =~ "Show Blog"
      assert html =~ blog.name
    end

    test "updates blog within modal", %{conn: conn, blog: blog} do
      {:ok, show_live, _html} = live(conn, ~p"/blogs/#{blog}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Blog"

      assert_patch(show_live, ~p"/blogs/#{blog}/show/edit")

      assert show_live
             |> form("#blog-form", blog: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#blog-form", blog: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/blogs/#{blog}")

      html = render(show_live)
      assert html =~ "Blog updated successfully"
      assert html =~ "some updated name"
    end
  end
end
