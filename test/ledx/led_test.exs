defmodule Ledx.LedTest do
  use ExUnit.Case
  doctest Ledx.Led
  alias Ledx.Led

  defmodule TestDriver do
    @behaviour Ledx.Driver

    def init(config) do
      config
    end

    def on(config) do
      send(config.caller, :on)
      config
    end

    def off(config) do
      send(config.caller, :off)
      config
    end
  end

  setup do
    {:ok, _pid} = Led.start_link(:test_led, TestDriver, %{caller: self})
    :ok
  end

  test "turn on/off" do
    assert Led.state(:test_led) == :off
    Led.turn_on(:test_led)
    assert_receive :on
    assert Led.state(:test_led) == :on
    Led.turn_off(:test_led)
    assert_receive :off
    assert Led.state(:test_led) == :off
  end

  test "toggle on/off" do
    assert Led.state(:test_led) == :off
    Led.toggle(:test_led)
    assert_receive :on
    assert Led.state(:test_led) == :on
    Led.toggle(:test_led)
    assert_receive :off
    assert Led.state(:test_led) == :off
  end

  test "loop on/off" do
    assert Led.state(:test_led) == :off
    Led.loop(:test_led, 50, 100)
    assert_receive :on
    assert Led.state(:test_led) == :on
    refute_receive :off, 49
    assert_receive :off, 5
    assert Led.state(:test_led) == :off
    refute_receive :on, 99
    assert_receive :on, 5
    assert Led.state(:test_led) == :on
    refute_receive :off, 49
    assert_receive :off, 5
    assert Led.state(:test_led) == :off
  end

  test "keep alive" do
    assert Led.state(:test_led) == :off
    Led.alive(:test_led, 50)
    assert_receive :on
    assert Led.state(:test_led) == :on
    refute_receive :off, 40
    Led.alive(:test_led, 50)
    refute_receive :on, 10
    assert Led.state(:test_led) == :on
    refute_receive :off, 30
    assert_receive :off, 20
    assert Led.state(:test_led) == :off
  end
end
