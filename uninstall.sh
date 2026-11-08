#!/usr/bin/env bash
# Undoes steps 3 and 4: takes the games this setup added out of Steam and
# moves the games' Wine setup to the Trash. Your game folders, your saves, the
# programs (Steam, Wine, ...) and the performance fix stay. Close Steam first.
source "$(dirname "$(readlink -f "$0")")/files/lib.sh"
title "Uninstall" "take the setup out again"
ask "Remove the added games from Steam and move ~/.wine-games to the Trash?" || exit 0
close_steam
python3 -I "$FILES/steam/add-game.py" list 2>/dev/null | while IFS=$'\t' read -r id name launch; do
    python3 -I "$FILES/steam/add-game.py" remove --name "$name" >/dev/null && ok "out of Steam: $name"
done
if [[ -d $PREFIX ]]; then
    wineserver -k 2>/dev/null
    gio trash "$PREFIX" && ok "~/.wine-games is in the Trash"
fi
rm -f "$HOME/.config/environment.d/60-game-pads.conf" "$HOME"/.local/share/applications/steam-game-*.desktop
ok "done; the controller maps stay in ~/.config/game-pads"
