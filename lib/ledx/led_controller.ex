defmodule Ledx.LedController do
  use GenServer

  defstruct [:name, :module, :config, state: :off, loop_type: :generic, timer: nil]

  def start_link(led_name, module, config) do
    GenServer.start_link(__MODULE__, {led_name, module, config}, [name: led_name])
  end

  def init({name, module, config}) do
    config = Map.merge(config, module.init(config))
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

  def handle_cast(:on, %__MODULE__{timer: timer} = state) do
    if timer, do: Process.cancel_timer(timer)
    {:noreply, do_turn_on(state)}
  end

  def handle_cast(:off, %__MODULE__{timer: timer} = state) do
    if timer, do: Process.cancel_timer(timer)
    {:noreply, do_turn_off(state)}
  end

  def handle_cast(:toggle, %__MODULE__{timer: timer} = state) do
    if timer, do: Process.cancel_timer(timer)
    {:noreply, do_toggle(state)}
  end

  def handle_cast({:loop, on, off}, %__MODULE__{module: module, loop_type: :callback} = state) do
    new_config = Map.put(state.config, :loop, %{on: on, off: off})

    state = %{state |
      config: module.loop(new_config, on, off),
      state: :loop
    }
    {:noreply, state}
  end

  def handle_cast({:loop, on, off}, %__MODULE__{loop_type: :generic, timer: timer} = state) do
    new_config = Map.put(state.config, :loop, %{on: on, off: off})
    if timer, do: Process.cancel_timer(timer)
    timer = Process.send_after(self, :loop, 0)
    {:noreply, %{state | config: new_config, timer: timer}}
  end

  def handle_info(:loop, %__MODULE__{state: :on, timer: timer, config: %{loop: %{off: timeout}}} = state) do
    if timer, do: Process.cancel_timer(timer)
    timer = Process.send_after(self, :loop, timeout)
    {:noreply, do_turn_off(%{state | timer: timer})}
  end

  def handle_info(:loop, %__MODULE__{state: :off, timer: timer, config: %{loop: %{on: timeout}}} = state) do
    if timer, do: Process.cancel_timer(timer)
    timer = Process.send_after(self, :loop, timeout)
    {:noreply, do_turn_on(%{state | timer: timer})}
  end

  defp do_toggle(%__MODULE__{state: :on} = state) do
    do_turn_off(state)
  end

  defp do_toggle(%__MODULE__{state: :off} = state) do
    do_turn_on(state)
  end

  defp do_turn_on(%__MODULE__{module: module} = state) do
    %{state |
      config: module.on(state.config),
      state: :on
    }
  end

  defp do_turn_off(%__MODULE__{module: module} = state) do
    %{state |
      config: module.off(state.config),
      state: :off
    }
  end
end
