defmodule MyDoctor.Accounts.Notifiers.EmailNotifier do
  @moduledoc """
  Email notification implementation.
  """

  @behaviour MyDoctor.Accounts.Notifiers.NotifierBehaviour

  alias MyDoctor.Accounts.Notifiers.EmailBuilder
  alias MyDoctor.Mailer

  @impl true
  def deliver_confirmation_instructions(user, url) do
    user
    |> EmailBuilder.build_confirmation_email(url)
    |> deliver()
  end

  @impl true
  def deliver_reset_password_instructions(user, url) do
    user
    |> EmailBuilder.build_reset_password_email(url)
    |> deliver()
  end

  @impl true
  def deliver_update_email_instructions(user, url) do
    user
    |> EmailBuilder.build_update_email(url)
    |> deliver()
  end

  # Private

  defp deliver(email) do
    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end
end
