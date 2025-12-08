defmodule MyDoctor.Accounts.Services.DeleteUser do
  @moduledoc """
  User delete service.
  """
  alias MyDoctor.Accounts.Repositories.UserRepository

  def execute(id) do
    case UserRepository.get(id) do
      nil ->
        {:error, :not_found}

      user ->
        UserRepository.delete(user)
    end
  end
end
