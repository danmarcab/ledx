defmodule Ledx.Driver do
  @callback init(Map.t) :: Map.t
  @callback on(Map.t) :: Map.t
  @callback off(Map.t) :: Map.t
end
