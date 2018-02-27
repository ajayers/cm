import Logger

defmodule CouponMarketWeb.AccountController do
  use CouponMarketWeb, :controller

  alias CouponMarket.Market
  alias CouponMarket.Market.Account

  def index(conn, _params) do
    user = conn |> Coherence.current_user()
    accounts = user.id |> Market.list_accounts()
    render(conn, "index.html", accounts: accounts)
  end

  def new(conn, _params) do
    changeset = Market.change_account(%Account{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"account" => account_params}) do
    user  = conn |> Coherence.current_user()

    case Market.create_account(user.id, account_params) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account created successfully.")
        |> redirect(to: account_path(conn, :show, account))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    account = Market.get_account!(id)
    render(conn, "show.html", account: account)
  end

  def edit(conn, %{"id" => id}) do
    account = Market.get_account!(id)
    changeset = Market.change_account(account)
    render(conn, "edit.html", account: account, changeset: changeset)
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Market.get_account!(id)

    case Market.update_account(account, account_params) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account updated successfully.")
        |> redirect(to: account_path(conn, :show, account))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", account: account, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Market.get_account!(id)
    {:ok, _account} = Market.delete_account(account)

    conn
    |> put_flash(:info, "Account deleted successfully.")
    |> redirect(to: account_path(conn, :index))
  end
end
