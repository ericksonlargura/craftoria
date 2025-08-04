FROM openjdk:21-jdk-slim

WORKDIR /server

# Install wget for startserver.sh
RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

# Create a scripts directory that won't be overridden
RUN mkdir -p /opt/minecraft

# Copy scripts to a safe location
COPY entrypoint.sh /opt/minecraft/entrypoint.sh
COPY server-setup-config.yaml /opt/minecraft/server-setup-config.yaml
COPY startserver.sh /opt/minecraft/startserver.sh

# Make scripts executable
RUN chmod +x /opt/minecraft/entrypoint.sh /opt/minecraft/startserver.sh

# Expose default Minecraft port
EXPOSE 25565

# Entrypoint
ENTRYPOINT ["/opt/minecraft/entrypoint.sh"]
