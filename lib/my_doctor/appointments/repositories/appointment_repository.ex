defmodule MyDoctor.Appointments.Repositories.AppointmentRepository do
  @moduledoc """
  The Appointment Repository - Handles data operations for Appointments.
  """
  alias MyDoctor.Appointments.Schemas.Appointment
  alias MyDoctor.Repo

  def list_all, do: Repo.all(Appointment)

  def get!(id), do: Repo.get!(Appointment, id)

  def create(attrs \\ %{}) do
    %Appointment{}
    |> Appointment.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Appointment{} = appointmemnt, attrs) do
    appointmemnt
    |> Appointment.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Appointment{} = appointmemnt), do: Repo.delete(appointmemnt)
end
