defmodule Factories.AppointmentFactory do
  alias MyDoctor.Appointments.Schemas.Appointment

  defmacro __using__(_opts) do
    quote do
      def appointment_factory do
        %Appointment{
          date: Faker.DateTime.forward(30),
          user: build(user),
          provider: build(user),
          status: Enum.random(["pending", "confirmed", "cancelled", "completed"])
        }
      end
    end
  end
end
