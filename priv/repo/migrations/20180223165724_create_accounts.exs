defmodule CouponMarket.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :balance, :float, null: false, default: 0
      #add :owner_id, references(:users, on_delete: :nothing), null: false
      add :owner_id, :bigint, null: false

      timestamps()
    end

    create index(:accounts, [:owner_id])
  end
end
