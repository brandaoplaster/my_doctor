defmodule MyDoctor.Appointments.Repositories.AppointmentRepository do
  @moduledoc """
  The Appointment Repository - Handles data operations for Appointments.
  """
  alias MyDoctor.Appointments.Schemas.Appointment
  alias MyDoctor.Repo

  def list_all, do: Repo.all(Appointment)

  def get!(id), do: Repo.get!(Appointment, id)

  def insert(changeset), do: Repo.insert(changeset)

  def update(changeset), do: Repo.update(changeset)

  def delete(struct), do: Repo.delete(struct)
end
