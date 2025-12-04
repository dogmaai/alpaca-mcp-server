# Security Policy

## Security Considerations

This document outlines security considerations and best practices for the Alpaca MCP Server.

### Credential Management

1. **Never commit API credentials** to version control
   - Use `.env` files (which are gitignored) or environment variables
   - The `.gitignore` file already excludes `.env` and related files

2. **Command-line credentials are insecure**
   - Avoid passing `--api-key` or `--secret-key` on the command line
   - Command-line arguments are visible in process listings and shell history
   - Use interactive prompts or environment variables instead

3. **File permissions**
   - The `alpaca-mcp init` command automatically sets restrictive permissions (0o600) on `.env` files on Unix systems

### Network Security

1. **Default binding**
   - The server binds to `127.0.0.1` (localhost) by default for security
   - Use `0.0.0.0` only when external access is required (e.g., in containers)
   - When deploying in containers, rely on network policies for isolation
   - **Breaking Change Note**: Prior to this version, the default was `0.0.0.0`. Update your configuration if needed.

2. **DNS Rebinding Protection**
   - The MCP SDK includes DNS rebinding protection (enabled by default since v1.23.0)
   - This server explicitly configures `TransportSecuritySettings` with rebinding protection disabled for Cloud Run compatibility
   - **Security Consideration**: DNS rebinding protection helps prevent malicious websites from making requests to your local server. Disabling it is only recommended when:
     - Running behind a trusted reverse proxy (like Cloud Run)
     - The server is not accessible from untrusted networks
     - You have other network-level protections in place
   - For local development or environments where the server might be accessible from untrusted networks, consider enabling this protection by modifying `enable_dns_rebinding_protection=True` in `server.py`

### Container Security

The Dockerfile implements security best practices:
- Runs as non-root user (`alpaca`)
- Uses slim base image to minimize attack surface
- Includes health checks for orchestration
- No unnecessary packages installed

### Dependency Security

This project depends on:
- `mcp>=1.23.0` - Model Context Protocol SDK (with security fixes)
- `alpaca-py` - Official Alpaca Trading API client
- `python-dotenv` - Environment variable management
- `click` - CLI framework

Regularly update dependencies to incorporate security fixes:
```bash
pip install --upgrade alpaca-mcp-server
```

### Reporting Security Issues

If you discover a security vulnerability, please report it responsibly:

1. **Do not** open a public GitHub issue for security vulnerabilities
2. Email security concerns to the maintainers
3. Include a detailed description of the vulnerability
4. Allow reasonable time for a fix before public disclosure

### Security Updates

Security updates will be released as patch versions. Monitor the repository for:
- Security advisories
- Dependency update notifications
- Release notes mentioning security fixes

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Best Practices for Users

1. **Use paper trading** for development and testing
2. **Limit API key permissions** where possible
3. **Rotate credentials** regularly
4. **Monitor account activity** for unauthorized access
5. **Keep dependencies updated** to receive security patches
6. **Use HTTPS** when deploying the HTTP transport
7. **Implement proper network isolation** in production deployments
