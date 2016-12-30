defmodule SocketAddress.Mixfile do
  use Mix.Project

  def project() do
    [
      app: :socket_address,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),

      # Docs
      name: "Socket Address",
      docs: [
        main: "readme",
        extras: ["README.md": [title: "README"]],
      ],

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
end
