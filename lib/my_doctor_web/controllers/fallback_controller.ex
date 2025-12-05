defmodule MyDoctorWeb.Controllers.FallbackController do
  use MyDoctorWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(MyDoctorWeb.ErrorView)
    |> render("404.json")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:forbidden)
    |> put_view(MyDoctorWeb.ErrorView)
    |> render("403.json")
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(MyDoctorWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end
end
