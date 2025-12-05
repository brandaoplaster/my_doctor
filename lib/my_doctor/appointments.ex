defmodule MyDoctor.Appointments do
  @moduledoc """
  The Apointments context - Boundary/Facade.
  """

  alias MyDoctor.Appointments.Services.CreateAppointment
  alias MyDoctor.Appointments.Services.UpdateAppointment
  alias MyDoctor.Appointments.Services.DeleteAppointment
  alias MyDoctor.Appointments.Services.QueryAppointment

  defdelegate get_appointment!(id), to: QueryAppointment, as: :get!
  defdelegate list_all_appointments(), to: QueryAppointment, as: :list_all
  defdelegate create_appointment(attrs), to: CreateAppointment, as: :execute
  defdelegate update_appointment(id, attrs), to: UpdateAppointment, as: :execute
  defdelegate delete_appointment(id), to: DeleteAppointment, as: :execute
end
