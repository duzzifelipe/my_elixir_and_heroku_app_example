# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :my_app,
  ecto_repos: [MyApp.Repo]

# Configures the endpoint
config :my_app, MyAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "N6X3PDJv3hKhFb8Y9ai8TT++ZTSpRJooVAD2aGh+F51udZow5gEOfvQG76jQWReB",
  render_errors: [view: MyAppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MyApp.PubSub,
  live_view: [signing_salt: "0NCg0Y/Q"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
