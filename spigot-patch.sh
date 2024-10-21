#!/bin/bash

cp -r ../Bukkit $1
cp -r ../CraftBukkit $2

# apply bukkit patch
echo "[Build] Applying Spigot->Bukkit Patches"
cd $1
for patch in ../Bukkit-Patches/*.patch; do
    base_name=$(basename "$patch" .patch)
    echo "[Spigot->Bukkit] Applying $base_name.patch"
    git apply --whitespace=nowarn $patch
done

cd ../

# apply craftbukkit patch
echo "[Build] Applying Spigot->CraftBukkit Patches"
cd $2
for patch in ../CraftBukkit-Patches/*.patch; do
    base_name=$(basename "$patch" .patch)
    echo "[Spigot->CraftBukkit] applying $base_name.patch"
    git apply --whitespace=nowarn $patch
done

cd ../