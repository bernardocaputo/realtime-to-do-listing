defmodule RealtimeToDoListing.Repo do
  use Ecto.Repo,
    otp_app: :realtime_to_do_listing,
    adapter: Ecto.Adapters.Postgres
end
