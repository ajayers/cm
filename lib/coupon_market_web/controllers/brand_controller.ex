defmodule CouponMarketWeb.BrandController do
  use CouponMarketWeb, :controller

  alias CouponMarket.Market
  alias CouponMarket.Market.Brand

  def index(conn, _params) do
    brands = Market.list_brands()
    render(conn, "index.html", brands: brands)
  end

  def new(conn, _params) do
    changeset = Market.change_brand(%Brand{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"brand" => brand_params}) do
    case Market.create_brand(brand_params) do
      {:ok, brand} ->
        conn
        |> put_flash(:info, "Brand created successfully.")
        |> redirect(to: brand_path(conn, :show, brand))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    brand = Market.get_brand!(id)
    render(conn, "show.html", brand: brand)
  end

  def edit(conn, %{"id" => id}) do
    brand = Market.get_brand!(id)
    changeset = Market.change_brand(brand)
    render(conn, "edit.html", brand: brand, changeset: changeset)
  end

  def update(conn, %{"id" => id, "brand" => brand_params}) do
    brand = Market.get_brand!(id)

    case Market.update_brand(brand, brand_params) do
      {:ok, brand} ->
        conn
        |> put_flash(:info, "Brand updated successfully.")
        |> redirect(to: brand_path(conn, :show, brand))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", brand: brand, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    brand = Market.get_brand!(id)
    {:ok, _brand} = Market.delete_brand(brand)

    conn
    |> put_flash(:info, "Brand deleted successfully.")
    |> redirect(to: brand_path(conn, :index))
  end
end
