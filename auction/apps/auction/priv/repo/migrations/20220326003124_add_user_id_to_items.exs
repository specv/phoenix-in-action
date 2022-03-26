defmodule Auction.Repo.Migrations.AddUserIdToItems do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :user_id, references(:users)
    end

    # foreign key does not automatically create an index
    create index(:items, [:user_id])
  end
end
