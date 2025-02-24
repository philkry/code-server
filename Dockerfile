FROM mcr.microsoft.com/devcontainers/universal:2

# Accept the code-server version as a build argument and propagate as an environment variable.
ARG CODE_SERVER_VERSION
ENV CODE_SERVER_VERSION=${CODE_SERVER_VERSION}

# Install code-server for the specified version.
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --version ${CODE_SERVER_VERSION} && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Expose the default code-server port.
EXPOSE 8080

# Launch code-server on container start.
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none"]
