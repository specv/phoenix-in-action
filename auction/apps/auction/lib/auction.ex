defmodule Auction do 
  alias Auction.{Repo, Item, User, Password}

  @repo Repo

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
end
