defmodule MyDoctor.Accounts.Services.UserConfirmationTest do
  use MyDoctor.DataCase

  alias MyDoctor.Accounts.Services.TokenGenerator
  alias MyDoctor.Accounts.Services.UserAuthentication
  alias MyDoctor.Accounts.Services.UserConfirmation
  alias MyDoctor.Factory

  describe "deliver_confirmation_instructions/3" do
    test "delivers confirmation instructions to unconfirmed user" do
      user = Factory.insert(:user, email: "current@example.com")
      confirm_email_url_fun = fn token -> "http://example.com/confirm/#{token}" end

      result =
        UserConfirmation.deliver_confirmation_instructions(
          user,
          confirm_email_url_fun
        )

      assert {:ok, %Swoosh.Email{} = email} = result

      assert email.subject == "Confirmation instructions"
    end

    test "returns error when user is already confirmed" do
      user =
        Factory.insert(:user, email: "current@example.com", confirmed_at: ~N[2024-01-01 00:00:00])

      confirm_email_url_fun = fn token -> "http://example.com/confirm/#{token}" end

      result =
        UserConfirmation.deliver_confirmation_instructions(
          user,
          confirm_email_url_fun
        )

      assert {:error, :already_confirmed} = result
    end
  end

  describe "confirm/1" do
    test "confirms user with valid token" do
      user = Factory.insert(:user, confirmed_at: nil)

      {encoded_token, user_token} = TokenGenerator.build_email_token(user, "confirm")
      Repo.insert!(user_token)

      assert {:ok, confirmed_user} = UserConfirmation.confirm(encoded_token)
      assert confirmed_user.id == user.id
      refute is_nil(confirmed_user.confirmed_at)

      assert is_nil(UserAuthentication.get_user_by_session_token(encoded_token))
    end

    test "returns error with invalid token" do
      assert :error = UserConfirmation.confirm("invalid_token")
    end
  end
end
