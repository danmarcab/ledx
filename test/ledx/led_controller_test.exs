defmodule Ledx.LedControllerTest do
  use ExUnit.Case
  doctest Ledx.LedController
  alias Ledx.LedController

  defmodule TestLed do
    def on(%{caller: caller}) do
      send(caller, :on)
    end

    def off(%{caller: caller}) do
      send(caller, :off)
    end
  end

  test "the truth" do
    {:ok, pid} = LedController.start_link(:test_led, TestLed, %{caller: self})

    LedController.on(:test_led)

    assert_receive :on

    LedController.off(:test_led)

    assert_receive :off
  end
end
