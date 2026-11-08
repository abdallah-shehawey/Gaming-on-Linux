#!/usr/bin/env bash
# Step 1: the programs the games need.
#   Steam, Wine (+ winetricks, which fetches Windows runtimes from Microsoft),
#   GameMode, and the GTK parts the Controller Settings app is
#   drawn with; on a computer with an NVIDIA card, its driver if missing.
# Works on Fedora (and Nobara), Debian / Ubuntu / Linux Mint / Pop!_OS, and
# Arch / Manjaro / EndeavourOS / CachyOS. README Step 1 has the same commands
# to type by hand instead.
source "$(dirname "$(readlink -f "$0")")/files/lib.sh"
title "Step 1 of 4" "Installing the programs"
FAMILY=$(distro_family)
ok "$(distro_name)"
[[ $FAMILY == other ]] && fail "This works on Fedora, Debian/Ubuntu/Mint or Arch-based systems.
    On another one, install Steam, Wine, GameMode, GTK 4, libadwaita and SDL3 by hand (README)."

echo
info "Type the password of this computer when asked (nothing shows while"
info "you type, that is normal) and press Enter."
sudo -v || fail "The password was not accepted."
( while sleep 50; do sudo -n true 2>/dev/null || exit; kill -0 $$ 2>/dev/null || exit; done ) &
trap "kill $! 2>/dev/null" EXIT

gpu_vendors() { lspci -nn 2>/dev/null | grep -E 'VGA|3D|Display' | grep -o -E '\[(8086|1002|10de):' | tr -d '[:' | sort -u; }

# ------------------------------------------------------------------ Fedora
install_fedora() {
    part "RPM Fusion (where Fedora gets Steam and the NVIDIA driver)"
    if rpm -q rpmfusion-free-release rpmfusion-nonfree-release >/dev/null 2>&1; then
        ok "already on"
    else
        local v; v=$(rpm -E %fedora)
        sudo dnf install -y \
            "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$v.noarch.rpm" \
            "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$v.noarch.rpm" \
            || fail "Could not add RPM Fusion. Check the internet connection and run this again."
        ok "added"
    fi
    part "Steam, Wine, winetricks, GameMode, GTK"
    local p missing=() PKGS=(steam wine winetricks gamemode gamemode.i686 python3-gobject python3-cairo
                             gtk4 libadwaita SDL3 zstd pciutils xdg-user-dirs)
    for p in "${PKGS[@]}"; do rpm -q "$p" >/dev/null 2>&1 || missing+=("$p"); done
    if ((${#missing[@]})); then
        info "downloading: ${missing[*]}"
        sudo dnf install -y "${missing[@]}" || fail "Installing failed. Check the internet connection and run this again."
    fi
    ok "${PKGS[*]}"
}

nvidia_fedora() {
    if mokutil --sb-state 2>/dev/null | grep -qi enabled; then
        warn "Secure Boot is on, so the driver needs a key. You will make up a one-time"
        info "password now. After the restart a blue screen appears: Enroll MOK > Continue >"
        info "Yes > type that password > Reboot."
        sudo dnf install -y akmods mokutil openssl
        sudo kmodgenca -a
        sudo mokutil --import /etc/pki/akmods/certs/public_key.der
    fi
    sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda || fail "The NVIDIA driver did not install."
    info "building the driver for this kernel (up to 5 minutes, leave it)..."
    sudo akmods --force --kernels "$(uname -r)" >/dev/null 2>&1
}

# ------------------------------------------------------- Debian / Ubuntu / Mint
install_debian() {
    local codename base
    codename=$(. /etc/os-release; echo "${UBUNTU_CODENAME:-${DEBIAN_CODENAME:-$VERSION_CODENAME}}")
    base=$(. /etc/os-release; [[ -n ${UBUNTU_CODENAME:-} || $ID == ubuntu ]] && echo ubuntu || echo debian)
    part "32-bit support (Steam and Wine need it)"
    sudo dpkg --add-architecture i386
    sudo apt-get update || fail "apt could not update. Check the internet connection."
    sudo apt-get install -y wget gpg ca-certificates || fail "Could not install wget/gpg."
    ok "i386 on"

    part "Wine (from WineHQ, a recent one: $base $codename)"
    if command -v wine >/dev/null && wine --version | grep -q -E 'wine-(1[0-9])'; then
        ok "already there: $(wine --version)"
    else
        sudo mkdir -pm755 /etc/apt/keyrings
        wget -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/winehq-archive.key -
        if sudo wget -qNP /etc/apt/sources.list.d/ "https://dl.winehq.org/wine-builds/$base/dists/$codename/winehq-$codename.sources"; then
            sudo apt-get update
            sudo apt-get install -y --install-recommends winehq-staging || fail "Wine did not install."
        else
            warn "WineHQ has no packages for $codename: using the system's Wine (older)"
            sudo apt-get install -y wine wine64 wine32:i386 || sudo apt-get install -y wine || fail "Wine did not install."
        fi
        ok "$(wine --version)"
    fi

    part "Steam (Valve's own installer)"
    if command -v steam >/dev/null; then
        ok "already there"
    else
        local deb; deb=$(mktemp --suffix=.deb)
        wget -qO "$deb" https://cdn.fastly.steamstatic.com/client/installer/steam.deb || fail "Could not download Steam."
        sudo apt-get install -y "$deb" || fail "Steam did not install."
        rm -f "$deb"
        ok "installed"
    fi

    part "GameMode, GTK, Vulkan"
    local PKGS=(winetricks gamemode python3-gi python3-gi-cairo python3-cairo gir1.2-gtk-4.0 gir1.2-adw-1
                zstd pciutils xdg-user-dirs libvulkan1 libvulkan1:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386)
    apt-cache show libsdl3-0 >/dev/null 2>&1 && PKGS+=(libsdl3-0)
    sudo apt-get install -y "${PKGS[@]}" || fail "Installing failed. Check the internet connection and run this again."
    ok "${PKGS[*]}"
    apt-cache show libsdl3-0 >/dev/null 2>&1 || info "no SDL3 package here: the controller tools use the one inside Steam"
}

nvidia_debian() {
    if command -v ubuntu-drivers >/dev/null; then
        sudo ubuntu-drivers install || fail "The NVIDIA driver did not install."
    else
        warn "On Debian, turn on the \"non-free\" sources first, then: sudo apt install nvidia-driver firmware-misc-nonfree"
        info "https://wiki.debian.org/NvidiaGraphicsDrivers"
        return 1
    fi
}

# ------------------------------------------------------------- Arch & family
install_arch() {
    part "multilib (32-bit packages, Steam lives there)"
    if grep -q '^\[multilib\]' /etc/pacman.conf; then
        ok "already on"
    else
        sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
        grep -q '^\[multilib\]' /etc/pacman.conf || fail "Could not turn on multilib in /etc/pacman.conf."
        ok "turned on"
    fi
    part "Vulkan driver for this computer's graphics"
    local v VK=(vulkan-icd-loader lib32-vulkan-icd-loader)
    for v in $(gpu_vendors); do
        case $v in
            8086) VK+=(vulkan-intel lib32-vulkan-intel) ;;
            1002) VK+=(vulkan-radeon lib32-vulkan-radeon) ;;
            10de) VK+=(nvidia-utils lib32-nvidia-utils) ;;
        esac
    done
    ok "${VK[*]}"
    part "Steam, Wine, GameMode, GTK"
    local PKGS=(steam wine winetricks gamemode lib32-gamemode python-gobject python-cairo gtk4 libadwaita sdl3
                zstd pciutils xdg-user-dirs "${VK[@]}")
    sudo pacman -Syu --needed --noconfirm "${PKGS[@]}" || fail "Installing failed. Check the internet connection and run this again."
    ok "${PKGS[*]}"
}

nvidia_arch() {
    if command -v mhwd >/dev/null; then
        sudo mhwd -a pci nonfree 0300 || return 1          # Manjaro's own tool
    else
        local headers=() k
        for k in /usr/lib/modules/*/pkgbase; do headers+=("$(cat "$k")-headers"); done
        sudo pacman -S --needed --noconfirm nvidia-open-dkms nvidia-utils lib32-nvidia-utils "${headers[@]}" || return 1
    fi
}

install_$FAMILY

part "Graphics driver"
if ! nvidia_card; then
    ok "no NVIDIA card: the system's own driver is used (nothing to install)"
elif modinfo -F version nvidia >/dev/null 2>&1; then
    ok "NVIDIA driver $(modinfo -F version nvidia) is already installed"
elif ask "An NVIDIA card is in this computer. Install its driver now (a few minutes)?"; then
    if nvidia_$FAMILY; then
        ok "NVIDIA driver installed: restart the computer after step 2"
    else
        warn "Install the NVIDIA driver by hand (README, Step 1), then restart."
    fi
fi

echo
echo "  ${G}${B}Step 1 done.${N} Next: ${B}./2-performance-fix.sh${N}"
