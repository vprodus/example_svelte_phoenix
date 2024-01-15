import Config

if System.get_env("PHX_SERVER") do
  config :example, ExampleWeb.Endpoint, server: true
  # check_origin: {ExampleWeb.OriginChecks, :cache_origin_allowed?, []}
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :example, Example.Repo,
    ssl: true,
    ssl_opts: [verify: :verify_none],
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6,
    queue_target: 5000,
    queue_interval: 5000,
    socket_options: maybe_ipv6

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST")
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :example, Example.Mailer,
    adapter: Swoosh.Adapters.Mailgun,
    api_key: System.get_env("MAILGUN_API_KEY"),
    domain: System.get_env("PHX_HOST"),
    base_url: "https://api.eu.mailgun.net/v3"

  # Configures Swoosh API Client
  config :swoosh, api_client: Swoosh.ApiClient.Hackney

  config :example, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :example, ExampleWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    force_ssl: [host: nil],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  config :example,
    apx_api_key: System.get_env("APX_API_KEY")
end
