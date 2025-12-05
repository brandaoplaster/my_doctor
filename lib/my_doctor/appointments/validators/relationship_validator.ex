defmodule MyDoctor.Appointments.Validators.RelationshipValidator do
  @moduledoc """
  Relationship validation functions for appointments.
  """

  import Ecto.Changeset

  @doc """
  Validates that user and provider are not the same person.
  """
  def validate_user_not_provider(changeset) do
    user_id = get_field(changeset, :user_id)
    provider_id = get_field(changeset, :provider_id)

    case {user_id, provider_id} do
      {id, id} when not is_nil(id) ->
        add_error(changeset, :provider_id, "cannot be the same as user")

      _ ->
        changeset
    end
  end
end
