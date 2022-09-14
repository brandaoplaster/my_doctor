defmodule MyDoctorWeb.PageController do
  use MyDoctorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
