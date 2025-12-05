defmodule MyDoctor.Appointments.Validators.DateValidator do
  @moduledoc """
  Date validation functions for appointments.
  """

  import Ecto.Changeset

  @doc """
  Validates that the appointment date is not in the past.
  """
  def validate_date_not_in_past(changeset) do
    validate_change(changeset, :date, fn :date, date ->
      now =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.truncate(:second)

      case NaiveDateTime.compare(date, now) do
        :lt -> [date: "cannot be in the past"]
        _ -> []
      end
    end)
  end
end
