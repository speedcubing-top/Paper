#!/bin/bash

start_time=$(date +%s%3N)

sh bukkit.sh

# clone Paper
echo "[Build] Cloning Paper"
git clone -b ver/1.8.8 --single-branch git@github.com:PaperMC/Paper.git
mv paper Paper

cd Paper

sh ../spigot-patch.sh PaperSpigot-API PaperSpigot-Server

# apply spigot-api patch
echo "[Build] Applying Paper->Spigot-API Patches"
cd PaperSpigot-API
for patch in ../Spigot-API-Patches/*.patch; do
    base_name=$(basename "$patch" .patch)
    echo "[Paper->Spigot-API] Applying $base_name.patch"
    git apply --whitespace=nowarn $patch
done

cd ../

# apply spigot-server patch
echo "[Build] Applying Paper->Spigot-Server Patches"
cd PaperSpigot-Server
for patch in ../Spigot-Server-Patches/*.patch; do
    base_name=$(basename "$patch" .patch)
    echo "[Paper->Spigot-Server] applying $base_name.patch"
    git apply --whitespace=nowarn $patch
done

cd ../

# build
echo "[Build] Compiling Spigot & Spigot-API"
mvn clean install

elapsed_time=$(($(date +%s%3N) - start_time))

echo "Compiling time: ${elapsed_time} ms"

read -p "Press any key to continue . . ."