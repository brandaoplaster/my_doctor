defmodule MyDoctor.Accounts.Notifiers.NotifierBehaviour do
  @moduledoc """
  Behaviour for user notifications.
  """

  @callback deliver_confirmation_instructions(user :: map(), url :: String.t()) ::
              {:ok, any()} | {:error, any()}

  @callback deliver_reset_password_instructions(user :: map(), url :: String.t()) ::
              {:ok, any()} | {:error, any()}

  @callback deliver_update_email_instructions(user :: map(), url :: String.t()) ::
              {:ok, any()} | {:error, any()}
end
