defmodule CouponMarket.MarketTest do
  use CouponMarket.DataCase

  alias CouponMarket.Market
  alias CouponMarket.Market.Account
  alias CouponMarket.Market.Brand
  alias CouponMarket.Market.Coupon
  alias CouponMarket.Market.Transaction

  describe "accounts" do

    @valid_attrs %{balance: "120.5"}
    @update_attrs %{balance: 456.7}
    @invalid_attrs %{balance: nil}

    def account_fixture(attrs \\ %{}) do
        attrs = attrs
        |> Enum.into(@valid_attrs)

      {:ok, account} =
        Market.create_account(1, attrs)
      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Market.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Market.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Market.create_account(1, @valid_attrs)
      assert account.balance == 120.5
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Market.create_account(1, @invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, account} = Market.update_account(account, @update_attrs)
      assert %Account{} = account
      assert account.balance == 456.7
    end

    test "deposit into account" do
      account = account_fixture(%{balance: 3.0})
      new_balance = Market.deposit_to_account(1.0, account.id)
      upd_account = Account |> Repo.get!(account.id)
      assert new_balance == 4.0
      assert upd_account.balance == 4.0
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Market.update_account(account, @invalid_attrs)
      assert account == Market.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Market.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Market.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Market.change_account(account)
    end
  end

  describe "brands" do
    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def brand_fixture(attrs \\ %{}) do
      {:ok, brand} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Market.create_brand()

      brand
    end

    test "list_brands/0 returns all brands" do
      brand = brand_fixture()
      assert Market.list_brands() == [brand]
    end

    test "get_brand!/1 returns the brand with given id" do
      brand = brand_fixture()
      assert Market.get_brand!(brand.id) == brand
    end

    test "create_brand/1 with valid data creates a brand" do
      assert {:ok, %Brand{} = brand} = Market.create_brand(@valid_attrs)
      assert brand.name == "some name"
    end

    test "create_brand/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Market.create_brand(@invalid_attrs)
    end

    test "update_brand/2 with valid data updates the brand" do
      brand = brand_fixture()
      assert {:ok, brand} = Market.update_brand(brand, @update_attrs)
      assert %Brand{} = brand
      assert brand.name == "some updated name"
    end

    test "update_brand/2 with invalid data returns error changeset" do
      brand = brand_fixture()
      assert {:error, %Ecto.Changeset{}} = Market.update_brand(brand, @invalid_attrs)
      assert brand == Market.get_brand!(brand.id)
    end

    test "delete_brand/1 deletes the brand" do
      brand = brand_fixture()
      assert {:ok, %Brand{}} = Market.delete_brand(brand)
      assert_raise Ecto.NoResultsError, fn -> Market.get_brand!(brand.id) end
    end

    test "change_brand/1 returns a brand changeset" do
      brand = brand_fixture()
      assert %Ecto.Changeset{} = Market.change_brand(brand)
    end
  end

  describe "coupons" do
    @valid_attrs %{value: 120.5}
    @update_attrs %{value: 456.7}
    @invalid_attrs %{value: nil}

    def coupon_fixture(account_id, attrs \\ %{}) do
        attrs = attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:brand_id, brand_fixture().id)
        
      {:ok, coupon} = Market.create_coupon(account_id, attrs)
      coupon
    end

    test "list_coupons/0 returns all coupons" do
      account = account_fixture()
      coupon = coupon_fixture(account.id)
      assert Market.list_coupons() == [coupon]
    end

    test "get_coupon!/1 returns the coupon with given id" do
      account = account_fixture()
      coupon = coupon_fixture(account.id)
      assert Market.get_coupon!(coupon.id) == coupon
    end

    test "create_coupon/1 with valid data creates a coupon" do
      attrs = @valid_attrs
      |> Map.put(:brand_id, brand_fixture().id)
      assert {:ok, %Coupon{} = coupon} = Market.create_coupon(account_fixture().id, attrs)
      assert coupon.value == 120.5
    end

    test "create_coupon/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Market.create_coupon(@invalid_attrs)
    end

    test "update_coupon/2 with valid data updates the coupon" do
      account = account_fixture()
      coupon = coupon_fixture(account.id)
      assert {:ok, coupon} = Market.update_coupon(coupon, @update_attrs)
      assert %Coupon{} = coupon
      assert coupon.value == 456.7
    end

    test "update_coupon/2 with invalid data returns error changeset" do
      account = account_fixture()
      coupon = coupon_fixture(account.id)
      assert {:error, %Ecto.Changeset{}} = Market.update_coupon(coupon, @invalid_attrs)
      assert coupon == Market.get_coupon!(coupon.id)
    end

    test "delete_coupon/1 deletes the coupon" do
      account = account_fixture()
      coupon = coupon_fixture(account.id)
      assert {:ok, %Coupon{}} = Market.delete_coupon(coupon)
      assert_raise Ecto.NoResultsError, fn -> Market.get_coupon!(coupon.id) end
    end

    test "change_coupon/1 returns a coupon changeset" do
      account = account_fixture()
      coupon = coupon_fixture(account.id)
      assert %Ecto.Changeset{} = Market.change_coupon(coupon)
    end
  end

  describe "transactions" do
    @valid_attrs %{purchased_at: ~N[2010-04-17 14:00:00.000000]}
    @update_attrs %{purchased_at: ~N[2011-05-18 15:01:01.000000]}
    @invalid_attrs %{purchased_at: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Market.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      poster_account = account_fixture()
      transaction = transaction_fixture(%{
        poster_account_id: poster_account.id,
        requester_account_id: account_fixture().id,
        coupon_id: coupon_fixture(poster_account.id).id
      })
      assert Market.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      poster_account = account_fixture()
      transaction = transaction_fixture(%{
        poster_account_id: poster_account.id,
        requester_account_id: account_fixture().id,
        coupon_id: coupon_fixture(poster_account.id).id
      })
      assert Market.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      poster_account = account_fixture()
      attrs = %{
        poster_account_id: poster_account.id,
        requester_account_id: account_fixture().id,
        coupon_id: coupon_fixture(poster_account.id).id
      }
      attrs = Map.merge(attrs, @valid_attrs)
      assert {:ok, %Transaction{} = transaction} = Market.create_transaction(attrs)
      assert transaction.purchased_at == ~N[2010-04-17 14:00:00.000000]
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      poster_account = account_fixture()
      attrs = %{
        poster_account_id: poster_account.id,
        requester_account_id: account_fixture().id,
        coupon_id: coupon_fixture(poster_account.id).id
      }
      attrs = Map.merge(attrs, @invalid_attrs)
      assert {:error, %Ecto.Changeset{}} = Market.create_transaction(attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      poster_account = account_fixture()
      transaction = transaction_fixture(%{
        poster_account_id: poster_account.id,
        requester_account_id: account_fixture().id,
        coupon_id: coupon_fixture(poster_account.id).id
      })
      assert {:ok, transaction} = Market.update_transaction(transaction, @update_attrs)
      assert %Transaction{} = transaction
      assert transaction.purchased_at == ~N[2011-05-18 15:01:01.000000]
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      poster_account = account_fixture()
      transaction = transaction_fixture(%{
        poster_account_id: poster_account.id,
        requester_account_id: account_fixture().id,
        coupon_id: coupon_fixture(poster_account.id).id
      })
      assert {:ok, transaction} = Market.update_transaction(transaction, @update_attrs)
      assert {:error, %Ecto.Changeset{}} = Market.update_transaction(transaction, @invalid_attrs)
      assert transaction == Market.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      poster_account = account_fixture()
      transaction = transaction_fixture(%{
        poster_account_id: poster_account.id,
        requester_account_id: account_fixture().id,
        coupon_id: coupon_fixture(poster_account.id).id
      })
      assert {:ok, %Transaction{}} = Market.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Market.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      poster_account = account_fixture()
      transaction = transaction_fixture(%{
        poster_account_id: poster_account.id,
        requester_account_id: account_fixture().id,
        coupon_id: coupon_fixture(poster_account.id).id
      })
      assert %Ecto.Changeset{} = Market.change_transaction(transaction)
    end
  end

  describe "purchasing" do
    test "successful purchase" do
      poster_account = account_fixture()
      coupon = coupon_fixture(poster_account.id, %{value: 2}) 
      requester_account = account_fixture(%{balance: 10})
      {:ok, transaction} = Market.purchase_coupon(requester_account.id, coupon.id)

      upd_poster_account = Market.get_account!(poster_account.id)
      upd_requester_account = Market.get_account!(requester_account.id)
      upd_coupon = Market.get_coupon!(coupon.id)

      assert upd_coupon.sold_at != nil
      assert upd_requester_account.balance == (requester_account.balance - coupon.value)
      assert upd_poster_account.balance == (poster_account.balance + coupon.value - (coupon.value*0.05))
      assert transaction.poster_account_id == poster_account.id
      assert transaction.requester_account_id == requester_account.id
      assert transaction.coupon_id == coupon.id
    end

    test "successful second purchase attempt of same coupon" do
      poster_account = account_fixture()
      coupon = coupon_fixture(poster_account.id, %{value: 2}) 
      first_requester_account = account_fixture(%{balance: 10})
      {:ok, transaction} = Market.purchase_coupon(first_requester_account.id, coupon.id)

      upd_poster_account = Market.get_account!(poster_account.id)
      upd_requester_account = Market.get_account!(first_requester_account.id)
      upd_coupon = Market.get_coupon!(coupon.id)

      assert upd_coupon.sold_at != nil
      assert upd_requester_account.balance == (first_requester_account.balance - coupon.value)
      assert upd_poster_account.balance == (poster_account.balance + coupon.value - (coupon.value*0.05))
      assert transaction.poster_account_id == poster_account.id
      assert transaction.requester_account_id == first_requester_account.id
      assert transaction.coupon_id == coupon.id

      second_requester_account = account_fixture(%{balance: 10})
      {:error, error_message} = Market.purchase_coupon(second_requester_account.id, coupon.id)
      assert error_message == "coupon #{coupon.id} already sold"
    end

    test "deny purchase from requester with balance of 0" do
      poster_account = account_fixture()
      coupon = coupon_fixture(poster_account.id, %{value: 2}) 
      requester_account = account_fixture(%{balance: 0})

      {:error, error_message} = Market.purchase_coupon(requester_account.id, coupon.id)
      assert error_message == "insufficient funds"
    end

    test "deny purchase from requester with balance less than the coupon value" do
      poster_account = account_fixture()
      coupon = coupon_fixture(poster_account.id, %{value: 20}) 
      requester_account = account_fixture(%{balance: 19.50})

      {:error, error_message} = Market.purchase_coupon(requester_account.id, coupon.id)
      assert error_message == "insufficient funds"
    end

    test "deny purchase from requester with low balance, then deposit, then success" do
      poster_account = account_fixture()
      coupon = coupon_fixture(poster_account.id, %{value: 20.00}) 
      requester_account = account_fixture(%{balance: 18.00})

      {:error, error_message} = Market.purchase_coupon(requester_account.id, coupon.id)
      assert error_message == "insufficient funds"

      # deposit money
      Market.deposit_to_account(10.00, requester_account.id)
      requester_account = Repo.get!(Account, requester_account.id)

      # try again
      {:ok, transaction} = Market.purchase_coupon(requester_account.id, coupon.id)
      upd_poster_account = Market.get_account!(poster_account.id)
      upd_requester_account = Market.get_account!(requester_account.id)
      upd_coupon = Market.get_coupon!(coupon.id)

      assert upd_coupon.sold_at != nil
      assert upd_requester_account.balance == (requester_account.balance - coupon.value)
      assert upd_poster_account.balance == (poster_account.balance + coupon.value - (coupon.value*0.05))
      assert transaction.poster_account_id == poster_account.id
      assert transaction.requester_account_id == requester_account.id
      assert transaction.coupon_id == coupon.id
    end
  end

  describe "users" do
    @valid_attrs %{email: "test@example.com", name: "Test User 1", password: "secret"}

    def user_fixture(attrs \\ %{}) do
        attrs = attrs
        |> Enum.into(@valid_attrs)

      {:ok, user} =
        #Repo.insert(CouponMarket.Coherence.User, attrs)
        %CouponMarket.Coherence.User{} |> CouponMarket.Coherence.User.changeset(attrs) |> Repo.insert
      user
    end

    test "list market users" do
      user1 = user_fixture(%{email: "aaaa@example.com", name: "Test User A"})
      user2 = user_fixture(%{email: "cccc@example.com", name: "Test User C"})
      user3 = user_fixture(%{email: "bbbb@example.com", name: "Test User B"})
      user_ids = Enum.map([user1, user3, user2], fn(u) -> u.id end)

      assert user_ids == Enum.map(Market.list_users_by_name(), fn(u) -> u.id end)
    end
  end

  describe "market" do
    test "get market value" do
      poster_account = account_fixture(%{balance: 10.00})
      coupon1 = coupon_fixture(poster_account.id, %{value: 20.00}) 
      _coupon2 = coupon_fixture(poster_account.id, %{value: 10.00}) 
      coupon3 = coupon_fixture(poster_account.id, %{value: 30.00}) 
      requester_account = account_fixture(%{balance: 90.00})

      {:ok, _transaction} = Market.purchase_coupon(requester_account.id, coupon1.id)
      {:ok, _transaction} = Market.purchase_coupon(requester_account.id, coupon3.id)

      assert Market.market_value() == (20.00 + 30.00) * 0.05
    end
  end
end
