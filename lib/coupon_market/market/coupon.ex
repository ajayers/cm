defmodule CouponMarket.Market.Coupon do
  use Ecto.Schema
  import Ecto.Changeset
  alias CouponMarket.Market.Coupon


  schema "coupons" do
    field :value, :float, default: 0.01
    field :account_id, :id
    field :brand_id, :id
    field :sold_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(%Coupon{} = coupon, attrs) do
    coupon
    |> cast(attrs, [:value, :account_id, :brand_id])
    |> validate_required([:value, :account_id, :brand_id])
    |> validate_number(:value, greater_than_or_equal_to: 0.01)
  end
end
