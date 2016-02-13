defmodule Ledx.Led do
  use GenServer

  @atomic_actions [:on, :off, :toggle]
  defstruct [:name, :module, :config, state: :off, timer: nil]

  def start_link(led_name, module, config) do
    GenServer.start_link(__MODULE__, {led_name, module, config}, [name: led_name])
  end

  def state(led), do: GenServer.call(led, :state)

  def turn_on(led), do: GenServer.cast(led, :on)

  def turn_off(led), do: GenServer.cast(led, :off)

  def toggle(led), do: GenServer.cast(led, :toggle)

  def loop(led, on_off), do: loop(led, on_off, on_off)

  def loop(led, on, off), do: GenServer.cast(led, {:loop, on, off})

  def alive(led, time), do: GenServer.cast(led, {:alive, time})

  # GenServer callbacks

  def init({name, module, config}) do
    config = Map.merge(config, module.init(config))
    state = %__MODULE__{name: name, module: module, config: config}
    {:ok, state}
  end

  def handle_call(:state, _from, %__MODULE__{state: current_state} = state) do
    {:reply, current_state, state}
  end

  def handle_cast(action, %__MODULE__{} = state) when action in @atomic_actions do
    state
    |> cancel_timer
    |> perform(action)
    |> noreply
  end

  def handle_cast({:loop, on, off}, %__MODULE__{} = state) do
    state
    |> cancel_timer
    |> schedule({:loop, on, off}, 0)
    |> do_turn(:off)
    |> noreply
  end

  def handle_cast({:alive, time}, %__MODULE__{} = state) do
    state
    |> cancel_timer
    |> schedule(:alive, time)
    |> do_turn(:on)
    |> noreply
  end

  def handle_info({:loop, time, next_time}, %__MODULE__{} = state) do
    state
    |> cancel_timer
    |> schedule({:loop, next_time, time}, time)
    |> do_toggle
    |> noreply
  end

  def handle_info(:alive, %__MODULE__{} = state) do
    state
    |> cancel_timer
    |> do_turn(:off)
    |> noreply
  end

  defp cancel_timer(%__MODULE__{timer: nil} = state), do: state
  defp cancel_timer(%__MODULE__{timer: timer} = state) do
    Process.cancel_timer(timer)
    %{state | timer: nil}
  end

  defp schedule(%__MODULE__{} = state, message, timeout) do
    %{state | timer: Process.send_after(self, message, timeout)}
  end

  defp noreply(%__MODULE__{} = state), do: {:noreply, state}

  defp perform(%__MODULE__{} = state, :toggle), do: do_toggle(state)
  defp perform(%__MODULE__{} = state, action), do: do_turn(state, action)

  defp do_toggle(%__MODULE__{state: :on} = state), do: do_turn(state, :off)
  defp do_toggle(%__MODULE__{state: :off} = state), do: do_turn(state, :on)

  defp do_turn(%__MODULE__{state: action} = state, action), do: state
  defp do_turn(%__MODULE__{module: module} = state, action) do
    %{state | config: apply(module, action, [state.config]), state: action}
  end
end
