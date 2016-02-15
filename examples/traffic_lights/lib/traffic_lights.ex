defmodule TrafficLights do
  def start(_type, _args) do
    Ledx.blink(:red, 10000, 10000)

    # wait before turning the yellow LED on
    :timer.sleep(9000)
    Ledx.blink(:yellow, 1000, 9000)

    # wait before turning the green LED on
    :timer.sleep(1000)
    Ledx.blink(:green, 10000, 10000)

    {:ok, self}
  end
end
