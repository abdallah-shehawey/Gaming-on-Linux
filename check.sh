#!/usr/bin/env bash
# Shows what is ready on this computer and what is missing. Changes nothing.
# Send a screenshot of it if something does not work.
source "$(dirname "$(readlink -f "$0")")/files/lib.sh"
title "Check" "what is ready on this computer"
row() { if eval "$2"; then ok "$1"; else echo "  ${R}✗${N} $1"; fi; }
part "Step 1: programs"
ok "$(distro_name) ($(distro_family) family)"
row "Steam" 'command -v steam >/dev/null'
row "Wine $(wine --version 2>/dev/null)" 'command -v wine >/dev/null'
row "winetricks" 'command -v winetricks >/dev/null'
row "GameMode" 'command -v gamemoderun >/dev/null'
row "GTK 4 + libadwaita for Controller Settings" 'python3 -c "import gi; gi.require_version(\"Adw\", \"1\"); from gi.repository import Adw" 2>/dev/null'
row "SDL3 (the system's or Steam's)" 'python3 -I -c "import importlib.util as u; s=u.spec_from_file_location(\"p\", \"$FILES/common/pad_maps.py\"); m=u.module_from_spec(s); s.loader.exec_module(m); m.SDL()" 2>/dev/null'
nvidia_card && row "NVIDIA driver running" '[[ -e /proc/driver/nvidia/version ]]'
part "Step 2: performance fix"
row "in the gamemode group" 'in_gamemode_group'
row "active (restarted since)" 'id -nG | tr " " "\n" | grep -qx gamemode'
info "split_lock_mitigate now: $(cat /proc/sys/kernel/split_lock_mitigate 2>/dev/null || echo n/a)   (1 = no game running, 0 = during a game)"
part "Step 3: shared setup"
row "Games folder $GAMES" '[[ -d $GAMES ]]'
row "launchers in $COMMON" '[[ -x $COMMON/play.sh && -x $COMMON/steam-launch.sh ]]'
row "Wine setup ~/.wine-games" '[[ -f $PREFIX/system.reg ]]'
row "DXVK in it" '[[ -f $PREFIX/drive_c/windows/system32/dxgi.dll ]] && grep -q "\"dxgi\"=\"native,builtin\"" "$PREFIX/user.reg"'
row "controller setup" '[[ -f $HOME/.config/environment.d/60-game-pads.conf ]]'
pads=$(python3 -I "$FILES/common/pad_maps.py" --json 2>/dev/null | python3 -c 'import json,sys; print(len(json.load(sys.stdin)))' 2>/dev/null)
info "controllers connected now: ${pads:-0}"
part "Step 4: games in Steam"
if python3 -I "$FILES/steam/add-game.py" check >/dev/null 2>&1; then
    python3 -I "$FILES/steam/add-game.py" list | while IFS=$'\t' read -r id name launch; do
        exe=$(sed -n 's/.*" "\(.*\)"$/\1/p' <<<"$launch")
        if [[ -z $exe || -f $exe ]]; then ok "$name"; else echo "  ${R}✗${N} $name: its .exe is gone ($exe)"; fi
    done
else
    echo "  ${R}✗${N} Steam: open it once and sign in"
fi
