defmodule MyDoctor.Accounts.Services.UserConfirmation do
  @moduledoc """
  User email confirmation service.
  """

  alias MyDoctor.Accounts.Notifiers.EmailNotifier
  alias MyDoctor.Accounts.Repositories.UserTokenRepository
  alias MyDoctor.Accounts.Schemas.User
  alias MyDoctor.Accounts.Services.TokenGenerator
  alias MyDoctor.Repo

  @doc """
  Delivers confirmation instructions to the given user.
  """
  def deliver_confirmation_instructions(
        %User{} = user,
        confirmation_url_fun,
        notifier \\ EmailNotifier
      )
      when is_function(confirmation_url_fun, 1) do
    if user.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = TokenGenerator.build_email_token(user, "confirm")
      Repo.insert!(user_token)
      notifier.deliver_confirmation_instructions(user, confirmation_url_fun.(encoded_token))
    end
  end

  @doc """
  Confirms a user by the given token.
  """
  def confirm(token) do
    with {:ok, query} <- UserTokenRepository.verify_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(
      :tokens,
      UserTokenRepository.user_and_contexts_query(user, ["confirm"])
    )
  end
end
