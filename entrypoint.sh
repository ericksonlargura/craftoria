#!/bin/bash

# Store the PID of startserver.sh
STARTSERVER_SCRIPT_PID=""

# Copy scripts to server directory if they don't exist
if [ ! -f "/server/startserver.sh" ]; then
    cp /opt/minecraft/server-setup-config.yaml /server/server-setup-config.yaml
    cp /opt/minecraft/startserver.sh /server/startserver.sh

    chmod +x /server/startserver.sh
fi

# Accept EULA
if [ ! -f "/server/eula.txt" ] || ! grep -q "eula=true" /server/eula.txt; then
    echo "Accepting Minecraft EULA..."
    echo "eula=true" > /server/eula.txt
fi

# Function to handle shutdown
shutdown_server() {
    echo "Received shutdown signal, stopping Minecraft server gracefully..."

    # Look for the actual java processes (serverstarter and minecraft)
    SERVERSTARTER_PID=$(pgrep -f "serverstarter.*jar")
    MINECRAFT_PID=$(pgrep -f "forge.*jar|minecraft_server.*jar|server.*jar" | grep -v serverstarter)

    if [ ! -z "$SERVERSTARTER_PID" ] || [ ! -z "$MINECRAFT_PID" ]; then
        echo "Found server processes, attempting graceful shutdown..."

        # Try to send stop command via serverstarter if it exists
        if [ ! -z "$SERVERSTARTER_PID" ]; then
            # Send SIGTERM to serverstarter first
            kill -TERM $SERVERSTARTER_PID 2>/dev/null
        fi

        # Wait for graceful shutdown (max 30 seconds)
        echo "Waiting for server to save and shutdown..."

        for i in {1..30}; do
            if [ -z "$(pgrep -f "serverstarter.*jar|forge.*jar|minecraft_server.*jar")" ]; then
                echo "Server stopped gracefully"
                exit 0
            fi

            echo "Waiting... ($i/30)"

            sleep 1
        done

        # Force kill if still running
        echo "Force stopping server processes"

        pkill -f "serverstarter.*jar" 2>/dev/null
        pkill -f "forge.*jar" 2>/dev/null
        pkill -f "minecraft_server.*jar" 2>/dev/null
    fi

    exit 0
}

# Set up signal handlers
trap shutdown_server SIGTERM SIGINT

# Change to server directory
cd /server

# Start the minecraft server and store PID
./startserver.sh &
STARTSERVER_SCRIPT_PID=$!

# Wait for the background process
wait $STARTSERVER_SCRIPT_PID
