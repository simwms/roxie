# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :roxie, Roxie.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "nhCn1DfvMnDIZV+GJKVhwFSA7WsOGuzR1gpVktNQS0oOS8c1s6hkAEjDPp8HOmYU",
  master_key: "furishikiru-ame-ni-mi-o-kakusu-you-ni-shite-odoru",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Roxie.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config Aws, :defaults,
  service: "s3",
  name: "aws4_request",
  region: "us-east-1",
  access_key_id: System.get_env("AMAZON_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AMAZON_SECRET_ACCESS_KEY")