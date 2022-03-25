defmodule AuctionWeb.ItemController do
  use AuctionWeb, :controller
  plug :require_logged_in_user

  def index(conn, _params) do
    items = Auction.list_items()
    render(conn, "index.html", items: items)
  end

  def show(conn, %{"id" => id}) do
    item = Auction.get_item_with_bids(id)
    bid = Auction.new_bid()
    render(conn, "show.html", item: item, bid: bid)
  end

  def new(conn, _params) do
    item = Auction.new_item()
    render(conn, "new.html", item: item)
  end

  def create(conn, %{"item" => params}) do
    case Auction.insert_item(params) do
      {:ok, item} -> redirect(conn, to: Routes.item_path(conn, :show, item))
      {:error, item} -> render(conn, "new.html", item: item)
    end
  end

  def edit(conn, %{"id" => id}) do
    item = Auction.edit_item(id)
    render(conn, "edit.html", item: item)
  end

  def update(conn, %{"id" => id, "item" => params}) do
    item = Auction.get_item(id)
    case Auction.update_item(item, params) do
      {:ok, item} -> redirect(conn, to: Routes.item_path(conn, :show, item))
      {:error, item} -> render(conn, "edit.html", item: item)
    end
  end

  defp require_logged_in_user(%{
    assigns: %{current_user: nil},
    private: %{phoenix_action: action},
  } = conn, _opts) when action not in [:index, :show] do
    conn
    |> IO.inspect
    |> put_flash(:error, "Nice try, friend. You must be logged in to manage item.")
    |> redirect(to: Routes.item_path(conn, :index))
    |> halt()
  end

  defp require_logged_in_user(conn, _opts), do: conn
end
