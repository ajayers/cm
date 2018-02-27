defmodule CouponMarket.Market.Brand do
  use Ecto.Schema
  import Ecto.Changeset
  alias CouponMarket.Market.Brand


  schema "brands" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Brand{} = brand, attrs) do
    brand
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 3, max: 48)
  end
end
