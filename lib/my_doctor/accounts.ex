defmodule MyDoctor.Accounts do
  @moduledoc """
  The Accounts context - Boundary/Facade.
  """

  # alias MyDoctor.Accounts.Repositories.UserRepository

  alias MyDoctor.Accounts.Services.{
    CreateUser,
    DeleteUser,
    EmailUpdate,
    PasswordReset,
    PasswordUpdate,
    QueryUser,
    UserAuthentication,
    UserConfirmation,
    UserRegistration
  }

  # defdelegate get_user!(id), to: UserRepository, as: :get!
  defdelegate get_user_by_email(email), to: QueryUser, as: :get_by_email

  defdelegate register_user(attrs), to: UserRegistration, as: :register

  defdelegate change_user_registration(user, attrs \\ %{}),
    to: UserRegistration,
    as: :change_registration

  def get_user_by_email_and_password(email, password) do
    case UserAuthentication.authenticate(email, password) do
      {:ok, user} -> user
      {:error, _} -> nil
    end
  end

  defdelegate generate_user_session_token(user),
    to: UserAuthentication,
    as: :generate_session_token

  defdelegate get_user_by_session_token(token), to: UserAuthentication
  defdelegate delete_session_token(token), to: UserAuthentication

  defdelegate deliver_user_confirmation_instructions(user, url_fun),
    to: UserConfirmation,
    as: :deliver_confirmation_instructions

  defdelegate confirm_user(token), to: UserConfirmation, as: :confirm

  defdelegate deliver_user_reset_password_instructions(user, url_fun),
    to: PasswordReset,
    as: :deliver_reset_instructions

  defdelegate get_user_by_reset_password_token(token), to: PasswordReset, as: :get_user_by_token
  defdelegate reset_user_password(user, attrs), to: PasswordReset, as: :reset_password

  defdelegate change_user_password(user, attrs \\ %{}), to: PasswordUpdate, as: :change_password

  defdelegate update_user_password(user, password, attrs),
    to: PasswordUpdate,
    as: :update_password

  defdelegate change_user_email(user, attrs \\ %{}), to: EmailUpdate, as: :change_email
  defdelegate apply_user_email(user, password, attrs), to: EmailUpdate, as: :apply_email
  defdelegate update_user_email(user, token), to: EmailUpdate, as: :update_email

  defdelegate deliver_update_email_instructions(user, current_email, url_fun),
    to: EmailUpdate,
    as: :deliver_update_instructions

  defdelegate delete_user(id), to: DeleteUser, as: :execute
  defdelegate create_user(user), to: CreateUser, as: :execute
  defdelegate list_all(), to: QueryUser, as: :list_all
  defdelegate get(id), to: QueryUser, as: :get
  defdelegate get!(id), to: QueryUser, as: :get!
end
