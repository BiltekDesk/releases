#!/bin/bash

FLATPAK_URL="https://github.com/BiltekDesk/releases/releases/download/latest/biltekdesk.flatpak"
FLATPAK_FILE="biltekdesk.flatpak"

echo "BiltekDesk installing..."

if ! command -v flatpak &> /dev/null; then
    echo "Flatpak not found, installing..."
    sudo apt install -y flatpak
fi

echo "Adding Flathub repository..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Installing runtime..."
sudo flatpak install -y flathub org.freedesktop.Platform//24.08 org.freedesktop.Sdk//24.08

echo "App downloading..."
curl -L -o "$FLATPAK_FILE" "$FLATPAK_URL"

if [ ! -f "$FLATPAK_FILE" ]; then
    echo "Download failed!"
    exit 1
fi

echo "App installing..."
flatpak install -y "$FLATPAK_FILE"

echo "Starting desktop integration..."
sudo ln -sf /var/lib/flatpak/exports/share/applications/tr.com.biltekbilgisayar.desk.desktop \
    /usr/share/applications/tr.com.biltekbilgisayar.desk.desktop

update-desktop-database 2>/dev/null || true
gtk-update-icon-cache -f /usr/share/icons/hicolor 2>/dev/null || true

rm -f "$FLATPAK_FILE"

echo ""
echo "BiltekDesk installed successfully!"
echo "You can start the app from the app list or run 'flatpak run tr.com.biltekbilgisayar.desk' in terminal."
