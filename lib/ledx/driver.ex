defmodule Ledx.Driver do
  @moduledoc """
  This behaviour defines the interface that Ledx uses to work with LEDs. By
  implementing it you can make Ledx work with your own type of LED.
  """

  @doc """
  This is called to initialize the LED. It receives a map with the configuration
  for the LED and it should return it updated (or unchanged) after initialization.
  """
  @callback init(config :: Map.t) :: Map.t

  @doc """
  This is called to turn on the LED. It receives a map with the LED configuration
  and it should return it updated (or unchanged) after turning the LED on.
  """
  @callback on(config :: Map.t) :: Map.t

  @doc """
  This is called to turn off the LED. It receives a map with the LED configuration
  and it should return it updated (or unchanged) after turning the LED off.
  """
  @callback off(config :: Map.t) :: Map.t
end
