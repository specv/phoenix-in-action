defmodule Auction do 
  alias Auction.Item

  @repo Auction.Repo

  def list_items do
    @repo.all(Item)
  end

  def get_item(id) do
    @repo.get!(Item, id)
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
end
