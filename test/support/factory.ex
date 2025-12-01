defmodule MyDoctor.Factory do
  use ExMachina.Ecto, repo: MyDoctor.Repo

  use MyDoctor.UserFactory
end
