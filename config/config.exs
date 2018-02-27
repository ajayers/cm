# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :coupon_market,
  ecto_repos: [CouponMarket.Repo]

# Configures the endpoint
config :coupon_market, CouponMarketWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Uvba1HvsKJeldjbbMIt5vTSsCjmHI7X/fdIGurGucdScKsedZIs3mSl5l1P+DwWs",
  render_errors: [view: CouponMarketWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CouponMarket.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: CouponMarket.Coherence.User,
  repo: CouponMarket.Repo,
  module: CouponMarket,
  web_module: CouponMarketWeb,
  router: CouponMarketWeb.Router,
  messages_backend: CouponMarketWeb.Coherence.Messages,
  logged_out_url: "/",
  email_from_name: "Your Name",
  email_from_email: "yourname@example.com",
  opts: [:authenticatable, :recoverable, :trackable, :registerable]

config :coherence, CouponMarketWeb.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "your api key here"
# %% End Coherence Configuration %%
