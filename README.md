# Gaming on Linux

**Play any Windows game on Linux, from your Steam library, with all your controllers.**

https://github.com/user-attachments/assets/43185ac5-bc72-4a81-85fd-e9485138b108

🎬 **Setup video (7:46, in Egyptian Arabic)** — it plays right here. For full quality: [watch it in HD](https://abdallah-shehawey.github.io/Gaming-on-Linux/) or [download it](https://github.com/abdallah-shehawey/Gaming-on-Linux/raw/main/How%20to%20Play%20-%20Setup%20Guide.mp4).
· بالعربي: [README-ar.md](README-ar.md) · [PDF](README-ar.pdf)

This folder lets you play any Windows game on a Linux laptop: the game sits in your Steam
**Library** with its artwork and starts with **Play**, every controller works with the same
buttons and the same player order in every game, and it comes with the performance fix that
stopped games from stuttering.

The video walks through all of this step by step (it is also the file
`How to Play - Setup Guide.mp4` in this folder). This page has every detail.

> **Short version:** open a Terminal in this folder and run, in order:
> `./1-install-programs.sh` → `./2-performance-fix.sh` (then restart) → `./3-setup.sh`
> Then, for each game: `./4-add-game.sh`

---

## Contents

1. [Download](#download)
2. [What you need](#what-you-need)
3. [Start clean](#start-clean)
4. [Open a Terminal in the folder](#open-a-terminal-in-the-folder)
5. [Step 1: Programs](#step-1-programs)
6. [Step 2: Performance fix](#step-2-performance-fix)
7. [Step 3: Shared setup (once)](#step-3-shared-setup-once)
8. [Step 4: Add a game to Steam (per game)](#step-4-add-a-game-to-steam-per-game)
9. [If a game needs something extra](#if-a-game-needs-something-extra)
10. [Controller Settings](#controller-settings)
11. [What happens on its own while you play](#what-happens-on-its-own-while-you-play)
12. [If something doesn't work](#if-something-doesnt-work)
13. [Where everything comes from](#where-everything-comes-from)
14. [Where things go](#where-things-go)
15. [Remove it all](#remove-it-all)

---

## Download

1. At the top of this page: the green **Code** button → **Download ZIP**.
2. Open Downloads, right-click the file → **Extract Here**. You get a folder called
   **Gaming-on-Linux-main**: that is the folder you work from.

Or, if you have git:
```
git clone https://github.com/abdallah-shehawey/Gaming-on-Linux.git
```

> If a script says `Permission denied`: open a Terminal in the folder, type `chmod +x *.sh`,
> press Enter, and try again.

## What you need

- A laptop or PC running **Linux**, any of these families:
  - **RPM-based:** Fedora (or Nobara). Everything here was tested on Fedora.
  - **Debian-based:** Ubuntu 24.04 or newer, Linux Mint 22 or newer, Debian 13, Pop!_OS, Zorin.
  - **Arch-based:** Arch, EndeavourOS, Manjaro, CachyOS.
- **Internet**, since the programs are downloaded.
- **The games:** each game's folder (the one with its `.exe`), or its `setup.exe`.
- **Controllers:** any USB or Bluetooth pad (PlayStation, Xbox, or the generic Chinese ones).
- Disk space: about 3 GB for the programs, plus the games themselves.

## Start clean

If this is the **first time** you do this on the computer, skip this part.

If you have tried running Windows games before in any way, clean up first so nothing old gets
in the way of the new setup:

1. **Hidden folders:** open **Files**, go to Home, and press **Ctrl + H** to show hidden
   folders (names starting with a dot).
   - If there is a **.wine-games** folder → right-click → **Move to Trash**.
   - If there is a **.wine** folder and you don't use it for any other Windows program → Move to Trash too.
   - Press **Ctrl + H** again to hide them.
2. **Steam:** if you added old copies of the games by hand before: right-click the game →
   **Manage** → **Remove non-Steam game from your library**.
3. **Other launchers:** if the games are installed in Lutris, Bottles or Heroic, remove them
   from inside that program first.
4. Empty the **Trash** at the end if you want the space back.

> The third script also asks on its own if it finds an old `.wine-games`: "Start clean?" — answer Y.

## Open a Terminal in the folder

1. Put this folder (**Gaming-on-Linux-main** if you downloaded it from GitHub) anywhere on
   the laptop, for example in Downloads.
2. Open the folder in Files.
3. Right-click an empty spot → **Open in Terminal**.
4. Type the script name with `./` in front and press Enter, for example:
   ```
   ./1-install-programs.sh
   ```
5. When it asks for a **password**: type the computer's password and press Enter.
   **Nothing shows while you type** — that is normal.

> **Tip:** you don't have to type the whole name. Type `./1` and press **Tab**, and it
> completes to `./1-install-programs.sh` by itself; then press Enter. Same with `./2`, `./3` and `./4`.

If the right-click menu has no Open in Terminal: open Terminal from the app menu, type `cd `
(with a space after it), drag the folder into the Terminal window, and press Enter.

## Step 1: Programs

```
./1-install-programs.sh
```

It detects which Linux family you are on and installs:

| Program | What it does |
|---|---|
| **Steam** | Where you start every game from |
| **Wine** | Runs Windows programs and games on Linux |
| **winetricks** | Downloads the Windows parts some games ask for (from Microsoft itself) |
| **GameMode** | Speeds the computer up only while you play (step 2) |
| **GTK 4 / libadwaita / SDL3** | What the Controller Settings app is drawn with and reads the pads through |
| **NVIDIA driver** | If you have an NVIDIA card and no driver yet — it asks first |

### Doing it by hand

**Fedora (RPM-based):**
1. Open **Software** → the menu (⋮) → **Software Repositories** → turn on
   **Enable Third-Party Repositories** (or **RPM Fusion**).
2. Search for **Steam** in Software and click Install.
3. The rest in a Terminal:
   ```
   sudo dnf install wine winetricks gamemode gamemode.i686 python3-gobject python3-cairo gtk4 libadwaita SDL3 zstd
   ```
   With NVIDIA: `sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda`, then wait 5 minutes before restarting.

**Ubuntu / Mint / Debian (Debian-based):**
```
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install wget gpg
sudo mkdir -pm755 /etc/apt/keyrings
wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -
```
Then (change `noble` to your release's name: Ubuntu 24.04 = noble, Mint 22 = noble,
Debian 13 = trixie, and use `debian` instead of `ubuntu`):
```
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/noble/winehq-noble.sources
sudo apt update
sudo apt install --install-recommends winehq-staging
sudo apt install winetricks gamemode python3-gi python3-gi-cairo gir1.2-gtk-4.0 gir1.2-adw-1 zstd mesa-vulkan-drivers mesa-vulkan-drivers:i386
```
For Steam: download **steam.deb** from [store.steampowered.com/about](https://store.steampowered.com/about/)
and double-click it (or `sudo apt install ./steam.deb`).
With NVIDIA on Ubuntu or Mint: `sudo ubuntu-drivers install` (or the **Driver Manager** app on Mint).

**Arch / EndeavourOS / Manjaro:**
1. Turn on **multilib**: open `/etc/pacman.conf` and remove the `#` in front of the two lines
   `[multilib]` and the `Include = /etc/pacman.d/mirrorlist` under it.
2. Install the programs:
   ```
   sudo pacman -Syu steam wine winetricks gamemode lib32-gamemode python-gobject python-cairo gtk4 libadwaita sdl3 zstd
   ```
   When Steam asks for a Vulkan driver, pick `lib32-vulkan-intel` (Intel),
   `lib32-vulkan-radeon` (AMD) or `lib32-nvidia-utils` (NVIDIA).

## Step 2: Performance fix

```
./2-performance-fix.sh
```

Then **restart the computer once.**

**Why?** Games were stuttering (PES 2021, for example) because the Linux kernel slows down any
program that does something called a **split lock**, and many games do it all the time.
**GameMode** turns that slowdown off only while you play and brings it back as soon as the game
closes, and it also runs the CPU at full speed while you play — **as long as** you are in a
group called `gamemode`.

The script does that with this command (you can type it yourself instead):
```
sudo usermod -aG gamemode $USER
```
It also adds a small `~/.config/gamemode.ini` that puts the CPU back to its normal speed after playing.

**How to check:** while a game is running, open a Terminal and type:
```
cat /proc/sys/kernel/split_lock_mitigate
```
- **0** = the fix is working.
- **1** = normal when no game is running. If it says 1 **while you play**, you haven't restarted yet.

## Step 3: Shared setup (once)

```
./3-setup.sh
```

This sets up the things every game uses, just once:

- A **Games** folder in your Home (`~/Games`): put each game's folder here.
- A **Games/common** folder: the launch files. **Don't touch it.**
- **One Wine for all games** (`~/.wine-games`), with **DXVK** inside: it turns the game's
  DirectX into Vulkan, which makes a big difference in speed.
- **Controllers:** the same buttons and the same player order for every game.
- The **Controller Settings** app is added to Steam.

If this is the first time Steam opens on this computer, the script opens it for you:
**Sign in** (or make a free account), wait until it has fully opened, then close it from
**Steam → Exit**. The script carries on by itself.

## Step 4: Add a game to Steam (per game)

### 1) Put the game in place

- If the game is a **ready folder** (it has the `.exe`): copy the whole folder into `~/Games`.
  Keep it on the laptop's own drive, not a USB stick or external drive.
- If the game is a **setup.exe**: run `./fix-game.sh`, choose **6**, and install it as usual.
  You will find it afterwards in `~/.wine-games/drive_c/Program Files (x86)/...`.

### 2) Add it with the script

```
./4-add-game.sh
```
- It asks you to drag the **game's `.exe`** into the Terminal and press Enter.
  (Open the game's folder in Files and drag the file onto the Terminal with the mouse.)
- Type its name the way you want it to show in Steam (or press Enter to use the folder's name).
- **Pictures (optional):** drag each picture in and press Enter, or just press Enter to skip it:
  - **cover**: the tall picture in the Library (600×900)
  - **hero**: the wide banner at the top of the game's page (1920×620)
  - **logo**: the game's name on a transparent background, placed over the banner
  - **icon**: the small square icon

  **Where do the pictures come from?** [steamgriddb.com](https://www.steamgriddb.com): search for
  the game's name and you will find Grids (the cover), Heroes, Logos and Icons. Download the ones you like.

Steam has to be closed; if it is open, the script asks to close it.

**Example: PES 2021.** Its folder is `~/Games/eFootball-PES-2021`, the exe is `PES2021.exe`,
the name is "eFootball PES 2021", and the pictures came from SteamGridDB. It also got a
`game-options.sh` with `GAME_60HZ=1`, because the game is locked to 60 fps (see
[If a game needs something extra](#if-a-game-needs-something-extra)).

### Or add it by hand inside Steam

1. **Games** (top menu) → **Add a Non-Steam Game to My Library** → **Browse**.
2. Go to `Games/common`, pick **steam-launch.sh** → **Add Selected Programs**.
   (If it doesn't show, set the file type at the bottom to All Files.)
3. Right-click the new game → **Properties**:
   - **Name**: type the game's name instead of steam-launch.sh.
   - **Launch Options**: the path of play.sh, then the path of the exe, each in quotes:
     ```
     "/home/YOUR-NAME/Games/common/play.sh" "/home/YOUR-NAME/Games/THE-GAME/Game.exe"
     ```
   - **Icon**: click the empty square next to the name and choose a picture.
   - **In-Game**: turn off **Enable the Steam Overlay while in-game**.
4. Same Properties → **Controller** → **Disable Steam Input**.
   (Important: the pads are set up in Controller Settings, and Steam Input mixes them up.)
5. **Pictures:** right-click the game → **Manage** → **Set custom artwork** (the cover).
   On the game's page: right-click the banner → **Set Custom Background** (the hero),
   and right-click again → **Set Custom Logo**.

## If a game needs something extra

Most games don't need anything. If a game **won't start**, **closes by itself**, or says
**.dll is missing**, run:
```
./fix-game.sh
```
and pick what fits. Each item is installed once and then serves every game:

| What the game does | Number | What gets installed | From |
|---|---|---|---|
| Closes right away, or MSVCP140 / VCRUNTIME140 missing | 1 | Visual C++ 2015-2022 | Microsoft (winetricks) |
| Older game: MSVCR100 / MSVCR120 / MSVCP90 missing | 2 | Visual C++ 2008/2010/2013 | Microsoft (winetricks) |
| d3dx9_43 / d3dcompiler_47 missing | 3 | DirectX extras | Microsoft (winetricks) |
| Older game with physics that asks for PhysX | 4 | NVIDIA PhysX | NVIDIA (winetricks) |
| A launcher that asks for .NET Framework | 5 | .NET 4.8 | Microsoft (winetricks) |
| The game is a setup.exe | 6 | Runs the installer inside the games' Wine | — |
| Crashes inside one of Wine's own DLLs | 7 | Makes just that game use Microsoft's copy | — |
| You want to test the pads inside Wine | 8 | Windows' Game Controllers window | — |

### Settings for one game only: game-options.sh

If a game needs a setting of its own: copy `~/Games/common/game-options-example.sh` next to
the game's `.exe`, name it **game-options.sh**, and remove the `#` in front of the line you need:

| Line | What it does |
|---|---|
| `GAME_60HZ=1` | Switches the screen to 60 Hz while this game runs — for games locked to 60 fps (like PES), so motion doesn't stutter on a 144 or 165 Hz screen |
| `export DXVK_HUD=fps` | An FPS counter in the corner |
| `export WINEDLLOVERRIDES="d3d9=n,b"` | If the game ships its own DLL in its folder and has to use it |
| `GAME_ARGS="-windowed"` | Extra arguments the game needs when it starts |

### Other things that happen

- **The game's Settings / Launcher won't open or is empty** (like PES's Settings.exe):
  set the screen and graphics from **inside the game itself**.
- **The game has a launcher that starts the real game and closes:** that's fine, play.sh waits
  for the real game.
- **The game shows Xbox buttons:** normal. A = cross ✕, B = circle ○, X = square □, Y = triangle △.
- **Online / anti-cheat games:** many games with anti-cheat don't run on Linux at all.

## Controller Settings

Open it from Steam like any game. **What you set here applies to every game** that runs this
way, so you set it up once.

- **Top — PLAYERS:** the players in order. **Drag** any pad onto another's place to change who
  is Player 1 and who is Player 2 (or Alt + arrow keys). **Default Order** = the order they were plugged in.
- **Middle:** a picture of the pad. **Both sides:** every button and its box.
- **Change a button:** click its box, then press the button you want on the pad.
  The symbols are PlayStation's: △ ○ ✕ □.
- **Revert** under the picture: puts this pad's buttons back to the default.
- **Apply** saves, **OK** saves and closes.

Each pad model has its own map, and the map stays saved if you unplug the pad and plug it back,
change the port, or restart. There is a ready map for **Twin USB** pads (the cheap two-player
PS2 pad adapter).

## What happens on its own while you play

- The computer switches to the **Performance** power mode.
- **GameMode** is on: the CPU runs at full speed and split lock slowdown is off.
- On Intel 12th gen and newer: the game runs on the **fast cores** only.
- If you have an **NVIDIA** card: the game runs on it.
- If the game has `GAME_60HZ=1`: the screen switches to **60 Hz**.
- When you close the game, **everything goes back to how it was**.

## If something doesn't work

1. Run:
   ```
   ./check.sh
   ```
   It shows what is ready (✓) and what is missing (✗). Send a screenshot of it to whoever sent you this.
2. **Each game's log:** `~/.cache/wine-games/<exe name>.log` (hidden folder: Ctrl + H in Files).
3. **A pad doesn't show up:** unplug it, plug it back in, and open Controller Settings.
   If it still doesn't, try another port.
4. **Any script that edits Steam's files needs Steam closed** (Steam → Exit, not just the X).
5. **The game is slow:** make sure step 2 is working (`check.sh`), that you restarted, and that
   the laptop is plugged in.
6. **The game closes right away:** `./fix-game.sh` → 1 (Visual C++), then 3 (DirectX).

## Where everything comes from

| Thing | From | Free? |
|---|---|---|
| Steam | Fedora: RPM Fusion · Debian/Ubuntu: steam.deb from Valve · Arch: multilib | Yes |
| Wine | Fedora/Arch: the system's own · Debian/Ubuntu: WineHQ (dl.winehq.org) | Yes |
| DXVK (in `files/dxvk`) | From **Proton Experimental** inside Steam (Library → Tools), zlib licence | Yes |
| Visual C++, DirectX, .NET, PhysX | **winetricks** downloads them from Microsoft and NVIDIA | Yes |
| NVIDIA driver | RPM Fusion / Ubuntu drivers / Arch | Yes |
| Game pictures | [steamgriddb.com](https://www.steamgriddb.com) | Yes |
| Controller Settings and the scripts | Made for this (in `files`) | — |

## Where things go

| Place | What's in it |
|---|---|
| `~/Games/` | The game folders |
| `~/Games/common/` | The launch files (play.sh, steam-launch.sh, Controller Settings) |
| `~/.wine-games/` | The Wine all the games share (their little Windows) |
| `~/.config/game-pads/` | Pad maps and player order |
| `~/.config/environment.d/60-game-pads.conf` | Makes every program (Steam included) see the same maps |
| `~/.config/gamemode.ini` | GameMode settings |
| `~/.cache/wine-games/` | The logs |

**This folder:**

| File | What it does |
|---|---|
| `1-install-programs.sh` | Step 1: programs |
| `2-performance-fix.sh` | Step 2: performance fix |
| `3-setup.sh` | Step 3: shared setup |
| `4-add-game.sh` | Step 4: add a game (per game) |
| `fix-game.sh` | When a game needs something extra |
| `check.sh` | Shows what is ready and what is missing |
| `uninstall.sh` | Undoes steps 3 and 4 |
| `files/` | What the scripts put in place (don't change anything in it) |
| `How to Play - Setup Guide.mp4` | The video |
| `README.md` | This guide |
| `README-ar.md` / `README-ar.pdf` | The same guide in Arabic |

## Remove it all

```
./uninstall.sh
```
It removes the games it added from Steam and moves `~/.wine-games` to the Trash. The game
folders, your saves, the programs, and the performance fix stay as they are.
