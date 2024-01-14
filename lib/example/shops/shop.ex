defmodule Example.Shops.Shop do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shops" do
    field :name, :string
    field :custom_domain, :string
    belongs_to :user, Example.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(shop, attrs) do
    shop
    |> cast(attrs, [:name, :custom_domain])
    |> validate_required([:name])
  end
end
