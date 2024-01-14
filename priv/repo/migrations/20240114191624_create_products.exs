defmodule Example.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :title, :string
      add :description, :text
      add :price, :integer
      add :slug, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :shop_id, references(:shops, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:products, [:user_id])
    create index(:products, [:shop_id])
  end
end
