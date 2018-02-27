defmodule CouponMarketWeb.CouponControllerTest do
  use CouponMarketWeb.ConnCase

  alias CouponMarket.Market

  @create_attrs %{value: 120.5}
  @update_attrs %{value: 456.7}
  @invalid_attrs %{value: nil}

  def fixture(:coupon) do
    {:ok, coupon} = Market.create_coupon(@create_attrs)
    coupon
  end

  describe "index" do
    test "lists all coupons", %{conn: conn} do
      conn = get conn, coupon_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Coupons"
    end
  end

  describe "new coupon" do
    test "renders form", %{conn: conn} do
      conn = get conn, coupon_path(conn, :new)
      assert html_response(conn, 200) =~ "New Coupon"
    end
  end

  describe "create coupon" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, coupon_path(conn, :create), coupon: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == coupon_path(conn, :show, id)

      conn = get conn, coupon_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Coupon"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, coupon_path(conn, :create), coupon: @invalid_attrs
      assert html_response(conn, 200) =~ "New Coupon"
    end
  end

  describe "edit coupon" do
    setup [:create_coupon]

    test "renders form for editing chosen coupon", %{conn: conn, coupon: coupon} do
      conn = get conn, coupon_path(conn, :edit, coupon)
      assert html_response(conn, 200) =~ "Edit Coupon"
    end
  end

  describe "update coupon" do
    setup [:create_coupon]

    test "redirects when data is valid", %{conn: conn, coupon: coupon} do
      conn = put conn, coupon_path(conn, :update, coupon), coupon: @update_attrs
      assert redirected_to(conn) == coupon_path(conn, :show, coupon)

      conn = get conn, coupon_path(conn, :show, coupon)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, coupon: coupon} do
      conn = put conn, coupon_path(conn, :update, coupon), coupon: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Coupon"
    end
  end

  describe "delete coupon" do
    setup [:create_coupon]

    test "deletes chosen coupon", %{conn: conn, coupon: coupon} do
      conn = delete conn, coupon_path(conn, :delete, coupon)
      assert redirected_to(conn) == coupon_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, coupon_path(conn, :show, coupon)
      end
    end
  end

  defp create_coupon(_) do
    coupon = fixture(:coupon)
    {:ok, coupon: coupon}
  end
end
