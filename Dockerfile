FROM openjdk:21-jdk-slim

WORKDIR /server

# Install wget for serverstarter
RUN apt-get update && apt-get install -y wget unzip dos2unix

# Copy entrypoint to avoid host overriding the entire folder
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Fix line endings and make the entrypoint script executable
RUN dos2unix /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose default Minecraft port
EXPOSE 25565

# Entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
