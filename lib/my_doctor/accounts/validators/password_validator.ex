defmodule MyDoctor.Accounts.Validators.PasswordValidator do
  @moduledoc """
  Password validation and operations.
  """

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      Ecto.Changeset.add_error(changeset, :current_password, "is not valid")
    end
  end

  @doc """
  Hashes the password using Bcrypt.
  """
  def hash_password(password) do
    Bcrypt.hash_pwd_salt(password)
  end
end
