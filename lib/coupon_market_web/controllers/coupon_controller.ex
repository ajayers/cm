require Logger

defmodule CouponMarketWeb.CouponController do
  use CouponMarketWeb, :controller

  alias CouponMarket.Market
  alias CouponMarket.Market.Coupon

  def index(conn, _params) do
    coupons = Market.list_coupons()
    brands = Market.list_brands()
    render(conn, "index.html", coupons: coupons, brands: brands)
  end

  def new(conn, _params) do
    changeset = Market.change_coupon(%Coupon{})
    brands = Market.list_brands()
    IO.puts(inspect brands)
    render(conn, "new.html", changeset: changeset, brands: brands)
  end

  def create(conn, %{"coupon" => coupon_params}) do
    user = conn |> Coherence.current_user()
    account = Market.get_account_by_owner(user.id)
    Logger.debug("account #{inspect(account)}")

    case Market.create_coupon(user.id, coupon_params) do
      {:ok, coupon} ->
        conn
        |> put_flash(:info, "Coupon created successfully.")
        |> redirect(to: coupon_path(conn, :show, coupon))
      {:error, %Ecto.Changeset{} = changeset} ->
        brands = Market.list_brands()
        render(conn, "new.html", changeset: changeset, brands: brands)
    end
  end

  def show(conn, %{"id" => id}) do
    coupon = Market.get_coupon!(id)
    brands = Market.list_brands()
    render(conn, "show.html", coupon: coupon, brands: brands)
  end

  def edit(conn, %{"id" => id}) do
    coupon = Market.get_coupon!(id)
    changeset = Market.change_coupon(coupon)
    brands = Market.list_brands()
    render(conn, "edit.html", coupon: coupon, changeset: changeset, brands: brands)
  end

  def update(conn, %{"id" => id, "coupon" => coupon_params}) do
    coupon = Market.get_coupon!(id)

    case Market.update_coupon(coupon, coupon_params) do
      {:ok, coupon} ->
        conn
        |> put_flash(:info, "Coupon updated successfully.")
        |> redirect(to: coupon_path(conn, :show, coupon))
      {:error, %Ecto.Changeset{} = changeset} ->
        brands = Market.list_brands()
        render(conn, "edit.html", coupon: coupon, changeset: changeset, brands: brands)
    end
  end

  def delete(conn, %{"id" => id}) do
    coupon = Market.get_coupon!(id)
    {:ok, _coupon} = Market.delete_coupon(coupon)

    conn
    |> put_flash(:info, "Coupon deleted successfully.")
    |> redirect(to: coupon_path(conn, :index))
  end
end
