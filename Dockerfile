FROM python:3.11-slim
WORKDIR /app

# Copy project files
COPY pyproject.toml README.md ./
COPY src/ ./src/
COPY .github/core .github/core

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir .

# Run the MCP server with HTTP transport
CMD ["alpaca-mcp-server", "serve", "--transport", "streamable-http", "--host", "0.0.0.0", "--port", "8080"]
