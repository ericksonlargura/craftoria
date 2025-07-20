#!/bin/bash
set -e

if [ ! -f /server/startserver.sh ]; then
    echo "Downloading and extracting server files..."

    wget -O /tmp/server.zip https://github.com/ericksonlargura/craftoria/raw/main/server.zip

    unzip /tmp/server.zip -d /server

    chmod +x /server/startserver.sh

    echo "eula=true" > /server/eula.txt
fi

cd /server

exec bash ./startserver.sh
