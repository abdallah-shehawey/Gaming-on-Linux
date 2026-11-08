# How to Play — العاب Windows على Linux من Steam، بالدراعات

<video src="https://github.com/abdallah-shehawey/how-to-play/raw/main/How%20to%20Play%20-%20Setup%20Guide.mp4" controls width="100%"></video>

🎬 **الفيديو (7:46، بالعربي):** لو مش ظاهر فوق، [افتحه من هنا](How%20to%20Play%20-%20Setup%20Guide.mp4).

الفولدر ده بيخليك تلعب أي لعبة Windows على لابتوب عليه Linux: اللعبة بتبقى جوه
الـ Library بتاعة Steam بصورها، بتشتغل بدوسة Play، وكل الدراعات شغالة بنفس
الزراير ونفس ترتيب اللاعيبة في كل الألعاب، ومعاها تحسين الأداء اللي خلّى الألعاب
تبطّل تقطّع.

الفيديو اللي فوق بيشرح نفس الكلام خطوة بخطوة (وهو نفسه ملف `How to Play - Setup Guide.mp4`
اللي جوه الفولدر). الملف ده فيه كل التفاصيل، وهو نفسه `README.pdf` لو عايزه PDF.

> **باختصار:** افتح Terminal جوه الفولدر ده وشغّل بالترتيب:
> `./1-install-programs.sh` ← `./2-performance-fix.sh` (وبعده Restart) ← `./3-setup.sh`
> وبعد كده لكل لعبة: `./4-add-game.sh`

---

## المحتويات

1. [نزّل الفولدر](#نزّل-الفولدر)
2. [محتاج إيه](#محتاج-إيه)
3. [ابدأ على نضافة](#ابدأ-على-نضافة)
4. [إزاي تفتح Terminal في الفولدر](#إزاي-تفتح-terminal-في-الفولدر)
5. [الخطوة 1: البرامج](#الخطوة-1-البرامج)
6. [الخطوة 2: تحسين الأداء](#الخطوة-2-تحسين-الأداء)
7. [الخطوة 3: الإعداد المشترك (مرة واحدة)](#الخطوة-3-الإعداد-المشترك-مرة-واحدة)
8. [الخطوة 4: إضافة لعبة لـ Steam (لكل لعبة)](#الخطوة-4-إضافة-لعبة-لـ-steam-لكل-لعبة)
9. [لو اللعبة محتاجة حاجة زيادة](#لو-اللعبة-محتاجة-حاجة-زيادة)
10. [Controller Settings: الدراعات](#controller-settings-الدراعات)
11. [وانت بتلعب بيحصل إيه لوحده](#وانت-بتلعب-بيحصل-إيه-لوحده)
12. [لو حاجة مش شغالة](#لو-حاجة-مش-شغالة)
13. [كل حاجة جاية منين](#كل-حاجة-جاية-منين)
14. [فين بيتحط إيه](#فين-بيتحط-إيه)
15. [إلغاء كل ده](#إلغاء-كل-ده)

---

## نزّل الفولدر

1. فوق في الصفحة دي: الزرار الأخضر **Code** ← **Download ZIP**.
2. افتح Downloads، كليك يمين على الملف ← **Extract Here**. هيطلع فولدر اسمه
   **how-to-play-main**: ده الفولدر اللي هتشتغل منه.

أو لو عندك git:
```
git clone https://github.com/abdallah-shehawey/how-to-play.git
```

> لو سكربت قالك `Permission denied`: افتح Terminal في الفولدر واكتب `chmod +x *.sh`
> ودوس Enter، وبعدين جرّب تاني.

## محتاج إيه

- لابتوب أو جهاز عليه **Linux**، من النوع ده أو ده أو ده:
  - **نوع RPM:** ‏Fedora (أو Nobara) — ده اللي اتجرب عليه كل حاجة.
  - **نوع Debian:** ‏Ubuntu 24.04 أو أحدث، Linux Mint 22 أو أحدث، Debian 13، Pop!_OS، Zorin.
  - **نوع Arch:** ‏Arch، EndeavourOS، Manjaro، CachyOS.
- **نت**، عشان البرامج بتنزل منه.
- **الألعاب**: فولدر كل لعبة (اللي فيه الـ ‎.exe بتاعها)، أو الـ setup.exe بتاعها.
- **الدراعات**: أي دراع USB أو Bluetooth (بلايستيشن، Xbox، أو الدراعات الصيني بأنواعها).
- مساحة: حوالي 3 جيجا للبرامج، غير مساحة الألعاب نفسها.

## ابدأ على نضافة

لو دي **أول مرة** تعمل الكلام ده على الجهاز، عدّي الجزء ده.

لو كنت جربت قبل كده تشغّل ألعاب Windows بأي طريقة، نضّف الأول عشان مفيش حاجة
قديمة تلخبط الجديدة:

1. **الفولدرات المخفية:** افتح **Files**، ادخل الـ Home، ودوس **Ctrl + H** عشان
   الفولدرات المخفية (اللي اسمها بيبدأ بنقطة) تظهر.
   - لو فيه **‎.wine-games** ← كليك يمين ← **Move to Trash**.
   - لو فيه **‎.wine** ومش مستخدمه لأي برنامج Windows تاني ← برضو Move to Trash.
   - دوس **Ctrl + H** تاني عشان يستخبوا.
2. **Steam:** لو فيه نسخ قديمة من الألعاب اتضافت بإيدك قبل كده: كليك يمين على اللعبة ←
   **Manage** ← **Remove non-Steam game from your library**.
3. **برامج تانية:** لو كنت مسطّب الألعاب في Lutris أو Bottles أو Heroic، امسح
   اللعبة من جوه البرنامج ده الأول.
4. فضّي الـ **Trash** في الآخر لو عايز المساحة.

> السكربت التالت كمان بيسألك لوحده لو لقى ‎.wine-games قديم: «Start clean؟» — قول Y.

## إزاي تفتح Terminal في الفولدر

1. حط الفولدر ده (**how to play**، أو **how-to-play-main** لو نزلته من GitHub) في أي
   حتة على اللابتوب (مثلاً Downloads).
2. ادخل جوه الفولدر في Files.
3. كليك يمين في مكان فاضي ← **Open in Terminal**.
4. اكتب اسم السكربت وقبله ‎`./`‎ ودوس Enter، مثلاً:
   ```
   ./1-install-programs.sh
   ```
5. لما يطلب **password**: اكتب باسورد الجهاز ودوس Enter. **مش هيظهر حاجة وانت بتكتب**،
   ده طبيعي.

> **نصيحة:** مش لازم تكتب اسم السكربت كله. اكتب `./1` ودوس **Tab**، هيكمّله لوحده
> لـ `./1-install-programs.sh`، وبعدين Enter. ونفس الحكاية مع `./2` و `./3` و `./4`.

لو كليك يمين مفيهوش Open in Terminal: افتح Terminal من قايمة البرامج واكتب
`cd ` (بمسافة بعدها)، واسحب الفولدر جوه الـ Terminal، ودوس Enter.

## الخطوة 1: البرامج

```
./1-install-programs.sh
```

بيعرف لوحده انت على أنهي نوع Linux، وبينزّل:

| البرنامج | بيعمل إيه |
|---|---|
| **Steam** | المكان اللي هتفتح منه كل الألعاب |
| **Wine** | بيشغّل برامج وألعاب Windows على Linux |
| **winetricks** | بينزّل حاجات Windows اللي بعض الألعاب بتطلبها (من Microsoft نفسها) |
| **GameMode** | بيسرّع الجهاز وقت اللعب بس (الخطوة 2) |
| **GTK 4 / libadwaita / SDL3** | اللي برنامج Controller Settings مرسوم بيه وبيقرا الدراعات |
| **تعريف NVIDIA** | لو عندك كارت NVIDIA ومفيش تعريف — هيسألك الأول |

### لو عايز تعملها بإيدك

**Fedora (نوع RPM):**
1. افتح **Software** ← القايمة (⋮) ← **Software Repositories** ← شغّل
   **Enable Third-Party Repositories** (أو **RPM Fusion**).
2. دوّر على **Steam** في Software ودوس Install.
3. والباقي في Terminal:
   ```
   sudo dnf install wine winetricks gamemode gamemode.i686 python3-gobject python3-cairo gtk4 libadwaita SDL3 zstd
   ```
   ولو عندك NVIDIA: `sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda` واستنى 5 دقايق قبل الـ Restart.

**Ubuntu / Mint / Debian (نوع Debian):**
```
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install wget gpg
sudo mkdir -pm755 /etc/apt/keyrings
wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -
```
بعدها (غيّر `noble` لاسم نسختك: ‏Ubuntu 24.04 = noble، ‏Mint 22 = noble، ‏Debian 13 = trixie واستخدم `debian` بدل `ubuntu`):
```
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/noble/winehq-noble.sources
sudo apt update
sudo apt install --install-recommends winehq-staging
sudo apt install winetricks gamemode python3-gi python3-gi-cairo gir1.2-gtk-4.0 gir1.2-adw-1 zstd mesa-vulkan-drivers mesa-vulkan-drivers:i386
```
وSteam: نزّل **steam.deb** من [store.steampowered.com/about](https://store.steampowered.com/about/)
ودوس عليه مرتين (أو `sudo apt install ./steam.deb`).
ولو عندك NVIDIA على Ubuntu أو Mint: `sudo ubuntu-drivers install` (أو برنامج **Driver Manager** في Mint).

**Arch / EndeavourOS / Manjaro:**
1. شغّل **multilib**: افتح `/etc/pacman.conf` وشيل علامة `#` من قدام السطرين
   `[multilib]` و `Include = /etc/pacman.d/mirrorlist` اللي تحته.
2. نزّل البرامج:
   ```
   sudo pacman -Syu steam wine winetricks gamemode lib32-gamemode python-gobject python-cairo gtk4 libadwaita sdl3 zstd
   ```
   ولما Steam يسألك على الـ Vulkan driver: اختار `lib32-vulkan-intel` (Intel) أو
   `lib32-vulkan-radeon` (AMD) أو `lib32-nvidia-utils` (NVIDIA).

## الخطوة 2: تحسين الأداء

```
./2-performance-fix.sh
```

وبعدها **اعمل Restart للجهاز مرة واحدة.**

**ليه؟** الألعاب كانت بتقطّع (PES 2021 مثلاً) لأن الـ Linux kernel بيبطّأ أي برنامج
بيعمل حاجة اسمها **split lock**، وألعاب كتير بتعملها طول الوقت. **GameMode** بيقفل
التبطيء ده وقت اللعب بس، ويرجّعه أول ما تقفل اللعبة، وكمان بيخلي البروسيسور على
أعلى سرعة وقت اللعب — **بشرط** إنك تكون في جروب اسمه `gamemode`.

السكربت بيعمل كده بالأمر ده (ممكن تكتبه بإيدك بدل السكربت):
```
sudo usermod -aG gamemode $USER
```
وبيحط ملف صغير `~/.config/gamemode.ini` بيرجّع البروسيسور لسرعته العادية بعد اللعب.

**تتأكد إزاي:** وانت بتلعب، افتح Terminal واكتب:
```
cat /proc/sys/kernel/split_lock_mitigate
```
- **0** = التحسين شغال.
- **1** = لما مفيش لعبة شغالة ده طبيعي. لو طلع 1 **وانت بتلعب**، يبقى لسه مأعملتش Restart.

## الخطوة 3: الإعداد المشترك (مرة واحدة)

```
./3-setup.sh
```

ده بيعمل الحاجات اللي كل الألعاب بتستخدمها، مرة واحدة بس:

- فولدر **Games** في الـ Home (‏`~/Games`): هنا تحط فولدر كل لعبة.
- فولدر **Games/common**: ملفات التشغيل. **متلمسهاش**.
- **Wine واحد لكل الألعاب** (‏`~/.wine-games`)، وجواه **DXVK**: ده بيحوّل الـ DirectX
  بتاع اللعبة لـ Vulkan، وبيفرق جامد في السرعة.
- **الدراعات**: نفس الزراير ونفس ترتيب اللاعيبة لكل الألعاب.
- برنامج **Controller Settings** بيتحط في Steam.

لو دي أول مرة تفتح Steam على الجهاز، السكربت هيفتحهولك: اعمل **Sign in** (أو اعمل
حساب ببلاش)، استنى لحد ما يفتح خالص، واقفله من **Steam ← Exit**. السكربت بيكمّل لوحده.

## الخطوة 4: إضافة لعبة لـ Steam (لكل لعبة)

### 1) حط اللعبة في مكانها

- لو اللعبة **فولدر جاهز** (فيه الـ ‎.exe): انسخ الفولدر كله جوه `~/Games`.
  خليه على هارد اللابتوب نفسه، مش فلاشة أو هارد خارجي.
- لو اللعبة **setup.exe**: شغّل `./fix-game.sh` واختار **6**، وسطّبها عادي.
  هتلاقيها بعدها في `~/.wine-games/drive_c/Program Files (x86)/...`.

### 2) ضيفها بالسكربت

```
./4-add-game.sh
```
- هيقولك: اسحب الـ **‎.exe بتاع اللعبة** جوه الـ Terminal ودوس Enter.
  (افتح فولدر اللعبة في Files واسحب الملف بالماوس على الـ Terminal.)
- اكتب اسمها زي ما عايزه يظهر في Steam (أو Enter ياخد اسم الفولدر).
- **الصور (اختياري):** اسحب كل صورة ودوس Enter، أو Enter على طول عشان تعديها:
  - **cover**: الصورة الطويلة اللي في الـ Library (‏600×900)
  - **hero**: البانر العريض فوق صفحة اللعبة (‏1920×620)
  - **logo**: اسم اللعبة بخلفية شفافة، بيتحط فوق البانر
  - **icon**: الأيقونة المربعة الصغيرة

  **الصور منين؟** من [steamgriddb.com](https://www.steamgriddb.com): دوّر على اسم
  اللعبة، وهتلاقي Grids (الـ cover)، ‏Heroes، ‏Logos، ‏Icons. نزّل اللي يعجبك.

Steam لازم يكون مقفول؛ لو مفتوح السكربت هيسألك يقفله.

**مثال: PES 2021.** فولدرها `~/Games/eFootball-PES-2021`، والـ exe هو `PES2021.exe`،
والاسم «eFootball PES 2021»، والصور من SteamGridDB. واتضاف لها `game-options.sh`
فيه `GAME_60HZ=1` لأنها مقفولة على 60 فريم (تحت في «لو اللعبة محتاجة حاجة زيادة»).

### أو ضيفها بإيدك من جوه Steam

1. **Games** (فوق) ← **Add a Non-Steam Game to My Library** ← **Browse**.
2. روح لـ `Games/common` واختار **steam-launch.sh** ← **Add Selected Programs**.
   (لو مش ظاهر، غيّر نوع الملفات تحت لـ All Files.)
3. كليك يمين على اللعبة الجديدة ← **Properties**:
   - **الاسم**: اكتب اسم اللعبة بدل steam-launch.sh.
   - **Launch Options**: اكتب مكان play.sh، وبعده مكان الـ exe، كل واحد بين علامتين " ":
     ```
     "/home/اسمك/Games/common/play.sh" "/home/اسمك/Games/اللعبة/Game.exe"
     ```
   - **الأيقونة**: دوس على المربع الفاضي جنب الاسم واختار صورة.
   - **In-Game**: اقفل **Enable the Steam Overlay while in-game**.
4. نفس الـ Properties ← **Controller** ← **Disable Steam Input**.
   (مهم: الدراعات بتتظبط من Controller Settings، وSteam Input بيلخبطها.)
5. **الصور**: كليك يمين على اللعبة ← **Manage** ← **Set custom artwork** (الـ cover).
   وفي صفحة اللعبة: كليك يمين على البانر ← **Set Custom Background** (الـ hero)،
   وكليك يمين تاني ← **Set Custom Logo**.

## لو اللعبة محتاجة حاجة زيادة

أغلب الألعاب مش محتاجة حاجة. لو لعبة **مش بتفتح**، أو **بتقفل لوحدها**، أو بتقول
**‎.dll is missing**، شغّل:
```
./fix-game.sh
```
واختار اللي يناسب. كل حاجة بتتسطب مرة واحدة وبتخدم كل الألعاب بعد كده:

| اللعبة بتعمل إيه | الرقم | اللي بيتسطب | جاي منين |
|---|---|---|---|
| بتقفل على طول، أو MSVCP140 / VCRUNTIME140 missing | 1 | Visual C++ 2015-2022 | Microsoft (winetricks) |
| لعبة قديمة: MSVCR100 / MSVCR120 / MSVCP90 missing | 2 | Visual C++ 2008/2010/2013 | Microsoft (winetricks) |
| d3dx9_43 / d3dcompiler_47 missing | 3 | DirectX extras | Microsoft (winetricks) |
| لعبة قديمة فيها فيزيا، بتطلب PhysX | 4 | NVIDIA PhysX | NVIDIA (winetricks) |
| لانشر بيطلب .NET Framework | 5 | .NET 4.8 | Microsoft (winetricks) |
| اللعبة setup.exe | 6 | بيشغّل الـ installer جوه Wine بتاع الألعاب | — |
| بتقع جوه DLL من Wine نفسه | 7 | يخلي اللعبة دي بس تستخدم نسخة Microsoft | — |
| عايز تجرب الدراعات جوه Wine | 8 | شاشة Game Controllers بتاعة Windows | — |

### إعدادات للعبة واحدة بس: game-options.sh

لو لعبة محتاجة إعداد خاص بيها هي بس: انسخ `~/Games/common/game-options-example.sh`
جنب الـ ‎.exe بتاع اللعبة، وسمّيه **game-options.sh**، وشيل علامة `#` من قدام السطر اللي
محتاجه:

| السطر | بيعمل إيه |
|---|---|
| `GAME_60HZ=1` | الشاشة تبقى 60 هيرتز وقت اللعبة دي — للألعاب المقفولة على 60 فريم (زي PES)، عشان الحركة متقطعش على شاشة 144 أو 165 |
| `export DXVK_HUD=fps` | عداد الفريمات في الركن |
| `export WINEDLLOVERRIDES="d3d9=n,b"` | لو اللعبة جايبة DLL معاها في فولدرها ولازم تستخدمه |
| `GAME_ARGS="-windowed"` | كلام زيادة اللعبة محتاجاه وهي بتفتح |

### حاجات تانية بتحصل

- **الـ Settings / Launcher بتاع اللعبة مش بيفتح أو فاضي** (زي Settings.exe بتاع PES):
  ظبط الشاشة والجرافيكس من **جوه اللعبة نفسها**.
- **اللعبة عندها launcher بيفتح اللعبة الحقيقية ويقفل:** عادي، ‎play.sh بيستنى اللعبة
  الحقيقية.
- **اللعبة بتظهر أزرار Xbox:** طبيعي. ‏A = إكس ✕، ‏B = دايرة ○، ‏X = مربع □، ‏Y = مثلث △.
- **لعبة Online / Anti-cheat:** ألعاب كتير عليها anti-cheat مش بتشتغل على Linux خالص.

## Controller Settings: الدراعات

افتحه من Steam زي أي لعبة. **الإعداد هنا بيتسمع في كل الألعاب** اللي بتشتغل بالطريقة
دي، فبتظبطه مرة واحدة.

- **فوق — PLAYERS:** اللاعيبة بالترتيب. **اسحب** أي دراع مكان التاني عشان تغيّر مين
  Player 1 ومين Player 2 (أو Alt + السهم). **Default Order** = ترتيب التركيب.
- **في النص:** صورة الدراع. **على الجنبين:** كل زرار وخانته.
- **تغيّر زرار:** دوس على خانته، وبعدين دوس الزرار اللي عايزه على الدراع.
  الرموز زي البلايستيشن: △ ○ ✕ □.
- **Revert** تحت الصورة: يرجّع زراير الدراع ده للأصل.
- **Apply** يحفظ، **OK** يحفظ ويقفل.

كل نوع دراع ليه ماب خاص بيه، والماب بيفضل محفوظ لو شلت الدراع وركبته، أو غيّرت
البورت، أو عملت Restart. وفيه ماب جاهز لدراعات **Twin USB** (أداپتر دراعين PS2 الصيني).

## وانت بتلعب بيحصل إيه لوحده

- الجهاز بيدخل وضع **Performance**.
- **GameMode** شغال: البروسيسور على أعلى سرعة، والـ split lock مقفول.
- في بروسيسورات Intel الجيل 12 وأحدث: اللعبة بتشتغل على **الأنوية السريعة** بس.
- لو عندك كارت **NVIDIA**: اللعبة بتشتغل عليه.
- لو اللعبة فيها `GAME_60HZ=1`: الشاشة بتتحول **60 هيرتز**.
- لما تقفل اللعبة، **كل حاجة بترجع زي ما كانت**.

## لو حاجة مش شغالة

1. شغّل:
   ```
   ./check.sh
   ```
   بيقولك إيه جاهز (✓) وإيه ناقص (✗). ابعت صورة منه للي بعتلك الفولدر ده.
2. **الـ log بتاع كل لعبة:** `~/.cache/wine-games/<اسم الـ exe>.log` (فولدر مخفي:
   Ctrl + H في Files).
3. **دراع مش ظاهر:** شيله وركّبه، وافتح Controller Settings. لو لسه، جرّب بورت تاني.
4. **أي تعديل في ملفات Steam بالسكربتات لازم وSteam مقفول** (Steam ← Exit، مش X بس).
5. **اللعبة بطيئة:** اتأكد إن الخطوة 2 شغالة (`check.sh`)، وإنك عملت Restart، وإن
   اللابتوب على الشاحن.
6. **اللعبة بتقفل على طول:** `./fix-game.sh` ← 1 (Visual C++)، وبعدين 3 (DirectX).

## كل حاجة جاية منين

| الحاجة | منين | ببلاش؟ |
|---|---|---|
| Steam | Fedora: ‏RPM Fusion · ‏Debian/Ubuntu: ‏steam.deb من Valve · ‏Arch: ‏multilib | آه |
| Wine | Fedora/Arch: من النظام · ‏Debian/Ubuntu: ‏WineHQ (‏dl.winehq.org) | آه |
| DXVK (جوه `files/dxvk`) | من **Proton Experimental** اللي جوه Steam (‏Library ← Tools)، رخصة zlib | آه |
| Visual C++، ‏DirectX، ‏.NET، ‏PhysX | **winetricks** بينزّلهم من Microsoft و NVIDIA | آه |
| تعريف NVIDIA | RPM Fusion / Ubuntu drivers / Arch | آه |
| صور الألعاب | [steamgriddb.com](https://www.steamgriddb.com) | آه |
| Controller Settings والسكربتات | معمولين مخصوص (جوه `files`) | — |

## فين بيتحط إيه

| المكان | فيه إيه |
|---|---|
| `~/Games/` | فولدرات الألعاب |
| `~/Games/common/` | ملفات التشغيل (‏play.sh، ‏steam-launch.sh، ‏Controller Settings) |
| `~/.wine-games/` | Wine بتاع كل الألعاب (Windows الصغير بتاعها) |
| `~/.config/game-pads/` | ماب الدراعات وترتيب اللاعيبة |
| `~/.config/environment.d/60-game-pads.conf` | بيخلي كل برنامج (وSteam نفسه) يشوف نفس الماب |
| `~/.config/gamemode.ini` | إعداد GameMode |
| `~/.cache/wine-games/` | الـ logs |

**الفولدر ده (how to play / how-to-play-main):**

| الملف | بيعمل إيه |
|---|---|
| `1-install-programs.sh` | الخطوة 1: البرامج |
| `2-performance-fix.sh` | الخطوة 2: تحسين الأداء |
| `3-setup.sh` | الخطوة 3: الإعداد المشترك |
| `4-add-game.sh` | الخطوة 4: إضافة لعبة (لكل لعبة) |
| `fix-game.sh` | لو لعبة محتاجة حاجة زيادة |
| `check.sh` | يوريك إيه جاهز وإيه ناقص |
| `uninstall.sh` | يشيل الخطوات 3 و 4 |
| `files/` | اللي السكربتات بتحطه (متغيرش فيه حاجة) |
| `How to Play - Setup Guide.mp4` | الفيديو |
| `README.md` / `README.pdf` | الشرح ده |

## إلغاء كل ده

```
./uninstall.sh
```
بيشيل الألعاب اللي اتضافت من Steam، وبيرمي `~/.wine-games` في الـ Trash. فولدرات
الألعاب، والسيفات، والبرامج، وتحسين الأداء بيفضلوا زي ما هما.
