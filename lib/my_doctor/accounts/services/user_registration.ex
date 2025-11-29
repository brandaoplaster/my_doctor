defmodule MyDoctor.Accounts.Services.UserRegistration do
  @moduledoc """
  User registration service.
  """

  alias MyDoctor.Accounts.Repositories.UserRepository
  alias MyDoctor.Accounts.Schemas.User

  @doc """
  Registers a user.
  """
  def register(attrs) do
    UserRepository.create(attrs)
  end

  @doc """
  Returns a changeset for tracking user registration changes.
  """
  def change_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false)
  end
end
