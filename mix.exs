defmodule ExPipedrivePhoenix.MixProject do
  use Mix.Project

  @version "0.1.1"
  @source_url "https://github.com/blksheep80/ex_pipedrive_phoenix"

  def project do
    [
      app: :ex_pipedrive_phoenix,
      version: @version,
      elixir: "~> 1.17",
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs(),
      source_url: @source_url,
      homepage_url: @source_url,
      elixirc_options: [warnings_as_errors: true],
      start_permanent: Mix.env() == :prod
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      ex_pipedrive_dep(),
      {:phoenix, "~> 1.7"}
    ] ++ path_dev_pins()
  end

  defp using_local_core? do
    System.get_env("HEX_PUBLISH") not in ~w(1 true) and local_core?()
  end

  defp local_core? do
    mix = Path.expand("../ex_pipedrive/mix.exs", __DIR__)
    File.exists?(mix) and File.read!(mix) =~ ~r/app:\s*:ex_pipedrive/
  end

  defp path_dev_pins do
    if using_local_core?(), do: [{:tesla, "~> 1.12.0"}], else: []
  end

  defp ex_pipedrive_dep do
    if using_local_core?() do
      {:ex_pipedrive, path: Path.expand("../ex_pipedrive", __DIR__), override: true}
    else
      {:ex_pipedrive, "~> 0.2"}
    end
  end

  defp description do
    """
    Optional Phoenix helpers for Pipedrive marketplace OAuth install. Core
    OAuth/TokenStore stay in ex_pipedrive; this package only adds redirect and
    callback plugs. Independent of Überauth.
    """
  end

  defp package do
    [
      name: "ex_pipedrive_phoenix",
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Changelog" => "#{@source_url}/blob/main/CHANGELOG.md",
        "HexDocs" => "https://hexdocs.pm/ex_pipedrive_phoenix",
        "Core" => "https://hex.pm/packages/ex_pipedrive"
      },
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE.md CHANGELOG.md)
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["README.md", "CHANGELOG.md", "LICENSE.md"]
    ]
  end
end
