defmodule Auction.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :title, :string
    field :description, :string
    field :ends_at, :utc_datetime
    belongs_to :user, Auction.User
    has_many :bids, Auction.Bid
    timestamps(type: :utc_datetime)
  end

  def changeset(item, params \\ %{}) do
    item
    |> cast(params, [:user_id, :title, :description, :ends_at])
    |> validate_required([:user_id, :title])
    |> validate_length(:title, min: 3)
    |> validate_length(:description, max: 200)
    |> validate_change(:ends_at, &validate/2)
  end

  defp validate(:ends_at, ends_at_date) do
    case DateTime.compare(ends_at_date, DateTime.utc_now()) do
      :lt -> [ends_at: "can't be in the past"]
      _ -> []
    end
  end
end
