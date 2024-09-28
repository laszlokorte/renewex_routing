defmodule RenewexRouting.MixProject do
  use Mix.Project

  @source_url "https://github.com/laszlokorte/renewex_routing"
  @version "0.1.0"

  def project do
    [
      app: :renewex_routing,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      source_url: @source_url,
      homepage_url: @source_url,
      docs: [
        # The main page in the docs
        extras: ["README.md"],
        source_url: @source_url,
        logo: "guides/images/logo-square.png"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [{:ex_doc, "~> 0.34.0", only: :dev, runtime: false}]
  end

  defp description() do
    "Library for calculating dynamic edge positions in Renew drawings."
  end

  defp package() do
    [
      name: "renewex_routing",
      files: ~w(lib .formatter.exs mix.exs README*),
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/laszlokorte/renewex_routing",
        "Renew" => "http://www.renew.de"
      }
    ]
  end
end
