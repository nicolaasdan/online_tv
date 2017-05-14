# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :online_tv,
  ecto_repos: [OnlineTv.Repo]

# Configures the endpoint
config :online_tv, OnlineTv.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Je0m6TqjuxjKKKhVp+Kf7dtNCl7kJMHm4qYiO9i7Vi3FrRAxaGmdLaHF0WUID+H1",
  render_errors: [view: OnlineTv.ErrorView, accepts: ~w(html json)],
  pubsub: [name: OnlineTv.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :tubex, Tubex,
  api_key: "AIzaSyC36wPVsnJbngjTjxRwlsg5zGs_0Yf1akY"

config :extwitter, :oauth, [
   consumer_key: "yJi5ou9fL1Ht3QmsqE5jTWehy",
   consumer_secret: "0qkWpgc9nHJ8425GLxRcrC9qL5dd0Ewf9rkfOxshGowM0rbKQZ",
   access_token: "863399479277387776-xxW017VoyKscAlq6KqJX3FRfPMo11CF",
   access_token_secret: "tc34WtkrDldGaNTQb0Mp8O6xN9ZdR6RUPBfPnES8K8QWE"
]