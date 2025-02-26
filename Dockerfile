FROM codercom/code-server:latest

# Install required packages and Docker-in-Docker
RUN sudo apt-get update && \
    sudo apt-get install -y \
    curl \
    wget \
    unzip \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release && \
    # Install Node.js v20 and npm
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && \
    sudo apt-get install -y nodejs && \
    # Install Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    sudo apt-get update && \
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io && \
    # Clean up
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

# Enable Docker-in-Docker
RUN sudo dockerd &

# Expose the default code-server port
EXPOSE 8080

# Start code-server
ENTRYPOINT ["dumb-init", "code-server", "--bind-addr", "0.0.0.0:8080"]