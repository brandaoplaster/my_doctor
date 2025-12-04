defmodule MyDoctor.Appointments do
  @moduledoc """
  The Apointments context - Boundary/Facade.
  """

  alias MyDoctor.Appointments.Repositories.AppointmentRepository

  defdelegate get_appointment!(id), to: AppointmentRepository, as: :get!
  defdelegate list_all_appointments(), to: AppointmentRepository, as: :list_all
  defdelegate create_appointment(attrs), to: AppointmentRepository, as: :create
  defdelegate update_appointment(appointment, attrs), to: AppointmentRepository, as: :update
  defdelegate delete_appointment(id), to: AppointmentRepository, as: :delete
end
