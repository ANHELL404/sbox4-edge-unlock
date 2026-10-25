#!/bin/bash
set -e
OUT="${OUT:-/root/newicons}"
rm -rf $OUT; mkdir -p $OUT
mk(){ printf '%s' "$4" > /tmp/i.svg; rsvg-convert -w "$2" -h "$3" /tmp/i.svg -o /tmp/i.png; convert /tmp/i.png -background none "$OUT/$1"; }

G=#16a34a; R=#dc2626; A=#f59e0b; AC=#be185d; GR=#9aa3b2; DK=#475467

# ---- table icons 16x16 ----
CHECK='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><circle cx="8" cy="8" r="7" fill="#16a34a"/><path d="M4.6 8.3l2.2 2.2 4.6-4.8" fill="none" stroke="#fff" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg>'
CROSS='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><circle cx="8" cy="8" r="7" fill="#dc2626"/><path d="M5.4 5.4l5.2 5.2M10.6 5.4l-5.2 5.2" stroke="#fff" stroke-width="1.8" stroke-linecap="round"/></svg>'
WARN='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path d="M8 1.8l6.6 11.7H1.4z" fill="#f59e0b"/><path d="M8 6v3.3M8 11.4h.01" stroke="#fff" stroke-width="1.6" stroke-linecap="round" fill="none"/></svg>'
HELP='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><circle cx="8" cy="8" r="7" fill="#c6ccd8"/><path d="M6.1 6.2a1.9 1.9 0 0 1 3.5 1c0 1.2-1.6 1.4-1.6 2.5" fill="none" stroke="#fff" stroke-width="1.5" stroke-linecap="round"/><circle cx="8" cy="12" r=".9" fill="#fff"/></svg>'
for f in v.gif v_.gif oksm.gif; do mk $f 16 16 "$CHECK"; done
for f in x.gif xd.gif; do mk $f 16 16 "$CROSS"; done
for f in am.gif untrustedsm.gif; do mk $f 16 16 "$WARN"; done
mk help.gif 16 16 "$HELP"
mk lock.gif 13 15 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 13 15"><rect x="2" y="6.3" width="9" height="7.2" rx="1.4" fill="#be185d"/><path d="M4 6.3V4.5a2.5 2.5 0 0 1 5 0v1.8" fill="none" stroke="#be185d" stroke-width="1.5"/></svg>'
mk vantispam.gif 18 18 "$WARN"

# ---- port connectors (green=link / gray=no link) ----
rj45(){ echo '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><rect x="4" y="6" width="12" height="9" rx="1.4" fill="'$1'"/><rect x="7" y="3.5" width="6" height="3" rx="1" fill="'$1'"/><path d="M6.5 15v1.6M10 15v1.6M13.5 15v1.6" stroke="'$1'" stroke-width="1.3" stroke-linecap="round"/></svg>'; }
wifi(){ echo '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path d="M3.5 8a10 10 0 0 1 13 0M6 11a6 6 0 0 1 8 0M8.3 14a2.6 2.6 0 0 1 3.4 0" fill="none" stroke="'$1'" stroke-width="1.6" stroke-linecap="round"/><circle cx="10" cy="16.2" r="1.1" fill="'$1'"/></svg>'; }
usb(){ echo '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path d="M10 3.5v12.5" stroke="'$1'" stroke-width="1.6"/><path d="M10 3.5l-2 2.6h4z" fill="'$1'"/><circle cx="10" cy="16.5" r="1.6" fill="'$1'"/><path d="M10 9l3-1.6v2.2M10 11l-3-1.6v2.2" fill="none" stroke="'$1'" stroke-width="1.4" stroke-linecap="round"/></svg>'; }
mk port_g.gif 20 20 "$(rj45 '#16a34a')"; mk port_n.gif 20 20 "$(rj45 '#9aa3b2')"
mk portf_g.gif 20 20 "$(rj45 '#16a34a')"; mk portf_n.gif 20 20 "$(rj45 '#9aa3b2')"
mk portadsl_g.gif 20 20 "$(rj45 '#16a34a')"; mk portadsl_n.gif 20 20 "$(rj45 '#9aa3b2')"
mk portw_g.gif 20 20 "$(wifi '#16a34a')"; mk portw_n.gif 20 20 "$(wifi '#9aa3b2')"
mk portusb_g.gif 20 20 "$(usb '#16a34a')"; mk portusb_n.gif 20 20 "$(usb '#9aa3b2')"
# small status bars 34x11
mk portcf_g.gif 34 11 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 34 11"><rect x="1" y="2" width="32" height="7" rx="3" fill="#16a34a"/></svg>'
mk portcf_n.gif 34 11 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 34 11"><rect x="1" y="2" width="32" height="7" rx="3" fill="#cfd6e4"/></svg>'
cp $OUT/portcf_g.gif $OUT/portex_g.gif; cp $OUT/portcf_n.gif $OUT/portex_n.gif
# big connector tiles
mk port.gif 40 40 "$(rj45 '#475467')"
mk portUSB.gif 40 20 "$(usb '#475467')"
mk port2USB.gif 40 40 "$(usb '#475467')"
mk portRS.gif 39 80 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 39 80"><rect x="8" y="26" width="23" height="28" rx="3" fill="#475467"/><g fill="#fff"><circle cx="15" cy="34" r="1.5"/><circle cx="24" cy="34" r="1.5"/><circle cx="19" cy="40" r="1.5"/><circle cx="15" cy="46" r="1.5"/><circle cx="24" cy="46" r="1.5"/></g></svg>'
mk portCF.gif 20 80 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 80"><rect x="4" y="28" width="12" height="24" rx="2" fill="#475467"/></svg>'
mk portEX.gif 20 80 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 80"><rect x="4" y="28" width="12" height="24" rx="2" fill="#475467"/></svg>'
mk port_g.gif 20 20 "$(rj45 '#16a34a')"

# ---- tree icons 19x16 (gray connectors) ----
LN='stroke="#b9c0cc" stroke-width="1.3"'
mk tr_line.gif 19 16 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 19 16"><path d="M9.5 0v16" '"$LN"'/></svg>'
mk tr_join.gif 19 16 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 19 16"><path d="M9.5 0v8h9" '"$LN"' fill="none"/></svg>'
mk tr_joinb.gif 19 16 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 19 16"><path d="M9.5 0v16M9.5 8h9" '"$LN"' fill="none"/></svg>'
mk tr_base.gif 19 16 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 19 16"><path d="M9.5 0v8h9" '"$LN"' fill="none"/></svg>'
mk tr_empty.gif 19 16 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 19 16"></svg>'
BOX='<rect x="3" y="3" width="13" height="10" rx="2" fill="#fff" stroke="#b9c0cc" stroke-width="1.2"/>'
mk tr_plus.gif 19 16 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 19 16">'"$BOX"'<path d="M6.5 8h6M9.5 5v6" stroke="#be185d" stroke-width="1.4" stroke-linecap="round"/></svg>'
mk tr_minus.gif 19 16 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 19 16">'"$BOX"'<path d="M6.5 8h6" stroke="#be185d" stroke-width="1.4" stroke-linecap="round"/></svg>'
cp $OUT/tr_plus.gif $OUT/tr_plusb.gif; cp $OUT/tr_minus.gif $OUT/tr_minusb.gif
mk tr_folder.gif 19 16 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 19 16"><path d="M3 5.5h4l1.3 1.5H16v6H3z" fill="#f4b740"/></svg>'
mk tr_foldero.gif 19 16 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 19 16"><path d="M3 5.5h4l1.3 1.5H16v6H3z" fill="#ffd27a"/></svg>'

# ---- status service icons 42x42 (flat line, accent) ----
si(){ mk "$1" 42 42 '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 42 42"><circle cx="21" cy="21" r="20" fill="#fdeef5"/><g fill="none" stroke="#be185d" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">'"$2"'</g></svg>'; }
si i_fw.gif '<path d="M21 9l10 4v7c0 7-4.5 10-10 13-5.5-3-10-6-10-13v-7z"/>'
si i_vpn.gif '<rect x="13" y="20" width="16" height="12" rx="2"/><path d="M16 20v-3a5 5 0 0 1 10 0v3"/>'
si i_mail.gif '<rect x="10" y="13" width="22" height="16" rx="2"/><path d="M10 15l11 8 11-8"/>'
si i_emav.gif '<rect x="9" y="13" width="18" height="13" rx="2"/><path d="M9 14l9 7 9-7"/><path d="M27 20l5 2v4c0 3-2 4-5 5-3-1-5-2-5-5v-4z"/>'
si i_spam.gif '<rect x="10" y="13" width="22" height="16" rx="2"/><path d="M10 15l11 8 11-8"/><path d="M16 32l10-10"/>'
si i_vas.gif '<path d="M21 9l10 4v7c0 7-4.5 10-10 13-5.5-3-10-6-10-13v-7z"/><path d="M16 21l4 4 7-8"/>'
si i_vss.gif '<circle cx="19" cy="19" r="8"/><path d="M25 25l8 8"/>'
si i_ufp.gif '<circle cx="21" cy="21" r="12"/><path d="M9 21h24M21 9c4 4 4 20 0 24M21 9c-4 4-4 20 0 24"/>'
si i_upd.gif '<path d="M31 17a12 12 0 1 0 1 7"/><path d="M31 10v7h-7"/>'
si i_nas.gif '<rect x="10" y="12" width="22" height="8" rx="2"/><rect x="10" y="22" width="22" height="8" rx="2"/><circle cx="15" cy="16" r="1.3" fill="#be185d"/><circle cx="15" cy="26" r="1.3" fill="#be185d"/>'
si i_log.gif '<path d="M12 13h18M12 21h18M12 29h11"/>'
si i_band.gif '<path d="M9 30a12 12 0 0 1 24 0"/><path d="M21 30l7-7"/>'
si i_ddns.gif '<circle cx="21" cy="21" r="12"/><path d="M9 21h24M21 9c4 4 4 20 0 24M21 9c-4 4-4 20 0 24"/>'

echo "generated $(ls $OUT | wc -l) icons:"; ls $OUT | tr '\n' ' '; echo
