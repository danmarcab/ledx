defmodule Ledx.Drivers.Gpio do
  @behaviour Ledx.Driver

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
