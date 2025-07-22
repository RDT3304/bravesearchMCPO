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

# --- Dependencies for Brave Search MCP Server (Node.js) ---
# Install Node.js v22.x and npm via NodeSource, required for building and running the MCP server
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# --- MCPO Python Virtual Environment Setup ---
WORKDIR /app
ENV VIRTUAL_ENV=/app/.venv
RUN uv venv "$VIRTUAL_ENV"
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN uv pip install mcpo && rm -rf ~/.cache

# --- Specific MCP Server Source & Build Steps (Brave Search MCP Server) ---
# Clone the Brave Search MCP Server repository
WORKDIR /app/brave-search-mcp
RUN git clone https://github.com/mikechao/brave-search-mcp.git . \
    && npm install \
    && npm ci --ignore-scripts --omit-dev

# Set NODE_ENV to production for optimal runtime performance
ENV NODE_ENV=production

# --- Final Configuration ---
# Set the primary working directory back to /app for mcpo execution
WORKDIR /app

# Expose the port mcpo will listen on (changed to 8001)
EXPOSE 8001

# Set a default API key and port for mcpo.
# IMPORTANT: Change "your-secret-mcpo-api-key" to a strong, unique key
# in your deployment environment (e.g., Coolify, Kubernetes secrets, .env file).
ENV MCPO_API_KEY="your-secret-mcpo-api-key"
ENV MCPO_PORT=8001

# Set the Brave Search API key for the MCP server.
# IMPORTANT: You MUST set this to your actual Brave Search API key
# in your deployment environment for the MCP server to function properly.
# Get your API key from: https://brave.com/search/api/
ENV BRAVE_API_KEY="your-brave-search-api-key"

# Command to run mcpo, passing the Brave Search MCP Server's stdio command.
# This launches 'node brave-search-mcp/dist/index.js' as a child process
# and proxies its standard I/O to an HTTP/OpenAPI endpoint.
CMD mcpo --port ${MCPO_PORT} --api-key ${MCPO_API_KEY} -- node brave-search-mcp/dist/index.js
