defmodule Stockfighter do
  @moduledoc """
  Simple wrapper of stock fighter rest api

      client = %Stockfighter{:access_token: "your token here"}
      order = %{
        account: "your account here",
        venue: "TESTEX",
        stock: "FOOBAR",
        qty: 10,
        direction: :buy,
        orderType: :limit,
        price: 2000
      }
      client |> Stockfighter.send_order(order)
  """

  defstruct access_token: nil
  @type t :: %__MODULE__{access_token: binary}
  @type venue :: String.t
  @type stock :: String.t
  @type order :: %{
    account: String.t,
    venue: venue,
    stock: stock,
    price: integer,
    qty: integer,
    direction: :buy | :sell,
    orderType: :limit | :market | :"fill-or-kill" | :"immediate-or-cancel"
  }

  use HTTPoison.Base
  @endpoint "https://api.stockfighter.io/ob/api"

  def is_up do
    get("/heartbeat")
  end

  def is_up(venue) do
    get!("/venues/#{venue}/heartbeat") |> process_response
  end

  def get_stocks(venue) do
    get!("/venues/#{venue}/stocks") |> process_response
  end

  def get_orderbook(venue, stock) do
    get!("/venues/#{venue}/stocks/#{stock}") |> process_response
  end

  @doc """
  Post a order
  """
  @spec send_order(t, order) :: %{}
  def send_order(client, %{venue: venue, stock: stock} = order) do
    body = Poison.encode!(order)
    headers = %{"X-Starfighter-Authorization" => client.access_token}
    post!("/venues/#{venue}/stocks/#{stock}/orders", body, headers) |> process_response
  end

  defp process_response(%HTTPoison.Response{status_code: _, body: body}), do: Poison.decode!(body)

  # override process_url in HTTPoison.Base
  defp process_url(url) do
    Path.join(@endpoint, url)
  end

end
