defmodule Auction.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email_address, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
  end

end
