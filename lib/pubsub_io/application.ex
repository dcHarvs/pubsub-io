defmodule PubsubIo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PubsubIoWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:pubsub_io, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PubsubIo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PubsubIo.Finch},
      # Start a worker by calling: PubsubIo.Worker.start_link(arg)
      # {PubsubIo.Worker, arg},
      # Start to serve requests, typically the last entry
      PubsubIoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PubsubIo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PubsubIoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
