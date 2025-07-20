FROM openjdk:21-jdk-slim

WORKDIR /server

# Install wget for serverstarter
RUN apt-get update && apt-get install -y wget unzip

# Download server zip
RUN wget https://github.com/ericksonlargura/craftoria/raw/main/server.zip

# Inflate server zip
RUN unzip server.zip

# Make the script executable
RUN chmod +x startserver.sh

# Accept EULA
RUN echo "eula=true" > eula.txt

# Expose default Minecraft port
EXPOSE 25565

# Run startserver.sh at container runtime
CMD ["bash", "./startserver.sh"]
