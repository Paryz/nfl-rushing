import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :rush_hour, RushHour.Repo,
  username: "postgres",
  password: "mysecretpassword",
  database: "rush_hour_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  port: 5433,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rush_hour, RushHourWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "jO/W+G/Qx2j1vaL3e08mem3yYnkgOD2lRNuZaK4/cT17Ehpo5rrUoOGigq5RjxOu",
  server: false

# In test we don't send emails.
config :rush_hour, RushHour.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
