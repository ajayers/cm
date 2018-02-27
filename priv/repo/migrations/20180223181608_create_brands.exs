defmodule CouponMarket.Repo.Migrations.CreateBrands do
  use Ecto.Migration

  def change do
    create table(:brands) do
      add :name, :string, null: false

      timestamps()
    end

  end
end
