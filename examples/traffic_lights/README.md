# TrafficLights

Simple example on how to use Ledx with nerves

## What's inside?

Three LEDs are started using `config/config.exs`. You can change the Gpio pins there.

Then in `lib/traffic_lights.ex` the LEDs are turned in order to simulate traffic lights.

## Running it

This example uses [bakeware](http://www.bakeware.io/) to create a image you can
run in your device (it has only been tested on a raspberry-pi 2)

Install bake:

```bash
ruby -e "$(curl -fsSL https://bakeware.herokuapp.com/bake/install)"
```

Download system and toolchain:
```bash
bake system get --target rpi2
bake toolchain get --target rpi2
```

Compile and generate image:
```bash
bake firmware  --target rpi2
```

Burn the image to SD:
```bash
sudo fwup -a -i _images/traffic_lights-rpi2.fw -t complete
```
