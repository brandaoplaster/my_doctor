# My Doctor

A healthcare management system built with Phoenix Framework.

## 🚀 Getting Started with Docker

### Prerequisites

- Docker
- Docker Compose

### Setup

1. **Clone the repository**
```bash
   git clone git@github.com:brandaoplaster/my_doctor.git
   cd my_doctor
```

2. **Create environment file**
```bash
   cp .env.example .env
```

3. **Generate secret key**
```bash
   docker compose run --rm my_doctor mix phx.gen.secret
```
   Copy the generated key and paste it in `.env` as `SECRET_KEY_BASE`

4. **Update `.env` file**
```env
   # Database
   POSTGRES_USER=postgres
   POSTGRES_PASSWORD=postgres
   POSTGRES_DB=my_doctor_dev
   POSTGRES_HOST=my_doctor_db
   POSTGRES_PORT=5432

   # Phoenix
   DATABASE_URL=ecto://postgres:postgres@my_doctor_db/my_doctor_dev
   SECRET_KEY_BASE=<paste_your_generated_secret_here>
   PHX_HOST=localhost
   PHX_PORT=4000
```

5. **Build and start the application**
```bash
   docker compose up --build
```

6. **Access the application**
   - Application: http://localhost:4000

### Common Commands
```bash
# Start the application
docker compose up

# Start in detached mode (background)
docker compose up -d

# Stop the application
docker compose down

# View logs
docker compose logs -f my_doctor

# Access Elixir console (IEx)
docker compose run --rm my_doctor iex -S mix

# Run migrations
docker compose run --rm my_doctor mix ecto.migrate

# Run tests
docker compose run --rm my_doctor mix test

# Reset database
docker compose run --rm my_doctor mix ecto.reset

# Run code quality checks
docker compose run --rm my_doctor mix credo --strict
docker compose run --rm my_doctor mix sobelow

# Generating report coveralls
docker compose run --rm my_doctor mix coveralls.html
```

## 🛠️ Development

The application uses:
- **Elixir** 1.15.7
- **Phoenix** 1.6.10
- **PostgreSQL** 13
- **Guardian** for JWT authentication
- **Argon2** for password hashing

### Project Structure
```
my_doctor/
├── lib/
│   ├── my_doctor/          # Business logic
│   └── my_doctor_web/      # Web interface
├── config/                 # Configuration files
├── priv/                   # Static files and migrations
├── test/                   # Tests
├── scripts/                # Helper scripts
├── docker-compose.yml      # Docker setup
├── Dockerfile              # Docker image definition
└── .env                    # Environment variables (not in git)
```


## License

This project is licensed under the MIT License - see the LICENSE file for details.
