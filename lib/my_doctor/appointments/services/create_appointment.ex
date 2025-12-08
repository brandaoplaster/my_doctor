defmodule MyDoctor.Appointments.Services.CreateAppointment do
  @moduledoc """
  Appointment registration service.
  """

  alias MyDoctor.Appointments.Repositories.AppointmentRepository
  alias MyDoctor.Appointments.Schemas.Appointment

  def execute(attrs) do
    attrs = Map.update!(attrs, "date", &format_hour/1)

    %Appointment{}
    |> Appointment.changeset(attrs)
    |> AppointmentRepository.insert()
  end

  defp format_hour(date) do
    date = NaiveDateTime.from_iso8601!(date)

    %NaiveDateTime{date | minute: 0, second: 0, microsecond: {0, 0}}
  end
end
