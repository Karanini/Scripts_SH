#!/bin/bash

MAC="14:3F:A6:67:72:D0"

echo "🔋 Activation du Bluetooth..."
bluetoothctl power on > /dev/null
sleep 1

echo "👤 Activation de l'agent..."
bluetoothctl agent on > /dev/null
sleep 1

echo "⭐ Définition de l'agent par défaut..."
bluetoothctl default-agent > /dev/null
sleep 1

echo "Ouverture des paramètres Bluetooth..."
gnome-control-center bluetooth

echo "🔍 Vérification si l'appareil est déjà appairé..."
if bluetoothctl paired-devices | grep -i "$MAC" > /dev/null; then
    echo "✅ L'appareil est déjà appairé."
else
    echo "🔗 Jumelage avec $MAC..."
    bluetoothctl pair "$MAC"
    sleep 5
fi

echo "Fermeture des paramètres Bluetooth..."
pkill gnome-control-center
sleep 1

echo "🔌 Tentative de connexion à $MAC..."
bluetoothctl connect "$MAC"
sleep 5

echo "🔄 Vérification de la connexion..."
if bluetoothctl info "$MAC" | grep -iq "Connected: yes"; then
    echo "🎧 Casque connecté avec succès !"
else
    echo "❌ Échec de la connexion. Vérifie que le casque est allumé et visible."
fi

