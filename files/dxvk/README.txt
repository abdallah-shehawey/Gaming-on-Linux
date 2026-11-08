DXVK v3.1.1 (as shipped in Steam's Proton Experimental, 27 Oct 2026)
https://github.com/doitsujin/dxvk  -  zlib/libpng licence, free to share.

It turns the games' DirectX 9/10/11 into Vulkan, which runs much faster
than Wine's own DirectX. 3-setup.sh copies these files into the games' Wine
setup (~/.wine-games) on every Linux, so all games get the same DXVK.
x64 = 64-bit games (most of them), x32 = 32-bit games (older ones).
