defmodule DivoKafka.MixProject do
  use Mix.Project

  def project do
    [
      app: :divo_kafka,
      version: "1.0.0",
      elixir: "~> 1.14.4",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      description: description(),
      source_url: "https://github.com/smartcitiesdata/divo_kafka"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: :dev, runtime: false},
      {:divo, "~> 1.3"},
      {:ex_doc, "~> 0.29", only: :dev}
    ]
  end

  defp description do
    "A pre-configured kafka docker-compose stack definition for
    integration testing with the divo library."
  end

  defp package do
    [
      maintainers: ["smartcitiesdata"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/smartcitiesdata/divo_kafka"}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: "https://github.com/smartcitiesdata/divo_kafka",
      extras: [
        "README.md"
      ]
    ]
  end
end
