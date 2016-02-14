defmodule Ledx.Mixfile do
  use Mix.Project

  def project do
    [app: :ledx,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:elixir_ale],
     mod: {Ledx, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:elixir_ale, "~> 0.4.0"}]
  end

  defp description do
    """
    Ledx is a simple library for interfacing with LEDs on embedded platforms.
    """
  end

  defp package do
    [maintainers: ["Daniel Marin Cabillas"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/danmarcab/ledx"}]
  end
end
