defmodule CouponMarketWeb.Router do
  use CouponMarketWeb, :router
  # use CouponMarketWeb.Coherence, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CouponMarketWeb do
    pipe_through :browser # Use the default browser stack
    coherence_routes()
  end

  scope "/", CouponMarketWeb do
    pipe_through :protected # Use the default browser stack
    coherence_routes :protected
  end

  scope "/", CouponMarketWeb do
    pipe_through :browser # Use the default browser stack
    
    get "/", PageController, :index
  end

  scope "/", CouponMarketWeb do
    pipe_through :protected

    resources "/accounts", AccountController
    resources "/coupons", CouponController
    resources "/brands", BrandController
    resources "/transactions", TransactionController
  end

  # Other scopes may use custom stacks.
  # scope "/api", CouponMarketWeb do
  #   pipe_through :api
  # end
end
