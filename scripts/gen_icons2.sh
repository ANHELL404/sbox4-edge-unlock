#!/bin/bash
set -e
OUT="${OUT:-/root/newicons2}"
rm -rf $OUT; mkdir -p $OUT
mk(){ printf '%s' "$4" > /tmp/i.svg; rsvg-convert -w "$2" -h "$3" /tmp/i.svg -o /tmp/i.png; convert /tmp/i.png -background none "$OUT/$1"; }
# 16x16 line glyph helper: $1=name $2=color $3=inner paths
g16(){ mk "$1" 16 16 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="none" stroke="'$2'" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">'"$3"'</svg>'; }
# 46x46 network-object glyph (plain accent, no circle)
g46(){ mk "$1" 46 46 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 46 46" fill="none" stroke="'$2'" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round">'"$3"'</svg>'; }

AC='#be185d'; G='#16a34a'; R='#dc2626'; A='#f59e0b'; BL='#2563eb'; PU='#7c3aed'; GR='#64748b'

# ---- 16x16 UI controls ----
g16 edit.gif    "$AC" '<path d="M11 2.5l2.5 2.5-7.5 7.5-3 .5.5-3z"/><path d="M10 3.5l2.5 2.5"/>'
g16 del.gif     "$R"  '<path d="M3.5 4.5h9M6 4.5v-1.5h4v1.5M5 4.5l.7 8.5h4.6l.7-8.5"/>'
g16 add.gif     "$G"  '<circle cx="8" cy="8" r="6"/><path d="M8 5v6M5 8h6"/>'
g16 info.gif    "$BL" '<circle cx="8" cy="8" r="6"/><path d="M8 7.5v3.5"/><circle cx="8" cy="5.2" r=".6" fill="'$BL'" stroke="none"/>'
g16 refresh.gif "$AC" '<path d="M12.5 6a5 5 0 1 0 .4 3"/><path d="M12.5 2.5v3.5h-3.5"/>'
g16 up.gif      "$GR" '<path d="M4 10l4-4 4 4"/>'
g16 down.gif    "$GR" '<path d="M4 6l4 4 4-4"/>'
g16 dl.gif      "$GR" '<path d="M8 3v7M5 7.5l3 3 3-3M4 13h8"/>'
g16 comp.gif    "$GR" '<rect x="2.5" y="3" width="11" height="7.5" rx="1"/><path d="M6 13h4M8 10.5V13"/>'
g16 dice.gif    "$AC" '<rect x="3" y="3" width="10" height="10" rx="2"/><circle cx="6" cy="6" r=".8" fill="'$AC'" stroke="none"/><circle cx="10" cy="10" r=".8" fill="'$AC'" stroke="none"/><circle cx="8" cy="8" r=".8" fill="'$AC'" stroke="none"/>'
g16 noentry.gif "$R"  '<circle cx="8" cy="8" r="6"/><path d="M4 8h8"/>'
g16 errorsm.gif "$R"  '<circle cx="8" cy="8" r="6"/><path d="M8 4.5v4.5"/><circle cx="8" cy="11.3" r=".7" fill="'$R'" stroke="none"/>'
g16 warningsm.gif "$A" '<path d="M8 2.5l6 11H2z"/><path d="M8 6.5v3.2"/><circle cx="8" cy="11.4" r=".7" fill="'$A'" stroke="none"/>'
g16 disgreysm.gif "#9aa3b2" '<circle cx="8" cy="8" r="6"/><path d="M5.5 5.5l5 5"/>'
g16 dissm.gif   "#9aa3b2" '<circle cx="8" cy="8" r="6"/><path d="M5.5 8h5"/>'
mk x_.gif 16 16 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><circle cx="8" cy="8" r="7" fill="#dc2626"/><path d="M5.4 5.4l5.2 5.2M10.6 5.4l-5.2 5.2" stroke="#fff" stroke-width="1.8" stroke-linecap="round"/></svg>'

# ---- log_* 16x16 (reason icons) ----
g16 log_accept.gif    "$G"  '<path d="M3 8.5l3 3 7-7.5"/>'
g16 log_block.gif     "$R"  '<path d="M8 2.5l5.5 2v4c0 3.5-2.3 5-5.5 6.5C4.8 13.5 2.5 12 2.5 8.5v-4z"/><path d="M5.5 5.5l5 5"/>'
g16 log_reject.gif    "$R"  '<circle cx="8" cy="8" r="6"/><path d="M5.7 5.7l4.6 4.6M10.3 5.7l-4.6 4.6"/>'
g16 log_encrypt.gif   "$AC" '<rect x="4" y="7.5" width="8" height="6" rx="1"/><path d="M5.5 7.5V6a2.5 2.5 0 0 1 5 0v1.5"/>'
g16 log_decrypt.gif   "$AC" '<rect x="4" y="7.5" width="8" height="6" rx="1"/><path d="M5.5 7.5V6a2.5 2.5 0 0 1 4.8-1"/>'
g16 log_inbound.gif   "$BL" '<path d="M12 8H4M7 5l-3 3 3 3"/>'
g16 log_outbound.gif  "$BL" '<path d="M4 8h8M9 5l3 3-3 3"/>'
g16 log_internal.gif  "$GR" '<path d="M5 6a4 4 0 1 1-1 3"/><path d="M5 3v3h3"/>'
g16 log_monitor.gif   "$GR" '<path d="M2.5 8S4.5 4 8 4s5.5 4 5.5 4-2 4-5.5 4S2.5 8 2.5 8z"/><circle cx="8" cy="8" r="1.6"/>'
g16 log_mailallow.gif "$G"  '<rect x="2.5" y="4" width="11" height="8" rx="1"/><path d="M2.5 4.5L8 8.5l5.5-4"/>'
g16 log_mailvirus.gif "$R"  '<rect x="2.5" y="4" width="11" height="8" rx="1"/><path d="M2.5 4.5L8 8.5l5.5-4"/>'
g16 log_spam.gif      "$R"  '<rect x="2.5" y="4" width="11" height="8" rx="1"/><path d="M2.5 4.5L8 8.5l5.5-4M5 11l6-6"/>'
g16 log_stamp.gif     "$GR" '<circle cx="8" cy="8" r="6"/><path d="M8 5v3.2l2 1.3"/>'
g16 log_url.gif       "$BL" '<circle cx="8" cy="8" r="6"/><path d="M2.5 8h11M8 2.5c2.3 2.3 2.3 11 0 11M8 2.5c-2.3 2.3-2.3 11 0 11"/>'
g16 log_urlallow.gif  "$G"  '<circle cx="8" cy="8" r="6"/><path d="M2.5 8h11M8 2.5c2.3 2.3 2.3 11 0 11M8 2.5c-2.3 2.3-2.3 11 0 11"/>'
g16 log_vstream.gif   "$PU" '<circle cx="8" cy="8" r="6"/><path d="M6.5 5.5l4 2.5-4 2.5z" fill="'$PU'" stroke="none"/>'

# ---- vpnt_* 16x16 (tunnel types) ----
g16 vpnt_box.gif    "$AC" '<rect x="3" y="4" width="10" height="8" rx="1"/><circle cx="5.5" cy="6.5" r=".7" fill="'$AC'" stroke="none"/>'
g16 vpnt_net.gif    "$AC" '<circle cx="8" cy="8" r="6"/><path d="M2.5 8h11M8 2.5c2.3 2.3 2.3 11 0 11M8 2.5c-2.3 2.3-2.3 11 0 11"/>'
g16 vpnt_office.gif "$AC" '<rect x="4" y="3" width="8" height="10"/><path d="M6 5.5h1M9 5.5h1M6 8h1M9 8h1M7 13v-2.5h2V13"/>'
g16 vpnt_site.gif   "$AC" '<path d="M8 13.5S3.5 10 3.5 6.5a4.5 4.5 0 0 1 9 0C12.5 10 8 13.5 8 13.5z"/><circle cx="8" cy="6.5" r="1.4"/>'
g16 vpnt_user.gif   "$AC" '<circle cx="8" cy="6" r="2.4"/><path d="M3.5 13a4.5 4.5 0 0 1 9 0"/>'
g16 vpnt_l2tp.gif   "$AC" '<path d="M2.5 5.5h7a3 3 0 0 1 0 6H6"/><path d="M8 9l-2 2.5 2 2.5" transform="translate(-1.5 -2.5)"/>'
g16 vpnt_ipcomp.gif "$AC" '<path d="M4 3v10M12 3v10M4 6h4M12 6H8M4 10h4M12 10H8"/>'

# ---- 46x46 network objects (plain accent line) ----
g46 PC.gif      "$AC" '<rect x="8" y="10" width="30" height="20" rx="2"/><path d="M17 36h12M23 30v6"/>'
cp $OUT/PC.gif $OUT/PCb.gif; cp $OUT/PC.gif $OUT/PCw.gif; cp $OUT/PC.gif $OUT/PCwb.gif
g46 Router.gif  "$AC" '<rect x="7" y="22" width="32" height="14" rx="2"/><circle cx="13" cy="29" r="1.6" fill="'$AC'" stroke="none"/><path d="M23 22V12M23 12l-4 4M23 12l4 4M31 22v-6"/>'
cp $OUT/Router.gif $OUT/Routerb.gif; cp $OUT/Router.gif $OUT/Routerw.gif; cp $OUT/Router.gif $OUT/Routerwb.gif
g46 Network.gif "$AC" '<circle cx="23" cy="23" r="15"/><path d="M8 23h30M23 8c6 5 6 25 0 30M23 8c-6 5-6 25 0 30"/>'
cp $OUT/Network.gif $OUT/Networkw.gif
g46 Bridge.gif  "$AC" '<path d="M6 30v-4a17 8 0 0 1 34 0v4"/><path d="M6 30h34M14 30v-6M23 30v-8M32 30v-6"/>'
g46 Vlan.gif    "$AC" '<path d="M8 12h16l14 11-14 11H8z"/><circle cx="16" cy="23" r="2.2"/>'
g46 HA.gif      "$AC" '<rect x="7" y="9" width="24" height="16" rx="2"/><rect x="15" y="21" width="24" height="16" rx="2"/>'
g46 printer.gif "$AC" '<rect x="12" y="8" width="22" height="12"/><rect x="7" y="20" width="32" height="12" rx="2"/><rect x="14" y="28" width="18" height="10"/><circle cx="33" cy="25" r="1.4" fill="'$AC'" stroke="none"/>'
g46 usbmodem.gif "$AC" '<rect x="18" y="6" width="10" height="28" rx="3"/><path d="M23 34v6M19 40h8"/><circle cx="23" cy="13" r="2"/>'
g46 services.gif "$AC" '<circle cx="23" cy="23" r="6"/><path d="M23 9v5M23 32v5M9 23h5M32 23h5M13 13l3.5 3.5M29.5 29.5L33 33M33 13l-3.5 3.5M16.5 29.5L13 33"/>'
g46 scales.gif  "$AC" '<path d="M10 14h26M14 14v22M32 14v22"/><circle cx="23" cy="10" r="2.5"/><path d="M14 14l-5 10h10zM32 14l-5 10h10z"/><path d="M9 36h10M27 36h10"/>'
g46 sbox.gif    "$AC" '<path d="M23 7l13 5v9c0 9-6 13.5-13 16.5C16 34.5 10 30 10 21v-9z"/><path d="M17 22l4.5 4.5L30 17"/>'
cp $OUT/sbox.gif $OUT/sboxw.gif; cp $OUT/sbox.gif $OUT/sofacirc.gif; cp $OUT/sbox.gif $OUT/cpsmall.gif

# ---- signal bars 25x20 (0..5) ----
for n in 0 1 2 3 4 5; do
  bars=""
  for i in 0 1 2 3 4; do
    x=$((2 + i*5)); h=$((4 + i*3)); y=$((18 - h))
    if [ $i -lt $n ]; then col="#16a34a"; else col="#cfd6e4"; fi
    bars="$bars<rect x=\"$x\" y=\"$y\" width=\"3.4\" height=\"$h\" rx=\"1\" fill=\"$col\"/>"
  done
  mk signal$n.gif 25 20 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 20">'"$bars"'</svg>'
done

# ---- tiny: sort + collapse/expand ----
mk sort_asc.gif  9 8 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 9 8"><path d="M4.5 1.5l3 5h-6z" fill="#64748b"/></svg>'
mk sort_desc.gif 9 8 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 9 8"><path d="M4.5 6.5l3-5h-6z" fill="#64748b"/></svg>'
mk collapse.gif 12 12 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 12 12"><rect x="1" y="1" width="10" height="10" rx="2" fill="#fff" stroke="#b9c0cc" stroke-width="1"/><path d="M3.5 6h5" stroke="#be185d" stroke-width="1.3" stroke-linecap="round"/></svg>'
mk expand.gif   12 12 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 12 12"><rect x="1" y="1" width="10" height="10" rx="2" fill="#fff" stroke="#b9c0cc" stroke-width="1"/><path d="M3.5 6h5M6 3.5v5" stroke="#be185d" stroke-width="1.3" stroke-linecap="round"/></svg>'

echo "generated $(ls $OUT | wc -l) extra icons"; ls $OUT | tr '\n' ' '; echo
