#!/bin/bash

# Chiedere i permessi di superutente
if [ "$EUID" -ne 0 ]; then
  echo "Per favore esegui lo script come superutente (sudo)."
  exit
fi

# Cartelle da spostare
folders=(cone asphalt_plane grass mat oak_tree)

# Directory di destinazione
dest_folder="$HOME/.gazebo/models"

# Entrare nella cartella steer_bot
cd steer_bot || { echo "Cartella steer_bot non trovata"; exit 1; }

# Sposta le cartelle
for folder in "${folders[@]}"; do
  if [ -d "$folder" ]; then
    mv "$folder" $dest_folder/
    echo "Spostamento di $folder completato."
  else
    echo "La cartella $folder non esiste."
  fi
done

# Verifica e crea la cartella worlds se non esiste
worlds_folder="/usr/share/gazebo-11/worlds"
if [ ! -d "$worlds_folder" ]; then
  mkdir -p $worlds_folder
  echo "Cartella $worlds_folder creata."
fi

# Spostare il file new_world.world
if [ -f "new_world.world" ]; then
  mv "new_world.world" $worlds_folder/
  echo "Spostamento di new_world.world completato."
else
  echo "Il file new_world.world non esiste."
fi

# Percorsi specifici ai file
launch_file="$HOME/catkin_ws/src/steer_bot/steer_bot_gazebo/launch/steer_bot_sim.launch"
pure_pursuit_file="$HOME/catkin_ws/src/autonomous_steer_bot/control/src/pure_pursuit.py"

# Modifica steer_bot_sim.launch
if [ -f "$launch_file" ]; then
    awk '
        /<arg name="world_name" default="\/worlds\/empty_world"\/>/ {
            print "<!-- " $0 " -->"
            print "  <arg name=\"world_name\" default=\"/worlds/new_world.world\"/>"
            next
        }
        { print }
    ' $launch_file > temp_file && mv temp_file $launch_file
    echo "Modifica di steer_bot_sim.launch completata."
else
    echo "Il file steer_bot_sim.launch non esiste."
fi

# Modifica pure_pursuit.py
if [ -f "$pure_pursuit_file" ]; then
  python3 modify_file.py $pure_pursuit_file 
  echo "Modifica di pure_pursuit.py completata."
else
  echo "Il file pure_pursuit.py non esiste."
fi
echo "Finito."
