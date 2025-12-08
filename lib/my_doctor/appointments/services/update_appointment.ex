defmodule MyDoctor.Appointments.Services.UpdateAppointment do
  @moduledoc """
  Appointment update service.
  """

  alias MyDoctor.Appointments.Repositories.AppointmentRepository
  alias MyDoctor.Appointments.Schemas.Appointment

  def execute(id, attrs) do
    appointment = AppointmentRepository.get!(id)

    attrs = Map.update!(attrs, "date", &format_hour/1)

    appointment
    |> Appointment.changeset(attrs)
    |> AppointmentRepository.update()
  end

  defp format_hour(date) do
    date = NaiveDateTime.from_iso8601!(date)

    %NaiveDateTime{date | minute: 0, second: 0, microsecond: {0, 0}}
  end
end
