# Ledx

Ledx is a simple library for interfacing with LEDs on embedded platforms.

## Installation

1. Add ledx to your list of dependencies in `mix.exs`:

        def deps do
          [{:ledx, "~> 0.0.1"}]
        end

2. Ensure ledx is started before your application:

        def application do
          [applications: [:ledx]]
        end

Ledx depends on [elixir-ale](https://github.com/fhunleth/elixir_ale) for interfacing
with GPIO. Follow the instructions on [getting-started](https://github.com/fhunleth/elixir_ale#getting-started)
if you are cross-compiling.

## Usage

### Configure your LEDs

You can configure your LEDs easily in your config.exs file.

```elixir
config :ledx, leds:
  [{:led1, :gpio, %{pin: 18}},
   {:led2, :gpio, %{pin: 17}}]
```

This will make `:led1` and `:led2` be available when your app is started.

### Start a LED after application start

You can also start a LED from your code. Just pass the led name, the led type,
and the led configuration.

```elixir
{:ok, _pid} = Ledx.start_led(:my_led, :gpio, %{pin: 18})
```

Currently only `:gpio` is supported, see [advanced](#Advanced) if you want
to implement your own types.

### Turning on/off a led

Given our previously started led, we could turn it on doing:

```elixir
Ledx.turn_on(:my_led)
# the led is on!
```

Then turn it off calling:
```elixir
Ledx.turn_off(:my_led)
# the led is off
```

We could also toogle it:
```elixir
Ledx.toogle(:my_led)
# the led is on
Ledx.toogle(:my_led)
# the led is off
```

### Pulses

Sometimes you want to turn on a LED just for a certain time:

```elixir
Ledx.turn_on(:my_led, 100)
# the led is on for 100 ms
# then off
```

Or turn it off for a certain time:

```elixir
Ledx.turn_off(:my_led, 100)
# the led is off for 100 ms
# then on
```

Or toggle it for a certain time:

```elixir
Ledx.toggle(:my_led, 100)
# the led toggles for 100 ms
# then toggles again
```

### Blink

It's also really easy to repeatedly blink a led:

```elixir
Ledx.blink(:my_led, 100, 50)
# the led is on for 100 ms
# then off for 50 ms
# then on for 100 ms
# ...
```

## Advanced

### Implementing you own drivers

You just need to implement the `Ledx.Driver` behaviour:

```elixir
defmodule MyDriver do
  @behaviour Ledx.Driver

  def init(config) do
    # your init code here
    config
  end

  def on(config) do
    # your code that turns the led on
    config
  end

  def off(config) do
    # your code that turns the led off
    config
  end
end
```

You can check the implementation of `Ledx.Drivers.Gpio` to see an example.

### Starting LEDs using your own drivers

To start a led, you need to call `start_led/3` passing a name for the led, a driver
module, and the configuration needed for the driver.

```elixir
{:ok, _pid} = Ledx.start_led(:my_led, MyDriver, %{pin: 18})
```

You can also start LEDs with your own drivers, using the `config.exs` file:

```elixir
config :ledx, leds:
  [{:led1, MyDriver, %{path: "/dev/led/led1"}},
   {:led2, MyDriver, %{path: "/dev/led/led2"}}]
```

## TODO

* docs
* example app
