defmodule DivoKafka.MixProject do
  use Mix.Project

  def project do
    [
      app: :divo_kafka,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      source_url: "https://github.com/SmartColumbusOS/divo-kafka"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0", only: :dev, runtime: false},
      {:divo, "~> 1.1", organization: "smartcolumbus_os"},
      {:ex_doc, "~> 0.19", only: :dev}
    ]
  end

  defp description do
    "A pre-configured kafka docker-compose stack definition for
    integration testing with the divo library."
  end

  defp package do
    [
      organization: "smartcolumbus_os",
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/SmartColumbusOS/divo-kafka"}
    ]
  end
end
