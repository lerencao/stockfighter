# Stockfighter

It is a simple wrapper of [stock fighter](http://starfighter.readme.io) http api.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add stockfighter to your list of dependencies in `mix.exs`:

        def deps do
          [{:stockfighter, "~> 0.0.1"}]
        end

  2. Ensure stockfighter is started before your application:

        def application do
          [applications: [:stockfighter]]
        end

If not, just use `{:stockfighter, git: "https://github.com/lerencao/stockfighter.git"}`.


## Usage

``` elixir
client = Stockfighter.Client(access_token: "your token here")

Stockfighter.Client.is_up("TESTEX")

client |> Stockfighter.Client.get_order_status("TESTEX", "FOOBAR", 2045)
```
