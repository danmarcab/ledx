defmodule Ledx.LedController do
  use GenServer

  defstruct [:name, :module, :config, state: :off, loop_type: :generic, loop: nil]

  def start_link(led_name, module, config) do
    GenServer.start_link(__MODULE__, {led_name, module, config}, [name: led_name])
  end

  def init({name, module, config}) do
    state = %__MODULE__{name: name, module: module, config: config}
    {:ok, state}
  end

  def state(led) do
    GenServer.call(led, :state)
  end

  def turn_on(led) do
    GenServer.cast(led, :on)
  end

  def turn_off(led) do
    GenServer.cast(led, :off)
  end

  def toggle(led) do
    GenServer.cast(led, :toggle)
  end

  def loop(led, on_off) do
    loop(led, on_off, on_off)
  end

  def loop(led, on, off) do
    GenServer.cast(led, {:loop, on, off})
  end

  def handle_call(:state, _from, %__MODULE__{state: current_state} = state) do
    {:reply, current_state, state}
  end

  def handle_cast(:on, %__MODULE__{} = state) do
    {:noreply, do_turn_on(state)}
  end

  def handle_cast(:off, %__MODULE__{} = state) do
    {:noreply, do_turn_off(state)}
  end

  def handle_cast(:toggle, %__MODULE__{} = state) do
    {:noreply, do_toggle(state)}
  end

  def handle_cast({:loop, on, off}, %__MODULE__{module: module, loop_type: :callback} = state) do
    {:noreply, module.loop(state, on, off)}
  end

  def handle_cast({:loop, on, off}, %__MODULE__{module: module, loop_type: :generic} = state) do
    {:noreply, %{state | loop: %{on: on, off: off}}, 0}
  end

  def handle_info(:timeout, %__MODULE__{module: module, state: :on, loop: %{off: timeout}} = state) do
    {:noreply, do_turn_off(state), timeout}
  end

  def handle_info(:timeout, %__MODULE__{module: module, state: :off, loop: %{on: timeout}} = state) do
    {:noreply, do_turn_on(state), timeout}
  end

  defp do_toggle(%__MODULE__{state: :on} = state) do
    do_turn_off(state)
  end

  defp do_toggle(%__MODULE__{state: :off} = state) do
    do_turn_on(state)
  end

  defp do_turn_on(%__MODULE__{module: module} = state) do
    %{module.on(state) | state: :on}
  end

  defp do_turn_off(%__MODULE__{module: module} = state) do
    %{module.off(state) | state: :off}
  end
end
