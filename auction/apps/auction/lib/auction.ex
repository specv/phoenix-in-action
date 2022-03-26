defmodule Auction do
  import Ecto.Query
  alias Ecto.Changeset
  alias Auction.{Bid, Item, Password, Repo, User}

  @repo Repo

  def list_items do
    @repo.all from i in Item, order_by: [desc: i.inserted_at]
  end

  def get_item(id) do
    @repo.get!(Item, id)
  end

  def get_item_with_bids(id) do
    id
    |> get_item()
    |> @repo.preload(bids: {(from b in Bid, order_by: [desc: b.inserted_at]), [:user]})
  end

  def get_item_by(attrs) do
    @repo.get_by(Item, attrs)
  end

  def new_item do
    Item.changeset(%Item{})
  end

  def insert_item(attrs) do
    %Item{}
    |> Item.changeset(attrs)
    |> @repo.insert()
  end

  def delete_item(%Item{} = item) do
    @repo.delete(Item, item)
  end

  def edit_item(id) do
    get_item(id)
    |> Item.changeset()
  end

  def update_item(%Item{} = item, updates) do
    # If the data in updates is consistent with the database, ecto will not actually request the database (use ecto_sqlite3 driver)
    item
    |> Item.changeset(updates)
    |> @repo.update()
  end

  def get_user(id) do
    @repo.get!(User, id)
  end

  def get_user_by_username_and_password(username, password) do
    with user when not is_nil(user) <- @repo.get_by(User, %{username: username}),
      ture <- Password.verify(password, user.hashed_password) do
      user
    else
      _ -> Password.dummy_verify()
    end
  end

  def new_user do
    User.changeset_with_password(%User{})
  end

  def insert_user(attrs) do
    %User{}
    |> User.changeset_with_password(attrs)
    |> @repo.insert()
  end

  def new_bid() do
    Bid.changeset(%Bid{})
  end

  def insert_bid(params) do
    %Bid{}
    |> Bid.changeset(params)
    |> valid_created_at?()
    |> valid_amount?()
    |> @repo.insert()
  end

  defp valid_amount?(%Changeset{valid?: false} = changeset) do
    changeset
  end
  defp valid_amount?(changeset) do
    highest_bid =
      changeset
      |> Changeset.get_field(:item_id)
      |> get_item()
      |> get_highest_bid_for_item()
      |> then(fn (bid) -> if(bid, do: bid.amount, else: 0) end)

    cond do
      Changeset.get_field(changeset, :amount) <= highest_bid -> Changeset.add_error(changeset, :amount, "must be greater than highest bid #{highest_bid}")
      true -> changeset
    end
  end

  defp valid_created_at?(%Changeset{valid?: false} = changeset) do
    changeset
  end
  defp valid_created_at?(changeset) do
    item =
      changeset
      |> Changeset.get_field(:item_id)
      |> get_item()

    cond do
      DateTime.compare(DateTime.utc_now(), item.ends_at) == :gt -> Changeset.add_error(changeset, :amount, "submit disabled")
      true -> changeset
    end
  end

  def get_bids_for_user(user) do
    query =
      from b in Bid,
      where: b.user_id == ^user.id,
      order_by: [desc: :inserted_at],
      preload: :item,
      limit: 10

    @repo.all(query)
  end

  def get_highest_bid_for_item(item) do
    query =
      from b in Bid,
      where: b.item_id == ^item.id,
      order_by: [desc: :amount],
      limit: 1

    @repo.one(query)
  end
end
