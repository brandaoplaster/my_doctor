defmodule MyDoctor.Factory do
  use ExMachina.Ecto, repo: MyDoctor.Repo

  use Factories.UserFactory
  use Factories.AppointmentFactory
end
