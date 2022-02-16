defmodule Auction.Repo.Migrations.CreateItems do
  use Ecto.Migration

  @doc """
  An Ecto.Migration is made up of a single change/0 function, or an up/0 function
  accompanied by a down/0 function. These tell Ecto how you’d like to change your
  database in this migration. If you provide both an up/0 and a down/0 function, Ecto
  will run the code in up/0 as it’s building your database, migration by migration, and it
  will run down/0 as it’s tearing your database down. If you only provide a change/0
  function, Ecto is smart enough to know how the database changes as it goes up and
  down. Typically, you’ll only need to give Ecto a change/0 migration, but there are
  times when you might need more control over how specific tables are torn down
  (such as removing specific data or notifying some external service). In your case, creating a table is simple enough that you’ll stick with the provided change/0 function.
  """
  def change do
    create table("items") do
      add :title, :string
      add :description, :string
      add :ends_at, :utc_datetime
      timestamps()
    end
  end
end
