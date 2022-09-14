defmodule MyDoctor.Repo do
  use Ecto.Repo,
    otp_app: :my_doctor,
    adapter: Ecto.Adapters.Postgres
end
