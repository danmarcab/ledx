use Mix.Config

# Change the gpio pins here!
config :ledx, leds:
  [{:red,    :gpio, %{pin: 18}},
   {:yellow, :gpio, %{pin: 17}},
   {:green,  :gpio, %{pin: 15}}]
