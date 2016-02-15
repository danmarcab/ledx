defmodule Ledx do
  @moduledoc """
  Provides access to all the `Ledx` library.
  Start, stop, turn on, turn off or blink LEDs.
  """

  use Application
  import Supervisor.Spec, warn: false
  alias Ledx.Led

  @doc """
  Starts `Ledx` application. You shouldn't call it directly, just add `ledx` to
  the application list in your `mix.exs` file.
  """
  def start(_type, _args) do
    children =
      Application.get_env(:ledx, :leds, [])
      |> Enum.map(&worker_args/1)
      |> Enum.map(fn([name|_rest] = args) ->
        worker(Ledx.Led, args, id: name)
      end)

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Starts a LED. It receives the led name, the driver module and the configuation
  map. It register a process with the led name to handle the led.

      iex> Process.whereis(:new_led)
      nil
      iex> Ledx.start_led(:new_led, TestDriver, %{})
      iex> is_pid(Process.whereis(:new_led))
      true
  """
  def start_led(name, module, config) do
    child = worker(Ledx.Led, worker_args({name, module, config}), id: name)
    Supervisor.start_child(__MODULE__, child)
  end

  @doc """
  Stops a previously started LED by name.

      iex> Process.whereis(:started_led)
      nil
      iex> Ledx.start_led(:started_led, TestDriver, %{})
      iex> is_pid(Process.whereis(:started_led))
      true
      iex> Ledx.stop_led(:started_led)
      iex> Process.whereis(:started_led)
      nil
  """
  def stop_led(name) do
    :ok = Supervisor.terminate_child(__MODULE__, name)
    :ok = Supervisor.delete_child(__MODULE__, name)
  end

  @doc """
  Gets the state of a started LED.

        iex> Ledx.state(:test_led)
        :off
        iex> Ledx.turn_on(:test_led)
        iex> Ledx.state(:test_led)
        :on
  """
  defdelegate state(led), to: Led

  @doc """
  Turn on a started LED.

      iex> Ledx.state(:test_led)
      :off
      iex> Ledx.turn_on(:test_led)
      iex> Ledx.state(:test_led)
      :on
  """
  defdelegate turn_on(led), to: Led

  @doc """
  Turn on a started LED for a certain time.

      iex> Ledx.state(:test_led)
      :off
      iex> Ledx.turn_on(:test_led, 50)
      iex> Ledx.state(:test_led)
      :on
      iex> :timer.sleep(55)
      iex> Ledx.state(:test_led)
      :off
  """
  defdelegate turn_on(led, time), to: Led

  @doc """
  Turn off a started LED.

      iex> Ledx.turn_on(:test_led)
      iex> Ledx.state(:test_led)
      :on
      iex> Ledx.turn_off(:test_led)
      iex> Ledx.state(:test_led)
      :off
  """
  defdelegate turn_off(led), to: Led

  @doc """
  Turn off a started LED for a certain time.

      iex> Ledx.turn_on(:test_led)
      iex> Ledx.state(:test_led)
      :on
      iex> Ledx.turn_off(:test_led, 50)
      iex> Ledx.state(:test_led)
      :off
      iex> :timer.sleep(55)
      iex> Ledx.state(:test_led)
      :on
  """
  defdelegate turn_off(led, time), to: Led

  @doc """
  Toggle a started LED.

      iex> Ledx.state(:test_led)
      :off
      iex> Ledx.toggle(:test_led)
      iex> Ledx.state(:test_led)
      :on
      iex> Ledx.toggle(:test_led)
      iex> Ledx.state(:test_led)
      :off
  """
  defdelegate toggle(led), to: Led

  @doc """
  Toggle a started LED for a certain time.

      iex> Ledx.state(:test_led)
      :off
      iex> Ledx.toggle(:test_led, 50)
      iex> Ledx.state(:test_led)
      :on
      iex> :timer.sleep(55)
      iex> Ledx.state(:test_led)
      :off
  """
  defdelegate toggle(led, time), to: Led

  @doc """
  Blink a started LED.

      iex> Ledx.state(:test_led)
      :off
      iex> Ledx.blink(:test_led, 50)
      iex> :timer.sleep(10)
      iex> Ledx.state(:test_led)
      :on
      iex> :timer.sleep(50)
      iex> Ledx.state(:test_led)
      :off
      iex> :timer.sleep(50)
      iex> Ledx.state(:test_led)
      :on
  """
  defdelegate blink(led, time), to: Led

  @doc """
  Blink a started LED.

      iex> Ledx.state(:test_led)
      :off
      iex> Ledx.blink(:test_led, 30, 70)
      iex> :timer.sleep(10)
      iex> Ledx.state(:test_led)
      :on
      iex> :timer.sleep(30)
      iex> Ledx.state(:test_led)
      :off
      iex> :timer.sleep(70)
      iex> Ledx.state(:test_led)
      :on
  """
  defdelegate blink(led, time_on, time_off), to: Led

  defp worker_args({name, module, config}) do
    [name, driver_module(module), config]
  end

  defp driver_module(:gpio), do: Ledx.Drivers.Gpio
  defp driver_module(module), do: module

end
