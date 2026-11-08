#!/usr/bin/env bash
# When a game needs something extra. Most games need nothing; when one does
# not start, crashes, or says a .dll is missing, this adds the missing piece to
# the Wine setup all the games share (so it serves every game after that).
# The Windows parts come through winetricks, straight from Microsoft / NVIDIA.
#
#   ./fix-game.sh            a menu
#   ./fix-game.sh vcrun2022  one winetricks item directly
source "$(dirname "$(readlink -f "$0")")/files/lib.sh"
title "Game fixes" "extra pieces for games that need them"
[[ -f $PREFIX/system.reg ]] || fail "Run ./3-setup.sh first."
export WINEPREFIX="$PREFIX"

tricks() {
    command -v winetricks >/dev/null || fail "winetricks is missing: run ./1-install-programs.sh again."
    info "downloading and installing: $* (a few minutes, windows may pop up)"
    WINEDEBUG=-all winetricks -q "$@" || fail "winetricks could not install $*. Check the internet connection."
    wineserver -w
    ok "installed: $*"
}

if [[ -n ${1:-} ]]; then tricks "$@"; exit; fi

cat <<EOF

  What does the game do?
   ${B}1${N}  Closes at once, or says MSVCP140.dll / VCRUNTIME140.dll is missing
      → Microsoft Visual C++ 2015-2022 runtime (vcrun2022)
   ${B}2${N}  An older game says MSVCR100 / MSVCR120 / MSVCP90 ... is missing
      → older Visual C++ runtimes (vcrun2008, vcrun2010, vcrun2013)
   ${B}3${N}  Says d3dx9_43.dll / d3dcompiler_47.dll / XINPUT ... is missing
      → DirectX extras (d3dx9, d3dcompiler_47, d3dx11_43)
   ${B}4${N}  An older game with physics (it asks for PhysX or PhysXLoader.dll)
      → NVIDIA PhysX (physx)
   ${B}5${N}  A launcher that needs .NET (says .NET Framework is missing)
      → Microsoft .NET Framework 4.8 (dotnet48, about 15 minutes)
   ${B}6${N}  The game came as an installer (setup.exe): install it into the games' Wine
   ${B}7${N}  It crashes in Wine's own copy of a DLL: use Microsoft's copy for this game only
   ${B}8${N}  Test the controllers inside Wine (the Windows game controllers window)
   ${B}9${N}  Wine's settings window (winecfg)
   ${B}0${N}  Nothing, quit
EOF
read -r -p "  Number: " n
case $n in
    1) tricks vcrun2022 ;;
    2) tricks vcrun2008 vcrun2010 vcrun2013 ;;
    3) tricks d3dx9 d3dcompiler_47 d3dx11_43 ;;
    4) tricks physx ;;
    5) tricks dotnet48 ;;
    6)
        info "Drag the setup.exe into this window and press Enter."
        read -r -p "  setup.exe: " s; s=${s%% }; s=${s#\'}; s=${s%\'}
        [[ -f $s ]] || fail "Not a file: $s"
        info "The installer opens now. When it asks where to install, you can keep its"
        info "folder: the game then ends up in ~/.wine-games/drive_c/Program Files (x86)/..."
        info "Afterwards add the game's .exe with ./4-add-game.sh"
        (cd "$(dirname "$s")" && WINEDEBUG=-all wine "$(basename "$s")")
        wineserver -w
        ok "installer closed" ;;
    7)
        read -r -p "  The game's .exe file name (e.g. Game.exe): " exe
        read -r -p "  The DLL name without .dll (e.g. msvcr90): " dll
        [[ -n $exe && -n $dll ]] || fail "Both are needed."
        WINEDEBUG=-all wine reg add "HKCU\\Software\\Wine\\AppDefaults\\$exe\\DllOverrides" /v "$dll" /d native,builtin /f >/dev/null 2>&1
        wineserver -w
        ok "$exe now uses Microsoft's $dll.dll (install it first with 1 or 2 if needed)" ;;
    8) (source "$HOME/Games/common/pads.sh"; WINEDEBUG=-all wine control joy.cpl) ;;
    9) WINEDEBUG=-all winecfg ;;
    *) exit 0 ;;
esac
