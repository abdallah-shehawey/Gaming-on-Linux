# Shared helpers for the numbered setup scripts in "how to play".
HERE="$(dirname "$(readlink -f "$0")")"
FILES="$HERE/files"
PREFIX="$HOME/.wine-games"
LOG="$HOME/.cache/wine-games/setup.log"
mkdir -p "${LOG%/*}"

if [[ -t 1 ]]; then
    B=$'\e[1m' D=$'\e[2m' G=$'\e[32m' Y=$'\e[33m' R=$'\e[31m' C=$'\e[36m' N=$'\e[0m'
else
    B='' D='' G='' Y='' R='' C='' N=''
fi
title() { echo; echo "${B}${C}$1${N}  ${D}$2${N}"; }
part()  { echo; echo "${B}• $*${N}"; }
ok()    { echo "  ${G}✓${N} $*"; }
warn()  { echo "  ${Y}!${N} $*"; }
info()  { echo "  ${D}$*${N}"; }
fail()  { echo; echo "  ${R}✗ $*${N}"; echo "  ${D}Log: $LOG${N}"; exit 1; }
ask()   { local a; read -r -p "  $1 [Y/n] " a; [[ ! $a =~ ^[Nn] ]]; }

# Everything printed also goes to the log, for when something needs a look
echo "== $(date '+%F %T') $(basename "$0") $*" >>"$LOG"
exec > >(tee -a "$LOG") 2>&1
[[ $EUID -eq 0 ]] && fail "Run it as yourself, without sudo:  ./$(basename "$0")"

# Where the games and the tools live (README: "Where things go")
GAMES="${GAMES_DIR:-$HOME/Games}"
COMMON="$GAMES/common"
steam_running() { pgrep -x steam >/dev/null || pgrep -x steamwebhelper >/dev/null; }
in_gamemode_group() { getent group gamemode | cut -d: -f4 | tr ',' '\n' | grep -qx "$USER"; }
nvidia_card() { lspci -d 10de: 2>/dev/null | grep -q -E 'VGA|3D|Display'; }

# fedora (Fedora, Nobara, ...), debian (Debian, Ubuntu, Mint, Pop!_OS, Zorin,
# ...), arch (Arch, Manjaro, EndeavourOS, CachyOS, ...) or other
distro_family() {
    local id like
    id=$(. /etc/os-release 2>/dev/null; echo "${ID:-}")
    like=$(. /etc/os-release 2>/dev/null; echo "${ID_LIKE:-}")
    case " $id $like " in
        *" fedora "*|*" rhel "*) echo fedora ;;
        *" debian "*|*" ubuntu "*) echo debian ;;
        *" arch "*) echo arch ;;
        *) echo other ;;
    esac
}
distro_name() { (. /etc/os-release 2>/dev/null; echo "${PRETTY_NAME:-unknown Linux}"); }

# Steam rewrites its files when it exits, so it must be closed while games are added
close_steam() {
    steam_running || return 0
    warn "Steam is open. It has to be closed for this (it rewrites its files when it exits)."
    ask "Close Steam now?" || fail "Close Steam (Steam menu > Exit), then run this again."
    steam -shutdown >/dev/null 2>&1 &
    local _
    for _ in $(seq 60); do steam_running || break; sleep 1; done
    steam_running && fail "Steam did not close. Close it from its menu (Steam > Exit), then run this again."
    ok "Steam closed"
}
