FROM certbot/certbot:latest

# Install curl for connectivity checks in the entrypoint script
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*
