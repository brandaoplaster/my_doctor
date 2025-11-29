defmodule MyDoctor.Accounts.Services.TokenGenerator do
  @moduledoc """
  Token generation service.
  """

  alias MyDoctor.Accounts.Schemas.UserToken

  @hash_algorithm :sha256
  @rand_size 32

  @doc """
  Generates a session token.
  """
  def build_session_token(user) do
    token = :crypto.strong_rand_bytes(@rand_size)
    {token, %UserToken{token: token, context: "session", user_id: user.id}}
  end

  @doc """
  Builds a hashed token for email delivery.
  """
  def build_email_token(user, context) do
    build_hashed_token(user, context, user.email)
  end

  defp build_hashed_token(user, context, sent_to) do
    token = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    {Base.url_encode64(token, padding: false),
     %UserToken{
       token: hashed_token,
       context: context,
       sent_to: sent_to,
       user_id: user.id
     }}
  end

  @doc """
  Hashes a token.
  """
  def hash_token(token) do
    :crypto.hash(@hash_algorithm, token)
  end

  @doc """
  Decodes a URL-safe token.
  """
  def decode_token(token) do
    Base.url_decode64(token, padding: false)
  end
end
