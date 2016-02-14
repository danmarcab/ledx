defmodule Ledx do
  use Application
  import Supervisor.Spec, warn: false
  alias Ledx.Led

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    children =
      Application.get_env(:ledx, :leds, [])
      |> Enum.map(&worker_args/1)
      |> Enum.map(fn([name|_rest] = args) ->
        worker(Ledx.Led, args, id: name)
      end)

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end

  def start_led(name, module, config) do
    child = worker(Ledx.Led, worker_args({name, module, config}), id: name)
    Supervisor.start_child(__MODULE__, child)
  end

  def stop_led(name) do
    :ok = Supervisor.terminate_child(__MODULE__, name)
    :ok = Supervisor.delete_child(__MODULE__, name)
  end

  defdelegate state(led), to: Led
  defdelegate turn_on(led), to: Led
  defdelegate turn_on(led, time), to: Led
  defdelegate turn_off(led), to: Led
  defdelegate turn_off(led, time), to: Led
  defdelegate toggle(led), to: Led
  defdelegate toggle(led, time), to: Led
  defdelegate blink(led, time), to: Led
  defdelegate blink(led, time_on, time_off), to: Led

  defp worker_args({name, module, config}) do
    [name, driver_module(module), config]
  end

  defp driver_module(:gpio), do: Ledx.Drivers.Gpio
  defp driver_module(module), do: module

end
