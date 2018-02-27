use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :coupon_market, CouponMarketWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :coupon_market, CouponMarket.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "coupon_market_test",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox
