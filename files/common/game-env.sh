# Shared setup for every game, sourced by play.sh.
# All games use one Wine setup (~/.wine-games): a runtime installed once with
# fix-game.sh serves every game, and Wine reads the pad map when it starts, so
# every game gets the same buttons.
COMMON="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
LOG_DIR="$HOME/.cache/wine-games"

export WINEPREFIX="${WINEPREFIX:-$HOME/.wine-games}"
export WINEDEBUG="${WINEDEBUG:-fixme-all}"

# Laptops with an NVIDIA card next to the built-in one: run on the NVIDIA card
if [[ -e /proc/driver/nvidia/version ]]; then
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __VK_LAYER_NV_optimus=NVIDIA_only
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
fi
export DXVK_LOG_LEVEL="${DXVK_LOG_LEVEL:-none}"
export DXVK_CONFIG_FILE="$COMMON/dxvk.conf"

# Keep compiled shaders between runs so their stutter only happens once
export __GL_SHADER_DISK_CACHE=1
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1

# Every pad with each button where a PlayStation pad has it, in the player
# order set in Controller Settings. Games show Xbox letters on screen:
# A is Cross, B is Circle, X is Square, Y is Triangle.
source "$COMMON/pads.sh"

# Intel CPUs from the 12th generation on have fast (P) and slow (E) cores; a
# game's worker threads fall behind on the slow ones and it stutters, so games
# get the fast ones only. Other CPUs: every core.
if [[ -r /sys/devices/cpu_core/cpus ]]; then
    GAME_CPUS=$(cat /sys/devices/cpu_core/cpus)
else
    GAME_CPUS="0-$(($(nproc --all) - 1))"
fi

# Run the game in the current folder and log to $LOG_DIR/$GAME_ID.log.
# gamemoderun raises the CPU speed and turns off the split-lock slowdown while
# the game runs. wineserver -w keeps the session open when the .exe only starts
# the real game (a launcher) and exits.
run_game() {
    mkdir -p "$LOG_DIR"
    exec python3 "$COMMON/game-session.py" taskset -c "$GAME_CPUS" gamemoderun \
        bash -c 'wine "$@"; wineserver -w' wine "$@" >"$LOG_DIR/$GAME_ID.log" 2>&1
}
