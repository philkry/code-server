FROM codercom/code-server:latest

# Install required packages
RUN sudo apt-get update && \
    sudo apt-get install -y \
    curl \
    wget \
    unzip \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Install Node.js v20 and npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && \
    sudo apt-get install -y nodejs

# Install Docker for Debian
RUN sudo install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    sudo chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    sudo apt-get update && \
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Make sure docker group exists and add coder user to it
RUN if ! getent group docker > /dev/null; then \
        sudo groupadd docker; \
    fi && \
    sudo usermod -aG docker coder

# Clean up
RUN sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

# Create logs directory with proper permissions
RUN sudo mkdir -p "$HOME/docker_logs" && \
    sudo chown -R coder:coder "$HOME/docker_logs"

# Create startup script to run both Docker daemon and code-server
COPY --chmod=755 start.sh /usr/local/bin/start.sh

# Expose the default code-server port
EXPOSE 8080

# Use our startup script with dumb-init
ENTRYPOINT ["dumb-init", "/usr/local/bin/start.sh"]
