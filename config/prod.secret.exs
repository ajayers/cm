use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :coupon_market, CouponMarketWeb.Endpoint,
  secret_key_base: "WPG3F6kFWMse54b5rkROrdny5dimZrQdLydlRuzsZzuCQui8g7pF+3aIQozhnzVw"

# Configure your database
config :coupon_market, CouponMarket.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "coupon_market_prod",
  pool_size: 15
