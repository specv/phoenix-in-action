defmodule Auction.Repo do
  # By including use Ecto.Repo, opt_app: :auction in your module, you benefit from a
  # number of functions that Ecto brings in and that you don’t have to define yourself.
  # This keeps boilerplate code to a minimum.
  use Ecto.Repo,
    otp_app: :auction,
    adapter: Ecto.Adapters.SQLite3
end
