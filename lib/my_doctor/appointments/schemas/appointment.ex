defmodule MyDoctor.Appointments.Schemas.Appointment do
  use Ecto.Schema
  import Ecto.Changeset

  alias MyDoctor.Accounts.Schemas.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "appointment" do
    field :status, :string, default: "pending"
    field :date, :naive_datetime
    belongs_to :user, User, foreign_key: :user_id, type: :binary_id
    belongs_to :provider, User, foreign_key: :provider_id, type: :binary_id

    timestamps()
  end

  def changeset(appointment, attrs) do
    appointment
    |> cast(attrs, :user_id, :provider_id)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:provider_id)
    |> validate_required([:date, :user_id, :provider_id, :status])
    |> validate_inclusion(:status, ["pending", "confirmed", "cancelled", "completed"])
  end
end
