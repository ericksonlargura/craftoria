FROM openjdk:21-jdk-slim

WORKDIR /server

# Install wget for serverstarter
RUN apt-get update && apt-get install -y wget sudo

# Copy everything into container (from build context)
COPY . .

# Make the script executable
RUN chmod +x startserver.sh

# Accept EULA
RUN echo "eula=true" > eula.txt

# Expose default Minecraft port
EXPOSE 25565

# Run startserver.sh at container runtime (not during build)
CMD ["bash", "./startserver.sh"]
