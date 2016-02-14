defmodule TestDriver do
  @behaviour Ledx.Driver

  def init(config), do: config
  def on(config), do: config
  def off(config), do: config
end
