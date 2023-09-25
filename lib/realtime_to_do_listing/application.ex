defmodule RealtimeToDoListing.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RealtimeToDoListingWeb.Telemetry,
      # Start the Ecto repository
      RealtimeToDoListing.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: RealtimeToDoListing.PubSub},
      # Start the Endpoint (http/https)
      RealtimeToDoListingWeb.Endpoint
      # Start a worker by calling: RealtimeToDoListing.Worker.start_link(arg)
      # {RealtimeToDoListing.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RealtimeToDoListing.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RealtimeToDoListingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
