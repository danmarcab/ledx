defmodule TestSenderDriver do
  @behaviour Ledx.Driver

  def init(config), do: config

  def on(config) do
    send(config.caller, :on)
    config
  end

  def off(config) do
    send(config.caller, :off)
    config
  end
end
