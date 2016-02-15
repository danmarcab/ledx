use Mix.Config

config :ledx, leds:
  [{:doctest_led, TestDriver, %{}},
   {:config_test_led, TestDriver, %{}},
   {:config_test_led_2, TestDriver, %{}}]
