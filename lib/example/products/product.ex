defmodule Example.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :title, :string
    field :price, :integer
    field :slug, :string
    belongs_to :user, Example.Accounts.User
    belongs_to :shop, Example.Shops.Shop

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :description, :price])
    |> Slugy.slugify(:title)
    |> validate_required([:title, :description, :price, :slug])
  end
end
