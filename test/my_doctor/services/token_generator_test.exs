defmodule MyDoctor.Repositories.TokenGeneratorTest do
  use MyDoctor.DataCase

  alias MyDoctor.Accounts.Services.TokenGenerator
  alias MyDoctor.Accounts.Schemas.UserToken
  alias MyDoctor.Factory

  describe "build_session_token/1" do
    test "generator token for user" do
      user = Factory.insert(:user)

      assert {_, %UserToken{} = user_token} =
               TokenGenerator.build_session_token(user)

      assert user_token.context == "session"
      assert user_token.user_id == user.id
    end
  end

  describe "build_email_token/2" do
    test "generator token for user" do
      user = Factory.insert(:user)

      assert {_, %UserToken{} = user_token} =
               TokenGenerator.build_email_token(user, "confirm")

      assert user_token.context == "confirm"
      assert user_token.user_id == user.id
      assert user_token.sent_to == user.email
    end
  end

  describe "hash_token/1 and decode_token/1" do
    test "decodes and hashes token correctly" do
      user = Factory.insert(:user)

      {encoded_token, %UserToken{} = user_token} =
        TokenGenerator.build_email_token(user, "confirm")

      {:ok, decoded_token} = TokenGenerator.decode_token(encoded_token)

      assert TokenGenerator.hash_token(decoded_token) == user_token.token
    end
  end
end
