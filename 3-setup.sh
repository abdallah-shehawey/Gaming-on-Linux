#!/usr/bin/env bash
# Step 3: everything the games share, done once.
#   - a Games folder in your home (~/Games) and the launchers in ~/Games/common
#   - one Wine setup for all the games (~/.wine-games) with DXVK inside
#     (DXVK turns DirectX into Vulkan, much faster than Wine's own)
#   - the controller setup, the same for every game
#   - the Controller Settings app in the Steam library
# After this, every new game is one run of ./4-add-game.sh.
source "$(dirname "$(readlink -f "$0")")/files/lib.sh"
title "Step 3 of 4" "Wine, controllers and Controller Settings"
command -v wine >/dev/null || fail "Wine is not installed yet: run ./1-install-programs.sh first."
command -v steam >/dev/null || fail "Steam is not installed yet: run ./1-install-programs.sh first."

part "The Games folder"
mkdir -p "$GAMES" "$COMMON"
cp -f "$FILES"/common/*.sh "$FILES"/common/*.py "$FILES"/common/dxvk.conf "$COMMON/"
chmod +x "$COMMON"/*.sh "$COMMON"/game-session.py "$COMMON"/pad-settings.py
chmod -x "$COMMON/game-options-example.sh"
ok "$GAMES          ← put each game's folder here"
ok "$COMMON   ← the launchers (leave them as they are)"

part "Wine setup for the games (~/.wine-games)"
if [[ -e $PREFIX ]]; then
    warn "There is already a Wine setup for games here."
    if ask "Start clean with a fresh one? (the old one goes to the Trash)"; then
        wineserver -k 2>/dev/null
        gio trash "$PREFIX" || fail "Could not move $PREFIX to the Trash."
        ok "old one moved to the Trash"
    else
        info "keeping it"
    fi
fi
if [[ ! -f $PREFIX/system.reg ]]; then
    info "making a new one (a minute)..."
    # mscoree/mshtml off: no Mono / Gecko download prompts; games rarely need them
    WINEPREFIX="$PREFIX" WINEARCH=win64 WINEDLLOVERRIDES="mscoree=;mshtml=" WINEDEBUG=-all \
        timeout 600 wineboot -i >/dev/null 2>&1
    WINEPREFIX="$PREFIX" timeout 120 wineserver -w 2>/dev/null
    [[ -f $PREFIX/system.reg ]] || fail "Wine could not make its setup. Run: wineboot -i  and look at the message."
fi
w() { WINEPREFIX="$PREFIX" WINEDEBUG=-all wine "$@" >/dev/null 2>&1; }
# No Windows menu entries or file links from Wine
w reg add 'HKCU\Software\Wine\DllOverrides' /v winemenubuilder.exe /d '' /f
# DXVK: the same files Steam's Proton uses, for 64-bit and 32-bit games
cp -f "$FILES"/dxvk/x64/*.dll "$PREFIX/drive_c/windows/system32/"
[[ -d $PREFIX/drive_c/windows/syswow64 ]] && cp -f "$FILES"/dxvk/x32/*.dll "$PREFIX/drive_c/windows/syswow64/"
for d in d3d9 d3d10core d3d11 dxgi; do
    w reg add 'HKCU\Software\Wine\DllOverrides' /v $d /d native,builtin /f
done
WINEPREFIX="$PREFIX" timeout 60 wineserver -w 2>/dev/null
ok "ready: $(wine --version 2>/dev/null), DXVK $(sed -n 's/^DXVK \(v[0-9.]*\).*/\1/p' "$FILES/dxvk/README.txt")"

part "Controllers"
mkdir -p "$HOME/.config/game-pads"
if [[ ! -s $HOME/.config/game-pads/mappings.txt ]]; then
    cp "$FILES/config/mappings.txt" "$HOME/.config/game-pads/mappings.txt"
    ok "a starting button map for \"Twin USB\" PS2 adapters (change it in Controller Settings)"
fi
python3 -I -c "import importlib.util as u; s=u.spec_from_file_location('p', '$COMMON/pad_maps.py'); m=u.module_from_spec(s); s.loader.exec_module(m); m.write_session_db()" \
    || warn "Could not write the controller list."
systemctl --user set-environment "SDL_GAMECONTROLLERCONFIG_FILE=$HOME/.config/game-pads/gamecontrollerdb.txt" 2>/dev/null
ok "every game gets the same buttons and the same player order"

part "Controller Settings in Steam"
steam_ready() { python3 -I "$FILES/steam/add-game.py" check >/dev/null 2>&1; }
if ! steam_ready; then
    warn "Steam has not been opened on this computer yet."
    info "Steam opens now: sign in (or make a free account) and wait until it is fully"
    info "open. Then close it from its menu: Steam > Exit. This goes on by itself."
    (setsid steam >/dev/null 2>&1 &)
    until steam_ready && ! steam_running; do sleep 3; done
    sleep 2
fi
close_steam
out=$(python3 -I "$FILES/steam/add-game.py" controller-settings 2>&1) || fail "Adding to Steam failed: $out"
gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor" >/dev/null 2>&1
ok "Controller Settings is in the Steam library"

echo
echo "  ${G}${B}Step 3 done.${N} Now add your games, one by one: ${B}./4-add-game.sh${N}"
