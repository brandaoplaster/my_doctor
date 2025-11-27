#!/bin/sh

set -e

echo "🚀 Starting My Doctor development server..."

if [ ! -d "deps" ] || [ "mix.lock" -nt "deps/.mix_deps_timestamp" ]; then
  echo "📦 Installing/updating dependencies..."
  mix deps.get
  touch deps/.mix_deps_timestamp
fi

if [ ! -d "_build" ] || find lib config -newer _build/dev -print -quit | grep -q .; then
  echo "🔨 Compiling application..."
  mix compile
fi

echo "🗃️ Setting up database..."
mix ecto.create --quiet || true
mix ecto.migrate --quiet || true

echo "✅ Starting Phoenix server..."
exec mix phx.server
