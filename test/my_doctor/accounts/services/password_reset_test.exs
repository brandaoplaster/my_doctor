defmodule MyDoctor.Accounts.Services.PasswordResetTest do
  use MyDoctor.DataCase

  alias MyDoctor.Accounts.Services.PasswordReset
  alias MyDoctor.Accounts.Services.TokenGenerator
  alias MyDoctor.Accounts.Services.UserAuthentication
  alias MyDoctor.Accounts.Schemas.User
  alias MyDoctor.Factory

  describe "deliver_reset_instructions/3" do
    test "delivers reset password instructions" do
      user = Factory.insert(:user, email: "current@example.com")
      reset_password_url_fun = fn token -> "http://example.com/reset_password/#{token}" end

      result =
        PasswordReset.deliver_reset_instructions(
          user,
          reset_password_url_fun
        )

      assert {:ok, %Swoosh.Email{} = response} = result
      assert response.subject == "Reset password instructions"
    end
  end

  describe "get_user_by_token/1" do
    test "returns user with valid reset password token" do
      user = Factory.insert(:user, %{email: "example@test.com"})

      {encoded_token, user_token} =
        TokenGenerator.build_email_token(user, "reset_password")

      Repo.insert!(user_token)

      assert %User{} =
               user_response = PasswordReset.get_user_by_token(encoded_token)

      assert user_response.email == user.email
    end

    test "returns nil with invalid token" do
      result = PasswordReset.get_user_by_token("invalid_token")

      assert is_nil(result)
    end
  end

  describe "reset_password/2" do
    test "resets user password with valid attributes" do
      password = "qwertyuiop123"
      hashed_password = Bcrypt.hash_pwd_salt(password)
      user = Factory.insert(:user, %{hashed_password: hashed_password})

      {token1, user_token1} = TokenGenerator.build_email_token(user, "reset_password")
      {token2, user_token2} = TokenGenerator.build_email_token(user, "confirm")
      Repo.insert!(user_token1)
      Repo.insert!(user_token2)

      attrs = %{password: "new_password123"}

      assert {:ok, updated_user} = PasswordReset.reset_password(user, attrs)
      assert Bcrypt.verify_pass("new_password123", updated_user.hashed_password)

      assert is_nil(UserAuthentication.get_user_by_session_token(token1))
      assert is_nil(UserAuthentication.get_user_by_session_token(token2))
    end

    test "returns error with invalid password" do
      user = Factory.insert(:user)

      attrs = %{password: "short"}

      result = PasswordReset.reset_password(user, attrs)

      assert {:error, changeset} = result
      assert "should be at least 12 character(s)" in errors_on(changeset).password
    end
  end
end
