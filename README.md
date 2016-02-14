# Ledx

Ledx is a simple library for interfacing with LEDs on embedded platforms.

## Usage

### Starting leds

To start a led, you need to call `start_link/3` passing a name for the led, a driver module, and the configuration needed for the driver.

```elixir
{:ok, _pid} = Ledx.Led.start_link(:my_led, Ledx.Drivers.Gpio, %{pin: 18})
```
Ledx register the leds with names, so you don't have to carry pid's around.

### Turning on/off a led

Given our previously started led, we could turn it on doing:

```elixir
Ledx.Led.turn_on(:my_led)
# the led is on!
```

Then turn it off calling:
```elixir
Ledx.Led.turn_off(:my_led)
# the led is off
```

We could also toogle it:
```elixir
Ledx.Led.toogle(:my_led)
# the led is on
Ledx.Led.toogle(:my_led)
# the led is off
```

### Pulses

Sometimes you want to turn on a LED just for a certain time:

```elixir
Ledx.Led.turn_on(:my_led, 100)
# the led is on for 100 ms
# then off
```

Or turn it off for a certain time:

```elixir
Ledx.Led.turn_off(:my_led, 100)
# the led is off for 100 ms
# then on
```

```elixir
Ledx.Led.toggle(:my_led, 100)
# the led toggles for 100 ms
# then toggles again
```

### Blink

It's also really easy to repeatedly blink a led:

```elixir
Ledx.Led.blink(:my_led, 100, 50)
# the led is on for 100 ms
# then off for 50 ms
# then on for 100 ms
# ...
```

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
