#!/usr/bin/env bash
# AGENTS.md §2 ile belge/OYUN-TASARIMI.md §6'daki görsel yön bloğu
# BİREBİR AYNI olmalı. İkinci denemede bu kural yazılıydı ama denetlenmiyordu;
# "ileride bir test bu eşitliği denetleyecek" diye borç bırakılmıştı.
# Çıkış: 0 eşit · 1 farklı · 2 ÇALIŞTIRILAMADI.
set -u
cd "$(dirname "$0")/.."

cikar() {  # cikar <dosya>
	awk '/<!-- GORSEL-YON:BASLA -->/{y=1;next} /<!-- GORSEL-YON:BITIR -->/{y=0} y' "$1"
}

for f in AGENTS.md belge/OYUN-TASARIMI.md; do
	[ -f "$f" ] || { echo "ÇALIŞTIRILAMADI: dosya yok: $f" >&2; exit 2; }
done

a=$(cikar AGENTS.md)
t=$(cikar belge/OYUN-TASARIMI.md)

if [ -z "$a" ] || [ -z "$t" ]; then
	echo "ÇALIŞTIRILAMADI: işaretler arasında blok bulunamadı (boş taranırsa test bir şey ölçmez)." >&2
	exit 2
fi

if [ "$a" = "$t" ]; then
	echo "GEÇTİ — görsel yön bloğu iki dosyada birebir aynı ($(printf '%s' "$a" | wc -l | tr -d ' ') satır)."
	exit 0
fi

echo "BAŞARISIZ — bloklar farklı:" >&2
diff <(printf '%s\n' "$a") <(printf '%s\n' "$t") >&2
exit 1
