use Mix.Config

config :ledx, leds:
  [{:config_test_led, TestDriver, %{}},
   {:config_test_led_2, TestDriver, %{}}]
