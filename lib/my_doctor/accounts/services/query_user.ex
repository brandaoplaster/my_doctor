defmodule MyDoctor.Accounts.Services.QueryUser do
  @moduledoc """
  User query service.
  """

  alias MyDoctor.Accounts.Repositories.UserRepository

  def list_all do
    UserRepository.list_all()
  end

  def get(id) do
    UserRepository.get(id)
  end

  def get!(id) do
    UserRepository.get!(id)
  end

  def get_by_email(email) do
    UserRepository.get_by_email(email)
  end
end
