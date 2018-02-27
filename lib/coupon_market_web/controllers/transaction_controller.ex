defmodule CouponMarketWeb.TransactionController do
  use CouponMarketWeb, :controller

  alias CouponMarket.Market
  alias CouponMarket.Market.Transaction

  def index(conn, _params) do
    transactions = Market.list_transactions()
    render(conn, "index.html", transactions: transactions)
  end

  def new(conn, _params) do
    changeset = Market.change_transaction(%Transaction{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"transaction" => transaction_params}) do
    case Market.create_transaction(transaction_params) do
      {:ok, transaction} ->
        conn
        |> put_flash(:info, "Transaction created successfully.")
        |> redirect(to: transaction_path(conn, :show, transaction))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Market.get_transaction!(id)
    render(conn, "show.html", transaction: transaction)
  end

  def edit(conn, %{"id" => id}) do
    transaction = Market.get_transaction!(id)
    changeset = Market.change_transaction(transaction)
    render(conn, "edit.html", transaction: transaction, changeset: changeset)
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Market.get_transaction!(id)

    case Market.update_transaction(transaction, transaction_params) do
      {:ok, transaction} ->
        conn
        |> put_flash(:info, "Transaction updated successfully.")
        |> redirect(to: transaction_path(conn, :show, transaction))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", transaction: transaction, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction = Market.get_transaction!(id)
    {:ok, _transaction} = Market.delete_transaction(transaction)

    conn
    |> put_flash(:info, "Transaction deleted successfully.")
    |> redirect(to: transaction_path(conn, :index))
  end
end
