defmodule MyDoctor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      MyDoctor.Repo,
      # Start the Telemetry supervisor
      MyDoctorWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MyDoctor.PubSub},
      # Start the Endpoint (http/https)
      MyDoctorWeb.Endpoint
      # Start a worker by calling: MyDoctor.Worker.start_link(arg)
      # {MyDoctor.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyDoctor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MyDoctorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
