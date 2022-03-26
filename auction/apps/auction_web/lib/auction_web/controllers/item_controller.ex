defmodule AuctionWeb.ItemController do
  use AuctionWeb, :controller
  plug :require_logged_in_user

  def index(conn, _params) do
    items = Auction.list_items()
    render(conn, "index.html", items: items)
  end

  def show(conn, %{"id" => id}) do
    item = Auction.get_item_with_bids(id)
    conn = assign(conn, :current_item, item)
    bid = Auction.new_bid()
    render(conn, "show.html", item: item, bid: bid)
  end

  def new(conn, _params) do
    item = Auction.new_item()
    render(conn, "new.html", item: item)
  end

  def create(conn, %{"item" => params}) do
    params = Map.put(params, "user_id", conn.assigns.current_user.id)
    case Auction.insert_item(params) do
      {:ok, item} -> redirect(conn, to: Routes.item_path(conn, :show, item))
      {:error, item} -> render(conn, "new.html", item: item)
    end
  end

  def edit(conn, %{"id" => id}) do
    item = Auction.edit_item(id)
    render(conn, "edit.html", item: item)
  end

  @spec update(Plug.Conn.t(), map) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "item" => params}) do
    item = Auction.get_item(id)
    if item.user_id != conn.assigns.current_user.id do
      conn
      |> put_flash(:error, "Nice try, friend. You must be the owner of this item to edit it.")
      |> redirect(to: Routes.item_path(conn, :show, item))
    else
      case Auction.update_item(item, params) do
        {:ok, item} -> redirect(conn, to: Routes.item_path(conn, :show, item))
        {:error, item} -> render(conn, "edit.html", item: item)
      end
    end
  end

  defp require_logged_in_user(%{
    assigns: %{current_user: nil},
    private: %{phoenix_action: action},
  } = conn, _opts) when action not in [:index, :show] do
    conn
    |> put_flash(:error, "Nice try, friend. You must be logged in to manage item.")
    |> redirect(to: Routes.item_path(conn, :index))
    |> halt()
  end
  defp require_logged_in_user(conn, _opts), do: conn
end
