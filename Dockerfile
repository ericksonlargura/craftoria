FROM openjdk:21-jdk-slim

WORKDIR /server

# Install wget for serverstarter
RUN apt-get update && apt-get install -y wget unzip

# Copy entrypoint to avoid host overriding the entire folder
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose default Minecraft port
EXPOSE 25565

# Entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
