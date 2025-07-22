# Start with the specified Python base image for mcpo
FROM python:3.12-slim-bookworm

# Set environment variables for non-interactive installations
ENV DEBIAN_FRONTEND=noninteractive

# Install uv (from official binary)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

# Install base dependencies (git, curl, ca-certificates)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# --- Dependencies for Brave Search MCP (Node.js) ---
# Install Node.js v22.x and npm via NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# --- MCPO Python Virtual Environment Setup ---
WORKDIR /app
ENV VIRTUAL_ENV=/app/.venv
RUN uv venv "$VIRTUAL_ENV"
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN uv pip install mcpo && rm -rf ~/.cache

# --- Brave Search MCP Source Code & Build Steps ---
# Clone the Brave Search MCP repository
WORKDIR /
RUN git clone https://github.com/mikechao/brave-search-mcp.git /mcp_server_src

# Change to its directory
WORKDIR /mcp_server_src

# Install Node.js dependencies
RUN npm install

# Build the TypeScript code (outputs to dist/ directory)
RUN npm run build # <-- This command creates the 'dist' directory!

# --- Final Configuration ---
# Set the primary working directory back to /app for mcpo execution
WORKDIR /app

# Expose the port mcpo will listen on (default 8000)
EXPOSE 8000

# Set default API keys and port for mcpo and Brave Search MCP.
# IMPORTANT: These should be overridden with strong, unique keys
# in your deployment environment (e.g., Coolify, Kubernetes secrets, .env file).
ENV MCPO_API_KEY="your-secret-mcpo-api-key"
ENV MCPO_PORT=8000
# YOU MUST SET THIS IN COOLIFY!
ENV BRAVE_API_KEY="your-brave-search-api-key"

# Command to run mcpo, passing the Brave Search MCP's stdio command.
# This launches the compiled Brave Search MCP server and proxies its standard I/O to mcpo.
CMD mcpo --port ${MCPO_PORT} --api-key ${MCPO_API_KEY} -- node /mcp_server_src/dist/index.js --apiKey ${BRAVE_API_KEY}
