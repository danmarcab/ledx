defmodule LedxTest do
  use ExUnit.Case
  doctest Ledx

  setup do
    {:ok, _pid} = Ledx.start_led(:test_led, TestSenderDriver, %{caller: self})
    on_exit fn ->
      Ledx.stop_led(:test_led)
    end

    :ok
  end

  test "turn on/off" do
    assert Ledx.state(:test_led) == :off
    Ledx.turn_on(:test_led)
    assert_receive :on
    assert Ledx.state(:test_led) == :on
    Ledx.turn_off(:test_led)
    assert_receive :off
    assert Ledx.state(:test_led) == :off
  end

  test "toggle on/off" do
    assert Ledx.state(:test_led) == :off
    Ledx.toggle(:test_led)
    assert_receive :on
    assert Ledx.state(:test_led) == :on
    Ledx.toggle(:test_led)
    assert_receive :off
    assert Ledx.state(:test_led) == :off
  end

  test "pulse on" do
    assert Ledx.state(:test_led) == :off
    Ledx.turn_on(:test_led, 100)
    assert_receive :on
    assert Ledx.state(:test_led) == :on
    refute_receive :off, 90
    assert_receive :off
    assert Ledx.state(:test_led) == :off
  end

  test "pulse off" do
    Ledx.turn_on(:test_led)
    assert_receive :on

    assert Ledx.state(:test_led) == :on
    Ledx.turn_off(:test_led, 100)
    assert_receive :off
    assert Ledx.state(:test_led) == :off
    refute_receive :on, 90
    assert_receive :on
    assert Ledx.state(:test_led) == :on
  end

  test "pulse toggle when off" do
    assert Ledx.state(:test_led) == :off
    Ledx.toggle(:test_led, 100)
    assert_receive :on
    assert Ledx.state(:test_led) == :on
    refute_receive :off, 90
    assert_receive :off
    assert Ledx.state(:test_led) == :off
  end

  test "pulse toggle when on" do
    Ledx.turn_on(:test_led)
    assert_receive :on

    assert Ledx.state(:test_led) == :on
    Ledx.toggle(:test_led, 100)
    assert_receive :off
    assert Ledx.state(:test_led) == :off
    refute_receive :on, 90
    assert_receive :on
    assert Ledx.state(:test_led) == :on
  end

  test "blink loop" do
    assert Ledx.state(:test_led) == :off
    Ledx.blink(:test_led, 50, 100)
    assert_receive :on
    assert Ledx.state(:test_led) == :on
    refute_receive :off, 49
    assert_receive :off, 5
    assert Ledx.state(:test_led) == :off
    refute_receive :on, 99
    assert_receive :on, 5
    assert Ledx.state(:test_led) == :on
    refute_receive :off, 49
    assert_receive :off, 5
    assert Ledx.state(:test_led) == :off
  end

  test "starts leds from config" do
    assert Ledx.state(:config_test_led) == :off
    assert Ledx.turn_on(:config_test_led)
    assert Ledx.state(:config_test_led) == :on

    assert Ledx.state(:config_test_led_2) == :off
    assert Ledx.turn_on(:config_test_led_2)
    assert Ledx.state(:config_test_led_2) == :on
  end
end
