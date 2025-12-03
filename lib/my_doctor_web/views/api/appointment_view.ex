defmodule MyDoctorWeb.Api.AppointmentView do
  use MyDoctorWeb, :view

  def render("index.json", %{appointments: appointments}) do
    render_many(appointments, __MODULE__, "appointment.json")
  end

  def render("show.json", %{appointment: appointment}) do
    render_one(appointment, __MODULE__, "appointment.json")
  end

  def render("appointment.json", %{appointment: appointment}) do
    %{
      id: appointment.id,
      date: appointment.date,
      status: appointment.status,
      user_id: appointment.user_id,
      provider_id: appointment.provider_id
    }
  end
end
