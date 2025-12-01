defmodule MyDoctor.Accounts.Services.PasswordReset do
  @moduledoc """
  Password reset service.
  """

  alias MyDoctor.Accounts.Notifiers.EmailNotifier
  alias MyDoctor.Accounts.Repositories.UserTokenRepository
  alias MyDoctor.Accounts.Schemas.User
  alias MyDoctor.Accounts.Services.TokenGenerator
  alias MyDoctor.Repo

  @doc """
  Delivers reset password instructions to the given user.
  """
  def deliver_reset_instructions(
        %User{} = user,
        reset_password_url_fun,
        notifier \\ EmailNotifier
      )
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, user_token} = TokenGenerator.build_email_token(user, "reset_password")
    Repo.insert!(user_token)
    notifier.deliver_reset_password_instructions(user, reset_password_url_fun.(encoded_token))
  end

  @doc """
  Gets user by reset password token.
  """
  def get_user_by_token(token) do
    with {:ok, query} <- UserTokenRepository.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  @doc """
  Resets the user password.
  """
  def reset_password(user, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
    |> Ecto.Multi.delete_all(
      :tokens,
      UserTokenRepository.user_and_contexts_query(user, :all)
    )
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end
end
