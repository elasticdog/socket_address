defmodule SocketAddress.Mixfile do
  use Mix.Project

  def project() do
    [
      app: :socket_address,
      version: "0.2.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),

      # Docs
      name: "Socket Address",
      source_url: "https://github.com/elasticdog/socket_address",
      homepage_url: "https://github.com/elasticdog/socket_address",
      docs: [
        main: "readme",
        extras: [
          "README.md": [title: "README"],
          "CONTRIBUTING.md": [title: "Contributing"],
        ],
      ],

      # Hex.pm
      description: description(),
      package: package(),

      # Tests
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
    ]
  end

  def application() do
    [applications: [:logger]]
  end

  defp deps() do
    [
      {:credo, "~> 0.5", only: :dev},
      {:dialyxir, "~> 0.4", only: :dev},
      {:ex_doc, "~> 0.14", only: :dev},

      {:excoveralls, "~> 0.5", only: :test},
    ]
  end

  defp description() do
    """
    An Elixir convenience library for manipulating Internet socket addresses.
    """
  end

  defp package() do
    [
      licenses: ["ISC"],
      maintainers: ["Aaron Bull Schaefer"],
      links: %{"GitHub" => "https://github.com/elasticdog/socket_address"}
    ]
  end
end
