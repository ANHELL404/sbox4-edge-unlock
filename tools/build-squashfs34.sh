#!/bin/bash
# ============================================================================
#  Build mksquashfs 3.4 from source.
#
#  The device kernel (2.6.27) uses the squashfs 3.x on-disk format, so the
#  rootfs MUST be packed with a 3.x mksquashfs — a 4.x image will not boot.
#  Modern distros only ship squashfs-tools 4.x, hence this helper.
#
#  Target: Debian/Ubuntu (incl. WSL). Prints the binary path + the exact
#  `export MKSQUASHFS=...` line to feed into scripts/build.sh.
#
#  Usage:  ./tools/build-squashfs34.sh [workdir]
# ============================================================================
set -e

VER=3.4
WORK="${1:-$PWD/squashfs${VER}-build}"
URL="https://downloads.sourceforge.net/project/squashfs/squashfs/squashfs${VER}/squashfs${VER}.tar.gz"
TARBALL="squashfs${VER}.tar.gz"

mkdir -p "$WORK"; cd "$WORK"

# build deps (best-effort; needs root/sudo)
if command -v apt-get >/dev/null 2>&1; then
  if [ "$(id -u)" = 0 ]; then SUDO=; else SUDO="sudo"; fi
  $SUDO apt-get update -qq || true
  $SUDO apt-get install -y -qq build-essential zlib1g-dev wget ca-certificates >/dev/null 2>&1 || true
fi

fetch(){ if command -v wget >/dev/null 2>&1; then wget -q -O "$1" "$2"; else curl -fSL -o "$1" "$2"; fi; }
if [ ! -f "$TARBALL" ]; then
  echo ">> downloading $URL"
  fetch "$TARBALL" "$URL"
fi
echo ">> sha256: $(sha256sum "$TARBALL" | cut -d' ' -f1)"

rm -rf "squashfs${VER}"
tar xzf "$TARBALL"
cd "squashfs${VER}/squashfs-tools"

# Flags fix the build on modern gcc:
#   -fcommon            : tentative-definition clashes (gcc 10+)
#   -fgnu89-inline      : old inline semantics (add_dir_entry etc.)
#   -include sysmacros  : major()/minor() moved to <sys/sysmacros.h>
#   -I.                 : local squashfs_fs.h
make EXTRA_CFLAGS="-fcommon -fgnu89-inline -include sys/sysmacros.h -I." mksquashfs

BIN="$PWD/mksquashfs"
[ -x "$BIN" ] || { echo "!! build failed: $BIN not found"; exit 1; }
echo
echo ">> built: $BIN"
"$BIN" -version 2>/dev/null | head -1 || true
echo
echo ">> now run the patch build with:"
echo "     export MKSQUASHFS=\"$BIN\""
echo "     ./scripts/build.sh /path/to/dump_dir"
