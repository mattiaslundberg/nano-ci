defmodule NanoCi.Repo do
  use Ecto.Repo,
    otp_app: :nano_ci,
    adapter: Ecto.Adapters.Postgres
end
