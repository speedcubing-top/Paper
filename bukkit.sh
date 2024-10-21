#!/bin/bash

# clone NMS
echo "[Build] Cloning NMS"
if [ ! -d "NMSClasses" ]; then
  git clone git@github.com:speedcubing-top/NMSClasses.git
else
  echo "NMSClasses folder exists, skipped."
fi

# clone bukkit
echo "[Build] Cloning Bukkit"
if [ ! -d "Bukkit" ]; then

  git clone https://hub.spigotmc.org/stash/scm/spigot/bukkit.git
  mv bukkit Bukkit
  cd Bukkit
  git reset --hard 01d1820664a5f881665b84b28871dadd132deaef
  cd ../
  
else
  echo "Bukkit folder exists, skipped."
fi

# clone craftbukkit
echo "[Build] Cloning CraftBukkit"
if [ ! -d "CraftBukkit" ]; then

  git clone -b version/1.8.8 --single-branch https://hub.spigotmc.org/stash/scm/spigot/craftbukkit.git
  mv craftbukkit CraftBukkit

  # apply craftbukkit -> nms patches
  echo "[Build] Applying CraftBukkit->NMS Patches"

  cd CraftBukkit
  mkdir -p src/main/java/net/minecraft/server

  for patch in nms-patches/*.patch; do
    base_name=$(basename "$patch" .patch)

    cp ../NMSClasses/net/minecraft/server/$base_name.java src/main/java/net/minecraft/server/$base_name.java

    echo "[CraftBukkit->NMS] Applying $base_name.patch"
    
    cd src/main/java
    git apply --whitespace=nowarn ../../../$patch
    cd ../../../
  done
  
  cd ../
  
else
  echo "CraftBukkit folder exists, skipped."
fi