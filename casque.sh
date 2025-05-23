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

echo "📡 Lancement du scan pour détecter le périphérique..."
bluetoothctl scan on > /dev/null &
SCAN_PID=$!

# Attendre que le périphérique soit trouvé (jusqu’à 10 secondes max)
for i in {1..30}; do
    if bluetoothctl devices | grep -i "$MAC" > /dev/null; then
        echo "✅ Appareil détecté !"
        break
    fi
    sleep 1
done

# Arrêt du scan
kill $SCAN_PID >/dev/null 2>&1
bluetoothctl scan off > /dev/null

# Vérifie si le périphérique a été détecté
if ! bluetoothctl devices | grep -i "$MAC" > /dev/null; then
    echo "❌ Périphérique non détecté, abandon."
    exit 1
fi

echo "🔍 Vérification si l'appareil est déjà appairé..."
if bluetoothctl paired-devices | grep -i "$MAC" > /dev/null; then
    echo "✅ L'appareil est déjà appairé."
else
    echo "🔗 Jumelage avec $MAC..."
    bluetoothctl pair "$MAC"
    sleep 5
fi

echo "🔌 Tentative de connexion à $MAC..."
bluetoothctl connect "$MAC"
sleep 5

echo "🔄 Vérification de la connexion..."
if bluetoothctl info "$MAC" | grep -iq "Connected: yes"; then
    echo "🎧 Casque connecté avec succès !"
else
    echo "❌ Échec de la connexion. Vérifie que le casque est allumé et visible."
fi

