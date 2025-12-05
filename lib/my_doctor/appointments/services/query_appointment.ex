defmodule MyDoctor.Appointments.Services.QueryAppointment do
  @moduledoc """
  Appointment query service.
  """

  alias MyDoctor.Appointments.Repositories.AppointmentRepository

  def list_all do
    AppointmentRepository.list_all()
  end

  def get!(id), do: AppointmentRepository.get!(id)
end
