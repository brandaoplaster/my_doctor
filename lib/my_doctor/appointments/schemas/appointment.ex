defmodule MyDoctor.Appointments.Schemas.Appointment do
  use Ecto.Schema
  import Ecto.Changeset

  alias MyDoctor.Accounts.Schemas.User
  alias MyDoctor.Appointments.Validators.DateValidator
  alias MyDoctor.Appointments.Validators.RelationshipValidator

  @required_fields ~w(date user_id provider_id status)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "appointments" do
    field :status, :string, default: "pending"
    field :date, :naive_datetime
    belongs_to :user, User, foreign_key: :user_id, type: :binary_id
    belongs_to :provider, User, foreign_key: :provider_id, type: :binary_id

    timestamps()
  end

  def changeset(appointment, attrs) do
    appointment
    |> cast(attrs, @required_fields)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:provider_id)
    |> validate_required(@required_fields)
    |> validate_inclusion(:status, ["pending", "confirmed", "cancelled", "completed"])
    |> DateValidator.validate_date_not_in_past()
    |> RelationshipValidator.validate_user_not_provider()
  end
end
