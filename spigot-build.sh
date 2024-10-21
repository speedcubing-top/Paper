#!/bin/bash

start_time=$(date +%s%3N)

sh bukkit.sh

# clone Spigot
echo "[Build] Cloning Spigot"

if [ -d "Spigot" ]; then
  echo "[Error] Please delete Spigot folder."
  read -p "Press any key to continue . . ."
  exit
fi

git clone -b version/1.8.8 --single-branch https://hub.spigotmc.org/stash/scm/spigot/spigot.git
mv spigot Spigot

cd Spigot

sh ../spigot-patch.sh Spigot-API Spigot-Server

# build
echo "[Build] Compiling Spigot & Spigot-API"
mvn clean install

elapsed_time=$(($(date +%s%3N) - start_time))

echo "Compiling time: ${elapsed_time} ms"

read -p "Press any key to continue . . ."