defmodule MyDoctor.Repositories.UserAuthenticationTest do
  use MyDoctor.DataCase

  alias MyDoctor.Accounts.Services.UserAuthentication
  alias MyDoctor.Factory

  describe "delete_session_token/1" do
    test "deletes the token" do
      user = Factory.insert(:user)
      token = UserAuthentication.generate_session_token(user)
      assert UserAuthentication.delete_session_token(token) == :ok
      refute UserAuthentication.get_user_by_session_token(token)
    end
  end

  describe "get_user_by_session_token/1" do
    test "get user by session token" do
      user = Factory.insert(:user)
      token = UserAuthentication.generate_session_token(user)
      user_session = UserAuthentication.get_user_by_session_token(token)
      assert user.id == user_session.id
    end
  end

  describe "generate_session_token/1" do
    test "generation session token per user" do
      user = Factory.insert(:user)
      token = UserAuthentication.generate_session_token(user)
      user_session = UserAuthentication.get_user_by_session_token(token)
      assert user.id == user_session.id
    end
  end

  describe "authenticate/2" do
    test "authentication user" do
      email = "user@test.com"
      password = Bcrypt.hash_pwd_salt("qwertyuiop123")

      user =
        Factory.insert(
          :user,
          %{email: email, hashed_password: password}
        )

      assert {:ok, user_logger} =
               UserAuthentication.authenticate(email, "qwertyuiop123")

      assert user.id == user_logger.id
    end
  end
end
