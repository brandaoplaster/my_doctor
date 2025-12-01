defmodule MyDoctor.Repositories.UserRepositoryTest do
  use MyDoctor.DataCase

  alias MyDoctor.Accounts.Schemas.User
  alias MyDoctor.Accounts.Repositories.UserRepository
  alias MyDoctor.Factory

  describe "get_by_email/1" do
    test "does not return the user if the email does not exist" do
      refute UserRepository.get_by_email("unknown@example.com")
    end

    test "returns the user if the email exists" do
      %{id: id} = user = Factory.insert(:user)
      assert %User{id: ^id} = UserRepository.get_by_email(user.email)
    end
  end

  describe "get!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        UserRepository.get!(-1)
      end
    end

    test "returns the user with the given id" do
      %{id: id} = user = Factory.insert(:user)
      assert %User{id: ^id} = UserRepository.get!(user.id)
    end
  end

  describe "create/1" do
    test "requires email and password to be set" do
      {:error, changeset} = UserRepository.create(%{})

      assert %{
               password: ["can't be blank"],
               email: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates email and password when given" do
      {:error, changeset} =
        UserRepository.create(%{email: "not valid", password: "not valid"})

      errors = errors_on(changeset)

      assert Map.has_key?(errors, :email)
      assert Map.has_key?(errors, :password)

      assert ["must have the @ sign and no spaces"] =
               errors[:email]

      assert ["should be at least 12 character(s)"] =
               errors[:password]
    end

    test "validates maximum values for email and password for security" do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = UserRepository.create(%{email: too_long, password: too_long})
      assert "should be at most 160 character(s)" in errors_on(changeset).email
      assert "should be at most 72 character(s)" in errors_on(changeset).password
    end

    test "validates email uniqueness" do
      %{email: email} = Factory.insert(:user)
      {:error, changeset} = UserRepository.create(%{email: email})
      assert "has already been taken" in errors_on(changeset).email

      {:error, changeset} = UserRepository.create(%{email: String.upcase(email)})
      assert "has already been taken" in errors_on(changeset).email
    end

    test "registers user with a hashed password" do
      user_params = %{
        email: "user@register.com",
        password: "qwertyuiop12345"
      }

      {:ok, user} = UserRepository.create(user_params)
      assert user.email == user_params.email
      assert is_binary(user.hashed_password)
      assert is_nil(user.confirmed_at)
      assert is_nil(user.password)
    end
  end
end
