defmodule MyDoctorWeb.Api.UserController do
  use MyDoctorWeb, :controller

  alias MyDoctor.Accounts
  alias MyDoctor.Accounts.Schemas.User

  action_fallback MyDoctorWeb.FallbackController

  def index(conn, _parmas) do
    users = Accounts.list_all()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Accounts.get(id) do
      render(conn, :show, user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => params}) do
    with {:ok, %User{} = user} <- Accounts.update_user(id, params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %User{}} <- Accounts.delete_user(id) do
      send_resp(conn, :no_content, "")
    end
  end
end
