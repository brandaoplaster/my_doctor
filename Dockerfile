#############################################
# Base stage
#############################################
FROM elixir:1.15.7-alpine AS base

# Install build dependencies (SEM nodejs/npm)
RUN apk add --no-cache \
    build-base \
    git \
    postgresql-client \
    inotify-tools \
    curl

# Create user with same UID/GID as host user
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN addgroup -g ${GROUP_ID} -S elixir && \
    adduser -u ${USER_ID} -S elixir -G elixir -s /bin/sh

# Set work directory
WORKDIR /app

# Change ownership
RUN chown -R elixir:elixir /app

# Switch to elixir user
USER elixir

# Install Hex and Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

#############################################
# Dependencies stage
#############################################
FROM base AS deps

# Copy mix files first for better caching
COPY --chown=elixir:elixir mix.exs mix.lock ./

# Install dependencies (esbuild will be installed here)
RUN mix deps.get

#############################################
# Build dependencies stage
#############################################
FROM deps AS build_deps

ENV MIX_ENV=dev

# Compile dependencies
RUN mix deps.compile

#############################################
# Development stage
#############################################
FROM build_deps AS development

# Copy scripts first
COPY --chown=elixir:elixir scripts/ ./scripts/

# Make all scripts executable
RUN find ./scripts -type f -name "*.sh" -exec chmod +x {} \;

# Copy rest of application code
COPY --chown=elixir:elixir . .

# Expose Phoenix port
EXPOSE 4000

# Default command
CMD ["mix", "phx.server"]

#############################################
# Production builder stage
#############################################
FROM deps AS prod_builder

ENV MIX_ENV=prod

# Copy application code
COPY --chown=elixir:elixir . .

# Compile dependencies and application
RUN mix deps.compile && \
    mix compile

# Build assets using esbuild (NO npm needed!)
RUN mix assets.deploy

# Create release
RUN mix release

#############################################
# Production runtime stage
#############################################
FROM alpine:3.18 AS production

# Install runtime dependencies only
RUN apk add --no-cache \
    libstdc++ \
    openssl \
    ncurses-libs \
    curl

# Create non-root user
RUN addgroup -g 1000 -S elixir && \
    adduser -u 1000 -S elixir -G elixir

WORKDIR /app

# Copy release from builder
COPY --from=prod_builder --chown=elixir:elixir /app/_build/prod/rel/my_doctor ./

# Switch to non-root user
USER elixir

# Expose port
EXPOSE 4000

ENV PORT=4000
ENV MIX_ENV=prod

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s \
    CMD curl -f http://localhost:${PORT}/ || exit 1

# Start the release
CMD ["bin/my_doctor", "start"]
