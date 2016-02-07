defmodule Ledx.LedControllerTest do
  use ExUnit.Case
  doctest Ledx.LedController
  alias Ledx.LedController

  defmodule TestLed do
    def on(state) do
      send(state.config.caller, :on)
      state
    end

    def off(state) do
      send(state.config.caller, :off)
      state
    end

    def loop_type do
      :generic
    end
  end

  setup do
    {:ok, _pid} = LedController.start_link(:test_led, TestLed, %{caller: self})
    :ok
  end

  test "turn on/off" do
    assert LedController.state(:test_led) == :off
    LedController.turn_on(:test_led)
    assert_receive :on
    assert LedController.state(:test_led) == :on
    LedController.turn_off(:test_led)
    assert_receive :off
    assert LedController.state(:test_led) == :off
  end

  test "toggle on/off" do
    assert LedController.state(:test_led) == :off
    LedController.toggle(:test_led)
    assert_receive :on
    assert LedController.state(:test_led) == :on
    LedController.toggle(:test_led)
    assert_receive :off
    assert LedController.state(:test_led) == :off
  end

  test "loop on/off" do
    LedController.loop(:test_led, 50, 100)
    assert_receive :on
    # assert LedController.state(:test_led) == :on
    refute_receive :off, 49
    assert_receive :off, 5
    # assert LedController.state(:test_led) == :off
    refute_receive :on, 99
    assert_receive :on, 5
    # assert LedController.state(:test_led) == :on
    refute_receive :off, 49
    assert_receive :off, 5
    # assert LedController.state(:test_led) == :off
  end
end
