defmodule MyDoctor.Accounts.Services.EmailUpdate do
  @moduledoc """
  User email update service.
  """

  alias MyDoctor.Accounts.Notifiers.EmailNotifier
  alias MyDoctor.Accounts.Repositories.UserTokenRepository
  alias MyDoctor.Accounts.Schemas.{User, UserToken}
  alias MyDoctor.Accounts.Services.TokenGenerator
  alias MyDoctor.Repo

  @doc """
  Returns a changeset for changing user email.
  """
  def change_email(user, attrs \\ %{}) do
    User.email_changeset(user, attrs)
  end

  @doc """
  Emulates email change without persisting.
  """
  def apply_email(user, password, attrs) do
    user
    |> User.email_changeset(attrs)
    |> User.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates user email using the given token.
  """
  def update_email(user, token) do
    context = "change:#{user.email}"

    with {:ok, query} <- UserTokenRepository.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  @doc """
  Delivers update email instructions.
  """
  def deliver_update_instructions(
        %User{} = user,
        current_email,
        update_email_url_fun,
        notifier \\ EmailNotifier
      )
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} =
      TokenGenerator.build_email_token(user, "change:#{current_email}")

    Repo.insert!(user_token)
    notifier.deliver_update_email_instructions(user, update_email_url_fun.(encoded_token))
  end

  defp email_multi(user, email, context) do
    changeset =
      user
      |> User.email_changeset(%{email: email})
      |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(
      :tokens,
      UserTokenRepository.user_and_contexts_query(user, [context])
    )
  end
end
