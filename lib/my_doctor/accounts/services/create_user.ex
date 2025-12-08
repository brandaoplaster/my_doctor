defmodule MyDoctor.Accounts.Services.CreateUser do
  @moduledoc """
  User create service.
  """

  alias MyDoctor.Accounts.Repositories.UserRepository
  alias MyDoctor.Accounts.Schemas.User

  def execute(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> UserRepository.insert()
  end
end
