defmodule Stockfighter.ClientTest do
  use ExUnit.Case, async: true

  test "the world is up" do
     assert  %{"ok" => true} = Stockfighter.Client.is_up
  end

  test "venue(test) is up" do
    assert %{"ok" => true, "venue" => "TESTEX"} = Stockfighter.Client.is_up("TESTEX")
  end

  test "unknown venue is not nound" do
    assert %{"ok" => false, "error" => _} = Stockfighter.Client.is_up("KNOWN")
  end

  test "get stocks on a venue" do
    assert %{"ok" => true, "symbols" => _} = Stockfighter.Client.get_stocks("TESTEX")
    assert %{"ok" => false} = Stockfighter.Client.get_stocks("KNOWN")
  end

  test "get orderbook for a stock" do
    assert %{
      "ok" => true,
      "venue" => "TESTEX",
      "symbol" => "FOOBAR",
      "bids" => _
    } = Stockfighter.Client.get_orderbook("TESTEX", "FOOBAR")

    assert %{
      "ok" => false
    } = Stockfighter.Client.get_orderbook("UNKNOWN", "FOOBAR")
  end

  test "create a new order for a stock" do
    client = %Stockfighter.Client{}
    order = %{
      account: "EXB123456",
      venue: "TESTEX",
      "stock": "FOOBAR",
      "qty": 100,
      "direction": :buy,
      "orderType": :limit
    }
    assert %{ "ok" => false } = Stockfighter.Client.send_order(client, order)

    client = %Stockfighter.Client{access_token: "0cffe05180b06dc05d16d47889bfc73661b3e0b4"}
    assert %{ "ok" => true } = Stockfighter.Client.send_order(client, order)
  end

  test "get quote for a stock" do
    assert %{
      "ok" => true,
      "venue" => "TESTEX",
      "symbol" => "FOOBAR"
    } = Stockfighter.Client.get_quote("TESTEX", "FOOBAR")

    assert %{"ok" => false} = Stockfighter.Client.get_quote("UNKNOWN", "FOOBAR")
  end

  test "status for an existing order" do
    order = %{
      account: "EXB123456",
      venue: "TESTEX",
      "stock": "FOOBAR",
      "qty": 100,
      "direction": :buy,
      "orderType": :limit
    }

    client = %Stockfighter.Client{access_token: "0cffe05180b06dc05d16d47889bfc73661b3e0b4"}

    assert %{ "ok" => true, "id" => order_id } = Stockfighter.Client.send_order(client, order)
    assert %{"ok" => true} = Stockfighter.Client.get_order_status(client, "TESTEX", "FOOBAR", order_id)

    client = %Stockfighter.Client{}
    assert %{"ok" => false} = Stockfighter.Client.get_order_status(client, "TESTEX", "FOOBAR", order_id)
  end

  test "cancel a order" do
    order = %{
      account: "EXB123456",
      venue: "TESTEX",
      "stock": "FOOBAR",
      "qty": 100,
      "direction": :buy,
      "orderType": :limit
    }

    client = %Stockfighter.Client{access_token: "0cffe05180b06dc05d16d47889bfc73661b3e0b4"}

    assert %{ "ok" => true, "id" => order_id } = Stockfighter.Client.send_order(client, order)
    assert %{"ok" => true} = Stockfighter.Client.cancel_order(client, "TESTEX", "FOOBAR", order_id)

    client = %Stockfighter.Client{}
    assert %{"ok" => false} = Stockfighter.Client.cancel_order(client, "TESTEX", "FOOBAR", order_id)
  end

  test "get status for all orders" do
    client = %Stockfighter.Client{access_token: "0cffe05180b06dc05d16d47889bfc73661b3e0b4"}
    assert %{"ok" => true} = Stockfighter.Client.get_all_order_status(client, "TESTEX", "EXB123456")
  end

  test "get status for all orders in a stock" do
    client = %Stockfighter.Client{access_token: "0cffe05180b06dc05d16d47889bfc73661b3e0b4"}
    assert %{"ok" => true} = Stockfighter.Client.get_all_order_status(client, "TESTEX", "EXB123456", "FOOBAR")
  end

end
