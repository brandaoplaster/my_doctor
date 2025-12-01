defmodule MyDoctor.Accounts.Services.EmailUpdateTest do
  use MyDoctor.DataCase

  alias MyDoctor.Accounts.Services.EmailUpdate
  alias MyDoctor.Accounts.Schemas.User
  alias MyDoctor.Factory

  describe "change_email/2" do
    test "returns a changeset for changing email" do
      user = Factory.insert(:user, email: "old@example.com")

      changeset = EmailUpdate.change_email(user, %{email: "new@example.com"})

      assert %Ecto.Changeset{} = changeset
      assert changeset.data == user
      assert changeset.changes.email == "new@example.com"
    end
  end

  describe "apply_email/2" do
    test "applies email change with valid password" do
      password = "qwertyuiop123"
      hashed_password = Bcrypt.hash_pwd_salt(password)

      user =
        Factory.insert(:user, %{
          email: "user@test.com",
          hashed_password: hashed_password
        })

      attrs = %{email: "lucas@test.com"}

      result = EmailUpdate.apply_email(user, password, attrs)

      assert {:ok, %User{} = updated_user} = result
      assert updated_user.email == "lucas@test.com"
    end

    test "returns error with invalid password" do
      user = Factory.insert(:user, email: "old@example.com", password: "valid_password123")

      result = EmailUpdate.apply_email(user, "wrong_password", %{email: "new@example.com"})

      assert {:error, changeset} = result
      assert "is not valid" in errors_on(changeset).current_password
    end
  end

  describe "deliver_update_instructions/3" do
    test "delivers update email instructions" do
      user = Factory.insert(:user, email: "current@example.com")
      update_email_url_fun = fn token -> "http://example.com/update/#{token}" end

      result =
        EmailUpdate.deliver_update_instructions(
          user,
          "current@example.com",
          update_email_url_fun
        )

      assert {:ok, %Swoosh.Email{} = email} = result

      assert email.subject == "Update email instructions"
    end
  end
end
