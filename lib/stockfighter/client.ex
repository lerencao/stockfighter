defmodule Stockfighter.Client do
  @moduledoc """
  Simple wrapper of stock fighter rest api

      client = %Stockfighter.Client{access_token: "your token here"}
      order = %{
        account: "your account here",
        venue: "TESTEX",
        stock: "FOOBAR",
        qty: 10,
        direction: :buy,
        orderType: :limit,
        price: 2000
      }
      client |> Stockfighter.Client.send_order(order)
  the http req-res is handled by Stockfighter
  """

  defstruct access_token: nil

  @type t :: %__MODULE__{access_token: binary}
  @type account :: String.t
  @type venue :: String.t
  @type stock :: String.t
  @type order_id :: String.t
  @type order :: %{
    account: account,
    venue: venue,
    stock: stock,
    price: integer,
    qty: integer,
    direction: :buy | :sell,
    orderType: :limit | :market | :"fill-or-kill" | :"immediate-or-cancel"
  }


  import Stockfighter, except: [start: 0]
  def is_up do
    get!("/heartbeat") |> process_response
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
  def send_order(%__MODULE__{access_token: token}, %{venue: venue, stock: stock} = order) do
    body = Poison.encode!(order)
    headers = %{"X-Starfighter-Authorization" => token}
    post!("/venues/#{venue}/stocks/#{stock}/orders", body, headers) |> process_response
  end

  @spec get_quote(venue, stock) :: %{}
  def get_quote(venue, stock) do
    get!("/venues/#{venue}/stocks/#{stock}/quote") |> process_response
  end

  @spec cancel_order(t, venue, stock, String.t) :: %{}
  def cancel_order(%__MODULE__{access_token: token}, venue, stock, order_id) do
    delete!(
      "/venues/#{venue}/stocks/#{stock}/orders/#{order_id}",
      %{} |> add_auth_header(token)
    ) |> process_response
  end

  @spec get_order_status(t, venue, stock, String.t) :: %{}
  def get_order_status(%__MODULE__{access_token: token}, venue, stock, order_id) do
    get!(
      "/venues/#{venue}/stocks/#{stock}/orders/#{order_id}",
      %{} |> add_auth_header(token)
    ) |> process_response
  end

  @spec get_all_order_status(t, venue, account) :: %{}
  def get_all_order_status(%__MODULE__{access_token: token}, venue, account) do
    get!(
      "/venues/#{venue}/accounts/#{account}/orders",
      %{} |> add_auth_header(token)
    ) |> process_response
  end

  @spec get_all_order_status(t, venue, account, stock) :: %{}
  def get_all_order_status(%__MODULE__{access_token: token}, venue, account, stock) do
    get!(
      "/venues/#{venue}/accounts/#{account}/stocks/#{stock}/orders",
      %{} |> add_auth_header(token)
    ) |> process_response
  end


  defp add_auth_header(headers, token) when is_map(headers) do
    headers |> Map.put("X-Starfighter-Authorization", token)
  end

  defp process_response(%HTTPoison.Response{status_code: _, body: body}), do: Poison.decode!(body)
end
