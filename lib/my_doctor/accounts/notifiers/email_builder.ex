defmodule MyDoctor.Accounts.Notifiers.EmailBuilder do
  @moduledoc """
  Builds email templates for user notifications.
  """

  import Swoosh.Email

  @from_email {"MyDoctor", "contact@example.com"}

  @doc """
  Builds a confirmation email.
  """
  def build_confirmation_email(user, url) do
    new()
    |> to(user.email)
    |> from(@from_email)
    |> subject("Confirmation instructions")
    |> text_body(confirmation_body(user.email, url))
  end

  @doc """
  Builds a reset password email.
  """
  def build_reset_password_email(user, url) do
    new()
    |> to(user.email)
    |> from(@from_email)
    |> subject("Reset password instructions")
    |> text_body(reset_password_body(user.email, url))
  end

  @doc """
  Builds an update email instructions email.
  """
  def build_update_email(user, url) do
    new()
    |> to(user.email)
    |> from(@from_email)
    |> subject("Update email instructions")
    |> text_body(update_email_body(user.email, url))
  end

  # Private functions for email bodies

  defp confirmation_body(email, url) do
    """
    ==============================

    Hi #{email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """
  end

  defp reset_password_body(email, url) do
    """
    ==============================

    Hi #{email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """
  end

  defp update_email_body(email, url) do
    """
    ==============================

    Hi #{email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """
  end
end
