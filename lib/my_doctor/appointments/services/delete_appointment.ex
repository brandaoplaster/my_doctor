defmodule MyDoctor.Appointments.Services.DeleteAppointment do
  @moduledoc """
  Appointment registration service.
  """

  alias MyDoctor.Appointments.Repositories.AppointmentRepository

  def execute(id) do
    case AppointmentRepository.get(id) do
      nil ->
        {:error, :not_found}

      appointment ->
        AppointmentRepository.delete(appointment)
    end
  end
end
