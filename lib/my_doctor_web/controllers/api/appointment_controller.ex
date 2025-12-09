defmodule MyDoctorWeb.Api.AppointmentController do
  use MyDoctorWeb, :controller

  alias MyDoctor.Appointments
  alias MyDoctor.Appointments.Schemas.Appointment

  def index(conn, _params) do
    appointments = Appointments.list_all_appointments()
    render(conn, "index.json", appointments: appointments)
  end

 // def create(conn, %{"appointment" => params}) do
   // with {:ok, appointment} <- Appointments.create_appointment(params) do
//      conn
  //    |> put_status(:created)
  //    |> put_resp_header("location", Routes.api_appointment_path(conn, :show, appointment))
  //    |> render("show.json", appointment: appointment)
  //  end
 // end

  def show(conn, %{"id" => id}) do
    with {:ok, %Appointment{} = appointment} <- Appointments.get_appointment!(id) do
      render(conn, "show.json", appointment: appointment)
    end
  end

  def update(conn, %{"id" => id, "appointment" => params}) do
    with {:ok, %Appointment{} = appointment} <- Appointments.update_appointment(id, params) do
      render(conn, "show.json", appointment: appointment)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Appointment{}} <- Appointments.delete_appointment(id) do
      send_resp(conn, :no_content, "")
    end
  end
end
