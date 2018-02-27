defmodule CouponMarket.Market.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias CouponMarket.Market.Transaction
  alias CouponMarket.Market.Coupon


  schema "transactions" do
    field :purchased_at, :naive_datetime
    field :poster_account_id, :id
    field :requester_account_id, :id
    #field :coupon_id, :id

    belongs_to :coupon, Coupon

    timestamps()
  end

  @doc false
  def changeset(%Transaction{} = transaction, attrs) do
    transaction
    |> cast(attrs, [:purchased_at, :poster_account_id, :requester_account_id, :coupon_id])
    |> validate_required([:purchased_at, :poster_account_id, :requester_account_id, :coupon_id])
  end
end
