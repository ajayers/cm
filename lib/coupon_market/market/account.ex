defmodule CouponMarket.Market.Account do
  use Ecto.Schema
  import Ecto.Changeset
  alias CouponMarket.Market.Account


  schema "accounts" do
    field :balance, :float, default: 0
    field :owner_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Account{} = account, attrs) do
    account
    |> cast(attrs, [:owner_id, :balance])
    |> validate_required([:owner_id, :balance])
    |> validate_number(:balance, greater_than_or_equal_to: 0)
  end
end
