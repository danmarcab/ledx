defmodule Ledx.LedController do
  use GenServer

  def start_link(led_name, module, config) do
    GenServer.start_link(__MODULE__, {module, config}, [name: led_name])
  end

  def init({module, config}) do
    state = %{module: module, config: config}
    {:ok, state}
  end

  def on(led) do
    GenServer.cast(led, :on)
  end

  def off(led) do
    GenServer.cast(led, :off)
  end

  def handle_cast(:on, %{module: module, config: config} = state) do
    module.on(config)
    {:noreply, state}
  end

  def handle_cast(:off, %{module: module, config: config} = state) do
    module.off(config)
    {:noreply, state}
  end
end
