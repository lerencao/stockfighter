defmodule Stockfighter.Mixfile do
  use Mix.Project

  @description """
  a simple wrapper of stockfighter http api
  """

  def project do
    [app: :stockfighter,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     description: @description,
     package: package,
     name: "Stockfighter",
     source_url: "https://github.com/lerencao/stockfighter"]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:httpoison]]
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
    [
      {:httpoison, "~> 0.8.0"},
      {:poison, "~> 1.5"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end

  def package do
    [
      maintainers: ["Jiafeng Cao"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/lerencao/stockfighter"}
    ]
  end

end
