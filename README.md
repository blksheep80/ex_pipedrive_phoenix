# ExPipedrivePhoenix

[![Hex.pm](https://img.shields.io/hexpm/v/ex_pipedrive_phoenix.svg)](https://hex.pm/packages/ex_pipedrive_phoenix)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/ex_pipedrive_phoenix/)
[![CI](https://github.com/blksheep80/ex_pipedrive_phoenix/actions/workflows/elixir.yml/badge.svg)](https://github.com/blksheep80/ex_pipedrive_phoenix/actions/workflows/elixir.yml)
[![Coverage Status](https://coveralls.io/repos/github/blksheep80/ex_pipedrive_phoenix/badge.svg?branch=main)](https://coveralls.io/github/blksheep80/ex_pipedrive_phoenix?branch=main)

Optional [Phoenix](https://hex.pm/packages/phoenix) helpers for Pipedrive
**marketplace OAuth install** (authorize redirect + callback). Token exchange
and `TokenStore` live in core [`ex_pipedrive`](https://hex.pm/packages/ex_pipedrive)
([GitHub](https://github.com/blksheep80/ex_pipedrive)).

This package is **independent of Überauth**. If you already use
[`ueberauth_pipedrive`](https://hex.pm/packages/ueberauth_pipedrive), keep it;
otherwise this is the first-party install path that stores
`ExPipedrive.Oauth.Token` via your `TokenStore`.

Core OAuth remains usable without Phoenix.

## Installation

```elixir
def deps do
  [
    {:ex_pipedrive, "~> 0.2.0"},
    {:ex_pipedrive_phoenix, "~> 0.1.1"}
  ]
end
```

## Minimal install flow

```elixir
defmodule MyAppWeb.PipedriveController do
  use MyAppWeb, :controller
  use ExPipedrivePhoenix.Install,
    token_store: MyApp.PipedriveTokenStore,
    tenant_assign: :current_account_id,
    success_to: "/settings/pipedrive",
    error_to: "/settings/pipedrive?error=1"
end
```

```elixir
# router.ex
scope "/pipedrive", MyAppWeb do
  pipe_through [:browser, :require_authenticated_user]
  get "/install", PipedriveController, :authorize
  get "/callback", PipedriveController, :callback
end
```

```elixir
# config/runtime.exs
config :my_app, ExPipedrivePhoenix,
  client_id: System.fetch_env!("PIPEDRIVE_CLIENT_ID"),
  client_secret: System.fetch_env!("PIPEDRIVE_CLIENT_SECRET"),
  redirect_uri: "https://app.example.com/pipedrive/callback"
```

`authorize/2` stores a CSRF `state` in the session and redirects to Pipedrive.
`callback/2` verifies `state`, exchanges the code, and `TokenStore.put/2`s the
token for `conn.assigns[tenant_assign]` (or a literal `:tenant_id` option).

Pass `:otp_app` (default `:ex_pipedrive_phoenix`) if config lives under another
app key.

## Version coupling

| This package | Core |
|---|---|
| `0.1.x` | `ex_pipedrive ~> 0.2` |

If you clone this repo next to [`ex_pipedrive`](https://github.com/blksheep80/ex_pipedrive),
Mix uses a path dependency on core. CI and Hex consumers use
`{:ex_pipedrive, "~> 0.2"}`.

```bash
HEX_PUBLISH=1 mix hex.publish
```

Hex: [`ex_pipedrive_phoenix`](https://hex.pm/packages/ex_pipedrive_phoenix).

## Development

```bash
mix deps.get
mix test
mix coveralls
mix format --check-formatted
mix credo --strict
```

Coverage HTML: `mix coveralls.html` (opens `cover/excoveralls.html`). CI uploads lcov from the primary Elixir 1.17 cell to [Coveralls](https://coveralls.io/github/blksheep80/ex_pipedrive_phoenix) and fails if total coverage drops below 75%.
