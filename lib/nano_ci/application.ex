defmodule NanoCi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      NanoCi.Repo,
      # Start the endpoint when the application starts
      NanoCiWeb.Endpoint,
      # Starts a worker by calling: NanoCi.Worker.start_link(arg)
      # {NanoCi.Worker, arg},
      NanoCi.Builder.Controller,
      NanoCi.StatusWriter
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NanoCi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NanoCiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
