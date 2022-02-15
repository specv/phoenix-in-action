defmodule AuctionWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AuctionWeb.Telemetry,
      # Start the Endpoint (http/https)
      AuctionWeb.Endpoint,
      # Start a worker by calling: AuctionWeb.Worker.start_link(arg)
      # {AuctionWeb.Worker, arg}

      # mix phx.new.web auction_web --no-ecto
      # Your web app requires a PubSub server to be running.
      # The PubSub server is typically defined in a `mix phx.new.ecto` app.
      # If you don't plan to define an Ecto app, you must explicitly start
      # the PubSub in your supervision tree as:
      # {Phoenix.PubSub, name: AuctionWeb.PubSub}
      {Phoenix.PubSub, name: AuctionWeb.PubSub},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AuctionWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AuctionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
