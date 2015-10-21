defmodule Presentex.Mixfile do
  use Mix.Project

  def project do
    [app: :presentex,
     description: "A _presenter_ package for Elixir. Convert structures to maps for easy encoding/decoding.",
     version: "0.1.0",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     package: [
       licenses: ["MIT"],
       maintainers: ["kolorahl@gmail.com"],
       links: ["https://github.com/kolorahl/presentex"],
     ]]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, "~> 0.10", only: :dev}]
  end
end
