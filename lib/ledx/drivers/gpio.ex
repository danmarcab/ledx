defmodule Ledx.Drivers.Gpio do
  @moduledoc """
  This module implements Ledx.Driver for Gpio based LEDs. It uses `elixir_ale`
  to interface with Gpio.
  """

  @behaviour Ledx.Driver

  @doc """
  Initialize a Gpio based LED. It should receive a map with at least the `:pin`
  key. This should be the Gpio pin number where the LED is connected.
  """
  def init(%{pin: n} = config) do
    {:ok, pid} = Gpio.start_link(n, :output)
    Map.put(config, :pid, pid)
  end

  def on(%{pid: pid} = config) do
    Gpio.write(pid, 1)
    config
  end

  def off(%{pid: pid} = config) do
    Gpio.write(pid, 0)
    config
  end
end
