FROM python:3.11-slim

# Security: Create a non-root user
RUN groupadd -r alpaca && useradd -r -g alpaca alpaca

WORKDIR /app

# Copy project files
COPY pyproject.toml README.md ./
COPY src/ ./src/
COPY .github/core .github/core

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir .

# Security: Change ownership to non-root user
RUN chown -R alpaca:alpaca /app

# Security: Switch to non-root user
USER alpaca

# Health check for container orchestration
# Verifies the Python module is importable and the CLI is functional
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "from alpaca_mcp_server import __version__; print(__version__)" || exit 1

# Run the MCP server with HTTP transport
# Note: Using 0.0.0.0 in container context is required for external access
# The container network provides isolation
CMD ["alpaca-mcp-server", "serve", "--transport", "streamable-http", "--host", "0.0.0.0", "--port", "8080"]
