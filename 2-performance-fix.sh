#!/usr/bin/env bash
# Step 2: the performance fix.
#
# Why: PES 2021 stuttered because the Linux kernel slows down any program that
# does "split lock" memory accesses, and the game's threads do that all the
# time. GameMode switches that slowdown off while a game runs (and puts the
# CPU at full speed), but only for users in the "gamemode" group. The game
# launchers already start every game through GameMode, so the whole fix is
# this one command, then one restart:
#
#     sudo usermod -aG gamemode $USER
#
# Check it while a game runs:  cat /proc/sys/kernel/split_lock_mitigate
#   0 = the fix is working        1 = slowdown on (normal when no game runs)
source "$(dirname "$(readlink -f "$0")")/files/lib.sh"
title "Step 2 of 4" "The performance fix"

command -v gamemoderun >/dev/null || fail "GameMode is not installed yet: run ./1-install-programs.sh first."
# Fedora, Debian, Ubuntu and Arch make the group when GameMode is installed
getent group gamemode >/dev/null || sudo groupadd -r gamemode || fail "Could not make the gamemode group."

part "Let GameMode switch the split-lock slowdown off during games"
if in_gamemode_group; then
    ok "you are already in the gamemode group"
else
    info "sudo usermod -aG gamemode $USER"
    sudo usermod -aG gamemode "$USER" || fail "The command did not work."
    ok "you are in the gamemode group now"
fi

part "Back to the normal CPU speed after a game"
# The launchers raise the power profile before GameMode starts, so GameMode
# would otherwise keep "performance" after the game
if [[ ! -f $HOME/.config/gamemode.ini ]]; then
    mkdir -p "$HOME/.config"
    cp "$FILES/config/gamemode.ini" "$HOME/.config/gamemode.ini"
elif ! grep -q '^defaultgov' "$HOME/.config/gamemode.ini"; then
    printf '\n[general]\ndefaultgov=powersave\n' >>"$HOME/.config/gamemode.ini"
fi
ok "~/.config/gamemode.ini"

echo
if id -nG | tr ' ' '\n' | grep -qx gamemode; then
    echo "  ${G}${B}Step 2 done.${N} Next: ${B}./3-setup.sh${N}"
else
    echo "  ${G}${B}Step 2 done.${N} ${Y}${B}Restart the computer now${N}${Y} so it takes effect,${N}"
    echo "  then run ${B}./3-setup.sh${N}"
fi
