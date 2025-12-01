defmodule MyDoctor.Accounts.Services.PasswordUpdate do
  @moduledoc """
  Password update service.
  """

  alias MyDoctor.Accounts.Repositories.UserTokenRepository
  alias MyDoctor.Accounts.Schemas.User
  alias MyDoctor.Repo

  @doc """
  Returns a changeset for changing user password.
  """
  def change_password(user, attrs \\ %{}) do
    User.password_changeset(user, attrs, hash_password: false)
  end

  @doc """
  Updates user password.
  """
  def update_password(user, password, attrs) do
    changeset =
      user
      |> User.password_changeset(attrs)
      |> User.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserTokenRepository.user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end
end
