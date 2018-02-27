defmodule CouponMarket.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :purchased_at, :naive_datetime, null: false
      add :poster_account_id, references(:accounts, on_delete: :nothing), null: false
      add :requester_account_id, references(:accounts, on_delete: :nothing), null: false
      add :coupon_id, references(:coupons, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:transactions, [:poster_account_id])
    create index(:transactions, [:requester_account_id])
    create index(:transactions, [:coupon_id])
  end
end
