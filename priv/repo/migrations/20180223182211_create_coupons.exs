defmodule CouponMarket.Repo.Migrations.CreateCoupons do
  use Ecto.Migration

  def change do
    create table(:coupons) do
      add :value, :float, null: false, default: 0.01
      add :account_id, references(:accounts, on_delete: :nothing), null: false
      add :brand_id, references(:brands, on_delete: :nothing), null: false
      add :sold_at, :utc_datetime

      timestamps()
    end

    create index(:coupons, [:account_id])
    create index(:coupons, [:brand_id])
  end
end
