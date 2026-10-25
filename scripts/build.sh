#!/bin/bash
# ============================================================================
#  SBOX4 / Check Point UTM-1 Edge (W) — firmware patch-kit builder
#  Verified on firmware 8.2.55n (SofaWare SBOX4, Octeon CN5010).
#
#  This script does NOT contain any Check Point / SofaWare code. It operates
#  on dumps that YOU read from YOUR OWN device. See README.md / DISCLAIMER.md.
#
#  Usage:
#     ./build.sh /path/to/dump_dir
#  where dump_dir contains:
#     mtd4.bin   - the firmware partition dump (the whole /dev/mtd4)
#     mtd5.bin   - the squashfs rootfs dump   (the whole /dev/mtd5)
#  Output:  dump_dir/mtd4.patched.bin  (flash this to /dev/mtd4)
#
#  Customize branding (optional, env vars):
#     BRAND="UNLOCKED by YOU"  TG_LINK="https://t.me/you"  TG_LABEL="t.me/you"
#     MODEL="UTM-1 Edge W"     HELP_URL="https://..."
#  Toolchain overrides (optional):
#     MKSQUASHFS=/path/to/mksquashfs-3.x   OBJDUMP=mips-linux-gnu-objdump
# ============================================================================
set -e

D="${1:?usage: build.sh <dump_dir containing mtd4.bin and mtd5.bin>}"
D="$(cd "$D" && pwd)"
[ -f "$D/mtd4.bin" ] || { echo "missing $D/mtd4.bin"; exit 1; }
[ -f "$D/mtd5.bin" ] || { echo "missing $D/mtd5.bin"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
STYLES="${STYLES:-$REPO_DIR/theme/styles_hybrid.css}"

MK="${MKSQUASHFS:-mksquashfs}"          # MUST be squashfs-tools 3.x (see README)
OD="${OBJDUMP:-mips-linux-gnu-objdump}"

export BRAND="${BRAND:-UNLOCKED by ANHELL}"
export TG_LINK="${TG_LINK:-https://t.me/ANHELL_ofcl}"
export TG_LABEL="${TG_LABEL:-t.me/ANHELL_ofcl}"
export MODEL="${MODEL:-UTM-1 Edge W}"
export HELP_URL="${HELP_URL:-https://www.youtube.com/watch?v=dQw4w9WgXcQ}"

for t in "$OD" python3 unsquashfs rsvg-convert convert; do
  command -v "$t" >/dev/null 2>&1 || { echo "missing tool: $t (see README.md)"; exit 1; }
done
command -v "$MK" >/dev/null 2>&1 || { echo "missing mksquashfs (set MKSQUASHFS=, must be 3.x)"; exit 1; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
ROOT="$WORK/rootfs"
echo ">> workdir: $WORK"

echo "=== 1. extract clean rootfs from mtd5 ==="
mkdir -p "$ROOT"
unsquashfs -f -d "$ROOT" "$D/mtd5.bin" >"$WORK/unsquash.log" 2>&1
cp "$ROOT/sofaware/SafeAtHome" "$WORK/SafeAtHome.clean"   # for CRC table (pre-patch)

echo "=== 2. patch SafeAtHome (license unlock) ==="
python3 - "$ROOT" <<'PY'
import struct,hashlib,sys
f=sys.argv[1]+"/sofaware/SafeAtHome"; d=bytearray(open(f,"rb").read()); JR=0x03e00008
# file offset = vaddr - 0x10000000. Each entry: jr ra ; li v0,<value>
patches={
  0x1b1dd8:(JR,0x24023fff),  # mv_get_vendor_mask        -> 0x3fff (all features: VPN server, W, ...)
  0x0bf41c:(JR,0x24020000),  # sw_is_evaluation_license_expired -> 0 (never expired)
  0x1789a8:(JR,0x24020064),  # sw_var_get_nodes_quota    -> 100 nodes
}
for o,(a,b) in patches.items():
    d[o:o+4]=struct.pack(">I",a); d[o+4:o+8]=struct.pack(">I",b)
open(f,"wb").write(d); print("  patched SafeAtHome md5:",hashlib.md5(bytes(d)).hexdigest())
PY

echo "=== 3. GUI edits (branding / menu / theme hooks) ==="
python3 - "$ROOT" <<'PY'
import re,os,sys
R=sys.argv[1]+"/etc/gui/"
def rd(p): return open(R+p,encoding="latin-1").read()
def wr(p,s): open(R+p,"w",encoding="latin-1").write(s)
B=os.environ["BRAND"]; TGL=os.environ["TG_LINK"]; TGT=os.environ["TG_LABEL"]
MODEL=os.environ["MODEL"]; HELP=os.environ["HELP_URL"]
NEW_TEXT='HOME_TEXT_TEXT=<p style="font-size:18px"><b>'+B+'</b></p><p><<GEN_GWNAME>> - '+MODEL+', unlocked for personal use.</p>'
NEW_LINKS='HOME_LINKS="</p><center><table border=0><tr class=TabRow0><td><a href=\''+TGL+'\' target=\'_blank\'><b>'+TGT+'</b></a></td></tr></table></center>"'
TRADEMARK='TRADEMARK=<p class=TradeMark>'+B+' &#183; '+MODEL+' &#183; <a class=Link href="'+TGL+'" target="_blank">'+TGT+'</a></p>'
SHIELD='<svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle"><path d="M12 2.5l7.5 3v6c0 5-3.2 7.6-7.5 9.5-4.3-1.9-7.5-4.5-7.5-9.5v-6z"/><path d="M8.7 12l2.2 2.2 4.5-4.6"/></svg>'
FLOGO='HOME_LOGO=<svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#be185d" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:middle"><path d="M12 2.5l7.5 3v6c0 5-3.2 7.6-7.5 9.5-4.3-1.9-7.5-4.5-7.5-9.5v-6z"/><path d="M8.7 12l2.2 2.2 4.5-4.6"/></svg>'
# home text / links / header+footer logo in vendor properties
for fn in ["edge.properties","ven32.properties"]:
    lines=rd(fn).split("\n"); out=[]; i=0
    while i<len(lines):
        ln=lines[i]
        if ln.startswith("HOME_TEXT_TEXT="): out.append(NEW_TEXT); i+=1; continue
        if ln.startswith('HOME_LINKS="'):
            j=i
            while j<len(lines) and not lines[j].rstrip().endswith('"'): j+=1
            out.append(NEW_LINKS); i=j+1; continue
        if ln.startswith("MENU_LOGO_LEFT="): out.append("MENU_LOGO_LEFT="+SHIELD); out.append("MENU_LOGO_NEWRIGHT="); i+=1; continue
        if ln.startswith("HOME_LOGO="): out.append(FLOGO); i+=1; continue
        out.append(ln); i+=1
    if not any(l.startswith("HOME_LOGO=") for l in out): out.append(FLOGO)
    wr(fn,"\n".join(out))
s=rd("sw1.properties")
s=re.sub(r"^TRADEMARK=.*$", lambda m: TRADEMARK, s, count=1, flags=re.M)
s=re.sub(r"^GEN_HELP_URL=.*$", lambda m: "GEN_HELP_URL="+HELP, s, flags=re.M)
if re.search(r"^HOME_LOGO=.*$", s, flags=re.M): s=re.sub(r"^HOME_LOGO=.*$", lambda m: FLOGO, s, flags=re.M)
else: s=s.rstrip("\n")+"\n"+FLOGO+"\n"
wr("sw1.properties",s)
sp=rd("spc.properties"); sp=re.sub(r"^HOME_LOGO=.*$", lambda m: FLOGO, sp, flags=re.M); wr("spc.properties",sp)
b=rd("base.properties"); b=re.sub(r"^GEN_HELP_URL=.*$", lambda m: "GEN_HELP_URL="+HELP, b, flags=re.M); wr("base.properties",b)
# menu.html: inline SVG icons per menu item + hide dead subscription items
m=rd("menu.html")
inject='''var _mIco={
 'Welcome':'<svg viewBox="0 0 24 24"><path d="M3 12l9-8 9 8"/><path d="M5 10v10h14V10"/></svg>',
 'Reports':'<svg viewBox="0 0 24 24"><path d="M5 20V10M12 20V4M19 20v-7"/></svg>',
 'Logs':'<svg viewBox="0 0 24 24"><path d="M4 6h16M4 12h16M4 18h10"/></svg>',
 'Security':'<svg viewBox="0 0 24 24"><path d="M12 3l7 3v6c0 5-3 7-7 9-4-2-7-4-7-9V6z"/></svg>',
 'Network':'<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c3 3 3 15 0 18M12 3c-3 3-3 15 0 18"/></svg>',
 'VPN':'<svg viewBox="0 0 24 24"><rect x="5" y="11" width="14" height="9" rx="2"/><path d="M8 11V8a4 4 0 0 1 8 0v3"/></svg>',
 'Setup':'<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M12 3v3M12 18v3M3 12h3M18 12h3M5.6 5.6l2.1 2.1M16.3 16.3l2.1 2.1M18.4 5.6l-2.1 2.1M7.7 16.3l-2.1 2.1"/></svg>',
 'Users':'<svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="3.4"/><path d="M4.5 20a7.5 7.5 0 0 1 15 0"/></svg>',
 'Help':'<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M9.5 9a2.5 2.5 0 0 1 4.5 1.5c0 1.5-2 2-2 3.5M12 17h.01"/></svg>',
 'Logout':'<svg viewBox="0 0 24 24"><path d="M15 12H4M10 7l-5 5 5 5M14 4h5v16h-5"/></svg>'};
function menuIcon(n){return _mIco[n]||'<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/></svg>';}
function _hid(pn){var n=pn.split('_').join(' ').toLowerCase();return n.indexOf('antivirus')>=0||n.indexOf('anti-virus')>=0||n.indexOf('antispam')>=0||n.indexOf('anti-spam')>=0||n=='services';}
'''
m=m.replace("function createMButton(pName, pFile) {", inject+"function createMButton(pName, pFile) {",1)
m=m.replace("""';">' + pName.split('_').join(' ') + '</a></td>';""","""';">' + menuIcon(pName) + '<span>' + pName.split('_').join(' ') + '</span></a></td>';""",1)
m=m.replace("if ( menuItems[i][0] > 0) {","if ( menuItems[i][0] > 0 && !_hid(menuItems[i][1])) {",1)
wr("menu.html",m)
# submenu.html: mark the tab cap gifs so CSS can hide them (flat tabs)
sm=rd("submenu.html"); assert '<img border=0 name="pic' in sm
wr("submenu.html", sm.replace('<img border=0 name="pic','<img class=scap border=0 name="pic'))
# StatBar.html: replace dead "Service Center: Not Subscribed" with brand text
sb=rd("StatBar.html"); assert "<<STATBAR_MCONN>>" in sb and "<<m_mconn>>" in sb
sb=sb.replace("<td nowrap><<STATBAR_MCONN>>&nbsp;</td>", '<td nowrap><b style="color:#ec2c84">'+B+'</b>&nbsp;</td>')
sb=sb.replace("<td valign=top nowrap><<m_mconn>></td>", "")
wr("StatBar.html",sb)
# Trafficb.html: contain the wide traffic graph so the page doesn't scroll
tb=rd("Trafficb.html"); assert '<<m_trafficGraph ind="<<TTRAFIC_INDEX>>">>' in tb
tb=tb.replace('<td align=center><<m_trafficGraph ind="<<TTRAFIC_INDEX>>">></td>',
              '<td align=center><div style="max-width:100%;overflow-x:auto;overflow-y:hidden;"><<m_trafficGraph ind="<<TTRAFIC_INDEX>>">></div></td>')
wr("Trafficb.html",tb)
# pub/swapi.js: flatten image-sprite buttons into plain styled <input>
j=rd("pub/swapi.js")
j=j.replace('''onmouseout="setStatus();return true;" href="'+funcfixed+'" ' + targetstr +'><img align=top style="margin-right:'+picmarge+'px;" border=0 src="'+picfixed+'">'+cap+'</a>';''',
            '''onmouseout="setStatus();return true;" href="'+funcfixed+'" ' + targetstr +'>'+cap+'</a>';''',1)
j=j.replace('''var styleText = 'background-image:URL(' + picfixed +');';
		return '<span style="'+styleText+'" class=ButtonLink><input id="' + name + '" class='+ (isDisabled==1 ? "ButtonLinkDis" : "ButtonLinkOff") + ' type=' + ((sub==1) ? 'submit' : ('button onclick="' + func + '"')) + (isDisabled==1?' disabled' : '') + ' value="'+cap+'" onmouseover="this.className=\\'ButtonLinkOn\\';" onmouseout="this.className=\\'ButtonLinkOff\\';"></span>';''',
            '''return '<input id="' + name + '" class='+ (isDisabled==1 ? "ButtonLinkDis" : "ButtonLinkOff") + ' type=' + ((sub==1) ? 'submit' : ('button onclick="' + func + '"')) + (isDisabled==1?' disabled' : '') + ' value="'+cap+'" onmouseover="this.className=\\'ButtonLinkOn\\';" onmouseout="this.className=\\'ButtonLinkOff\\';">';''',1)
j=j.replace('''return '<table border=0 cellpadding=0 cellspacing=0><tr><td valign=top><img border=0 src="/<<GEN_S_GRAPHICS>>/button_left.gif"></td><td valign=top ' +
			   'class=Button><input id="' + name + '" ' + wstfixed + ' class=ButtonOff type=' + ((sub==1) ? 'submit' : 'button onclick="' + func + '"') + (isDisabled==1?' disabled' : '') + ' value="' + cap + '" onmouseover="this.className=\\'ButtonOn\\';" onmouseout="this.className=\\'ButtonOff\\';">' +
			   '</td><td valign=top><img border=0 src="/<<GEN_S_GRAPHICS>>/button_right.gif"></td></tr></table>';''',
            '''return '<input id="' + name + '" ' + wstfixed + ' class=ButtonOff type=' + ((sub==1) ? 'submit' : 'button onclick="' + func + '"') + (isDisabled==1?' disabled' : '') + ' value="' + cap + '" onmouseover="this.className=\\'ButtonOn\\';" onmouseout="this.className=\\'ButtonOff\\';">';''',1)
wr("pub/swapi.js",j)
print("  GUI edits done")
PY

echo "=== 4. hybrid theme CSS ==="
for g in img img2 img10 img11 img32; do [ -d "$ROOT/etc/gui/$g" ] && cp "$STYLES" "$ROOT/etc/gui/$g/styles.css"; done

echo "=== 5. flat icon set (stock port connectors kept) ==="
OUT="$WORK/icons"  bash "$SCRIPT_DIR/gen_icons.sh"
OUT="$WORK/icons2" bash "$SCRIPT_DIR/gen_icons2.sh"
N=0
for f in "$WORK"/icons/*.gif;  do bn=$(basename "$f"); case "$bn" in port*) continue;; esac; cp "$f" "$ROOT/etc/gui/img/$bn"; N=$((N+1)); done
for f in "$WORK"/icons2/*.gif; do cp "$f" "$ROOT/etc/gui/img/$(basename "$f")"; N=$((N+1)); done
echo "  replaced $N icons (port* left stock)"

echo "=== 6. repack squashfs + splice into image + recompute CRC ==="
"$MK" "$ROOT" "$WORK/new.sqfs" -b 131072 -noappend 2>&1 | tail -1
"$OD" -s --start-address=0x1024a950 --stop-address=0x1024ad50 "$WORK/SafeAtHome.clean" 2>/dev/null | grep '^ 1024' > "$WORK/tab.txt"
python3 - "$D" "$WORK" <<'PY'
import struct,hashlib,sys
D,WORK=sys.argv[1],sys.argv[2]
tab=[]
for line in open(WORK+"/tab.txt"):
    for w in line.split()[1:5]:
        if len(w)==8: tab.append(int(w,16)&0xffffffff)
tab=tab[:256]
assert len(tab)==256, "CRC table extraction failed (objdump output?)"
def crc(b):
    c=0
    for by in b: c=(tab[((c>>8)^by)&0xff]^((c<<8)&0xffffffff))&0xffffffff
    return c
img=bytearray(open(D+"/mtd4.bin","rb").read()); sq=open(WORK+"/new.sqfs","rb").read()
OFF=0x30fe91                                   # squashfs offset inside the firmware image (8.2.55n)
isz=struct.unpack(">I",img[0x14:0x18])[0]; END=4+isz+164; LEN=END-OFF
print("  new squashfs=%d bytes, region=0x%x"%(len(sq),LEN))
assert len(sq)<=LEN, "patched rootfs too big for the firmware region"
img[OFF:OFF+LEN]=sq+b"\xff"*(LEN-len(sq))
img[0:4]=struct.pack(">I", crc(img[4:END]))    # table-driven CRC-CCITT, stored big-endian at off 0
open(D+"/mtd4.patched.bin","wb").write(img)
print("  wrote mtd4.patched.bin  md5=%s"%hashlib.md5(bytes(img)).hexdigest())
PY
ls -l "$D/mtd4.patched.bin"
echo ">> done. Flash $D/mtd4.patched.bin to /dev/mtd4 (see README)."
