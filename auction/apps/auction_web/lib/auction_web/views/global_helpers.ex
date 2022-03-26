defmodule AuctionWeb.GlobalHelpers do
  def integer_to_currency(cents) do
    dollars_and_cents =
      cents
      |> Decimal.div(100)
      |> Decimal.round(2)

    "$#{dollars_and_cents}"
 end

  def format_datetime(datetime) do
    datetime
    |> Timex.to_datetime("Asia/Shanghai")
    |> Timex.format!("%Y-%m-%d %H:%M:%S", :strftime)
  end
end
