defmodule MyDoctor.Accounts.Services.UserAuthentication do
  @moduledoc """
  User authentication service.
  """

  alias MyDoctor.Accounts.Repositories.{UserRepository, UserTokenRepository}
  alias MyDoctor.Accounts.Services.TokenGenerator
  alias MyDoctor.Accounts.Validators.PasswordValidator
  alias MyDoctor.Repo

  @doc """
  Gets a user by email and password.
  """
  def authenticate(email, password)
      when is_binary(email) and is_binary(password) do
    user = UserRepository.get_by_email(email)

    if PasswordValidator.valid_password?(user, password) do
      {:ok, user}
    else
      {:error, :invalid_credentials}
    end
  end

  @doc """
  Generates a session token.
  """
  def generate_session_token(user) do
    {token, user_token} = TokenGenerator.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user by session token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserTokenRepository.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the session token.
  """
  def delete_session_token(token) do
    UserTokenRepository.delete_by_token_and_context(token, "session")

    :ok
  end
end
