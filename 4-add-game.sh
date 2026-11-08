#!/usr/bin/env bash
# Step 4: put one game in the Steam library. Run it again for every new game.
#
#   ./4-add-game.sh                       asks for everything (drag files into the window)
#   ./4-add-game.sh "/path/Game.exe" "Name" [cover] [hero] [logo] [icon]
#
# Pictures are optional: steamgriddb.com has them for most games (cover =
# the tall one 600x900, hero = the wide banner 1920x620, logo = the name with a
# clear background, icon = the small square). You can also set them later in
# Steam: right-click the game > Manage > Set custom artwork.
source "$(dirname "$(readlink -f "$0")")/files/lib.sh"
title "Step 4" "Add a game to Steam"
[[ -x $COMMON/play.sh ]] || fail "Run ./3-setup.sh first."

# a path typed or dragged into the terminal: drop quotes and the trailing space
clean_path() { local p=$1; p=${p%% }; p=${p#\'}; p=${p%\'}; p=${p#\"}; p=${p%\"}; printf '%s' "$p"; }
ask_file() {
    local prompt=$1 p
    read -r -p "  $prompt " p
    p=$(clean_path "$p")
    printf '%s' "$p"
}

EXE=$(clean_path "${1:-}")
if [[ -z $EXE ]]; then
    info "Open the game's folder in Files, then drag the game's .exe file into"
    info "this window and press Enter. (The .exe that starts the game, not setup.exe)"
    EXE=$(ask_file ".exe:")
fi
[[ -f $EXE ]] || fail "Not a file: $EXE"
[[ ${EXE,,} == *.exe ]] || fail "That is not a .exe file: $EXE"
EXE=$(readlink -f "$EXE")
case $EXE in
    "$GAMES"/*|"$PREFIX"/*) ;;
    *) warn "The game is outside $GAMES. Better: move its folder into $GAMES first,"
       info "so it stays on the laptop's own drive and nothing breaks if a USB drive is removed."
       ask "Add it from where it is anyway?" || exit 0 ;;
esac
ok "$EXE"

NAME=${2:-}
if [[ -z $NAME ]]; then
    guess=$(basename "$(dirname "$EXE")")
    read -r -p "  Name in Steam [$guess]: " NAME
    NAME=${NAME:-$guess}
fi
ok "name: $NAME"

COVER=${3:-} HERO=${4:-} LOGO=${5:-} ICON=${6:-}
if [[ $# -lt 3 ]]; then
    echo
    info "Pictures (optional). Drag each picture into the window and press Enter,"
    info "or just press Enter to skip it."
    COVER=$(ask_file "cover (tall, 600x900):")
    HERO=$(ask_file "hero  (wide banner):  ")
    LOGO=$(ask_file "logo  (the name):     ")
    ICON=$(ask_file "icon  (small square): ")
fi
pics=()
for kind in cover hero logo icon; do
    v=${kind^^}; f=${!v}
    [[ -z $f ]] && continue
    [[ -f $f ]] || fail "Not a file: $f"
    pics+=("--$kind" "$f")
done

close_steam
out=$(python3 -I "$FILES/steam/add-game.py" add --name "$NAME" --exe "$EXE" "${pics[@]}" 2>&1) \
    || fail "Adding to Steam failed: $out"
ok "$NAME is in the Steam library (Steam Input off, controllers from Controller Settings)"

echo
echo "  ${G}${B}Done.${N} Open Steam and press Play on $NAME."
echo "  ${D}If it does not start or crashes: ./fix-game.sh (README: \"When a game needs something extra\").${N}"
echo "  ${D}Its log: ~/.cache/wine-games/$(tr -c 'A-Za-z0-9._\n-' '_' <<<"$(basename "$EXE" .exe)").log${N}"
