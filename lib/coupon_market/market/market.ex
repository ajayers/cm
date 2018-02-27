import Logger

defmodule CouponMarket.Market do
  @moduledoc """
  The Market context.
  """

  import Ecto.Query, warn: false
  alias CouponMarket.Repo
  alias CouponMarket.Market.Transaction

  alias CouponMarket.Market.Account

  @market_cut 0.05

  @doc """
  Purchases a coupon for an account.

  ## Examples
  
      ie> purchase_coupon(1, 2)
      {:ok, 2134}

  """
  def purchase_coupon(requester_account_id, coupon_id) do
    query = Ecto.Adapters.SQL.query(Repo,
      "select purchase_coupon($1::BIGINT, $2::BIGINT)",
      [requester_account_id, coupon_id])

    case query do
      {:ok, %Postgrex.Result{rows: [[transaction_id]]}} ->
        {:ok, Repo.get(Transaction, transaction_id)}
      {:error, %Postgrex.Error{postgres: %{message: message}}} ->
        {:error, message}
    end
  end

  @doc """
  Deposits funds into account.

  ## Examples

      iex> deposit_to_account(1.0, 1)
      2

  """
  def deposit_to_account(amount, account_id) do
    q = {:ok, %Postgrex.Result{num_rows: 1}} =  Ecto.Adapters.SQL.query(Repo,
      "UPDATE accounts SET balance = balance + $1 WHERE id = $2",
      [amount, account_id])

    account = Repo.get(Account, account_id)
    account.balance
  end

  @doc """
  Lists all users ordered by name.

  ## Examples

      iex> list_users_by_name()
      2

  """
  def list_users_by_name() do
    CouponMarket.Coherence.User |> Ecto.Query.order_by(:name) |> Repo.all
  end

  @doc """
  Returns the total market value (sum of transactions * 5%)

  ## Examples
  
      ie> market_value
      0.45

  """
  def market_value() do
    q = from t in Transaction,
    join: coupon in assoc(t, :coupon),
    select: sum(coupon.value)

    [value_sum] = Repo.all(q)
    value_sum * @market_cut
  end


  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  def list_accounts(owner_id) do
    Account
    |> Ecto.Query.where(owner_id: ^owner_id)
    |> Repo.all
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Gets a single account by owner_id.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account_by_owner(123)
      %Account{}
  """
  def get_account_by_owner(owner_id) do
    Account
    |> where(owner_id: ^owner_id)
    |> limit(1)
    |> Repo.one
  end

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(1, %{balance: 10.0})
      {:ok, %Account{}}

      iex> create_account(1, %{balance: -13})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(owner_id, attrs \\ %{}) do
    all_attrs = attrs 
    |> Map.put(:owner_id, owner_id)

    %Account{}
    |> Account.changeset(all_attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{balance: 20})
      {:ok, %Account{}}

      iex> update_account(account, %{balance: nil})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{source: %Account{}}

  """
  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end

  alias CouponMarket.Market.Brand

  @doc """
  Returns the list of brands.

  ## Examples

      iex> list_brands()
      [%Brand{}, ...]

  """
  def list_brands do
    Repo.all(Brand)
  end

  @doc """
  Gets a single brand.

  Raises `Ecto.NoResultsError` if the Brand does not exist.

  ## Examples

      iex> get_brand!(123)
      %Brand{}

      iex> get_brand!(456)
      ** (Ecto.NoResultsError)

  """
  def get_brand!(id), do: Repo.get!(Brand, id)

  @doc """
  Creates a brand.

  ## Examples

      iex> create_brand(%{name: "a name"})
      {:ok, %Brand{}}

      iex> create_brand(%{name: nil})
      {:error, %Ecto.Changeset{}}

  """
  def create_brand(attrs \\ %{}) do
    %Brand{}
    |> Brand.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a brand.

  ## Examples

      iex> update_brand(brand, %{name: "valid name"})
      {:ok, %Brand{}}

      iex> update_brand(brand, %{name: nil})
      {:error, %Ecto.Changeset{}}

  """
  def update_brand(%Brand{} = brand, attrs) do
    brand
    |> Brand.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Brand.

  ## Examples

      iex> delete_brand(brand)
      {:ok, %Brand{}}

      iex> delete_brand(brand)
      {:error, %Ecto.Changeset{}}

  """
  def delete_brand(%Brand{} = brand) do
    Repo.delete(brand)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking brand changes.

  ## Examples

      iex> change_brand(brand)
      %Ecto.Changeset{source: %Brand{}}

  """
  def change_brand(%Brand{} = brand) do
    Brand.changeset(brand, %{})
  end

  alias CouponMarket.Market.Coupon

  @doc """
  Returns the list of coupons.

  ## Examples

      iex> list_coupons()
      [%Coupon{}, ...]

  """
  def list_coupons do
    Repo.all(Coupon)
  end

  @doc """
  Gets a single coupon.

  Raises `Ecto.NoResultsError` if the Coupon does not exist.

  ## Examples

      iex> get_coupon!(123)
      %Coupon{}

      iex> get_coupon!(456)
      ** (Ecto.NoResultsError)

  """
  def get_coupon!(id), do: Repo.get!(Coupon, id)

  @doc """
  Creates a coupon.

  ## Examples

      iex> create_coupon(1, %{value: 3.0})
      {:ok, %Coupon{}}

      iex> create_coupon(1, %{value: nil})
      {:error, %Ecto.Changeset{}}

  """
  def create_coupon(account_id, attrs \\ %{}) do
    attrs = attrs
    |> Map.put(:account_id, account_id)

    %Coupon{}
    |> Coupon.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a coupon.

  ## Examples

      iex> update_coupon(coupon, %{field: new_value})
      {:ok, %Coupon{}}

      iex> update_coupon(coupon, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_coupon(%Coupon{} = coupon, attrs) do
    coupon
    |> Coupon.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Coupon.

  ## Examples

      iex> delete_coupon(coupon)
      {:ok, %Coupon{}}

      iex> delete_coupon(coupon)
      {:error, %Ecto.Changeset{}}

  """
  def delete_coupon(%Coupon{} = coupon) do
    Repo.delete(coupon)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking coupon changes.

  ## Examples

      iex> change_coupon(coupon)
      %Ecto.Changeset{source: %Coupon{}}

  """
  def change_coupon(%Coupon{} = coupon) do
    Coupon.changeset(coupon, %{})
  end


  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{source: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end
end
