#!/usr/bin/env bash
# Starts one Windows game; every game added to Steam goes through this.
#   play.sh "/path/to/the game/Game.exe" [anything the game should get]
# Steam starts it through steam-launch.sh (4-add-game.sh sets that up).
#
# Settings for one game only go in a file named game-options.sh next to the
# game's .exe (an example: game-options-example.sh in this folder):
#   GAME_60HZ=1                     screen to 60 Hz while it runs (games locked at 60 fps)
#   export DXVK_HUD=fps             frame counter in the corner
#   export WINEDLLOVERRIDES="..."   use a DLL from the game folder instead of Wine's
#   GAME_ARGS="-windowed"           extra words given to the game
EXE=$(readlink -f "${1:?usage: play.sh /path/to/Game.exe}")
shift
[[ -f $EXE ]] || { echo "play.sh: no such file: $EXE" >&2; exit 1; }
GAME_DIR=$(dirname "$EXE")
export GAME_NAME="${GAME_NAME:-$(basename "$EXE" .exe)}"
GAME_ID=$(tr -c 'A-Za-z0-9._\n-' '_' <<<"$GAME_NAME")
GAME_ARGS=""
GAME_60HZ=0
source "$(dirname "$(readlink -f "$0")")/game-env.sh"
cd "$GAME_DIR" || exit 1
[[ -f $GAME_DIR/game-options.sh ]] && source "$GAME_DIR/game-options.sh"
export GAME_60HZ
# shellcheck disable=SC2086  # GAME_ARGS is a list of words on purpose
run_game "$(basename "$EXE")" $GAME_ARGS "$@"
