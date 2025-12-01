defmodule MyDoctor.Accounts.Repositories.UserRepository do
  @moduledoc """
  Repository for user database operations.
  """

  alias MyDoctor.Accounts.Schemas.User
  alias MyDoctor.Repo

  @doc """
  Gets a user by email.
  """
  def get_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a user by ID.
  Raises if user not found.
  """
  def get!(id) do
    Repo.get!(User, id)
  end

  @doc """
  Creates a user.
  """
  def create(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end
end
