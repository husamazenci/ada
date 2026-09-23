#!/usr/bin/env bash
# AGENTS.md ile belge/OYUN-TASARIMI.md'deki işaretli bloklar BİREBİR AYNI olmalı.
# İkinci denemede bu kural yazılıydı ama denetlenmiyordu ("ileride bir test bu
# eşitliği denetleyecek" diye borç bırakılmıştı).
# Çıkış: 0 eşit · 1 farklı · 2 ÇALIŞTIRILAMADI.
set -u
cd "$(dirname "$0")/.."

BLOKLAR="GORSEL-YON DEGISMEZ-KURALLAR"

cikar() {  # cikar <dosya> <blok-adi>
	awk -v b="$2" '
		$0 ~ "<!-- " b ":BASLA" {y=1; next}
		$0 ~ "<!-- " b ":BITIR"  {y=0}
		y' "$1"
}

for f in AGENTS.md belge/OYUN-TASARIMI.md; do
	[ -f "$f" ] || { echo "ÇALIŞTIRILAMADI: dosya yok: $f" >&2; exit 2; }
done

hata=0
for b in $BLOKLAR; do
	a=$(cikar AGENTS.md "$b")
	t=$(cikar belge/OYUN-TASARIMI.md "$b")
	if [ -z "$a" ] || [ -z "$t" ]; then
		echo "ÇALIŞTIRILAMADI: '$b' bloğu bir dosyada boş — test bir şey ölçmez." >&2
		exit 2
	fi
	if [ "$a" = "$t" ]; then
		echo "  ✓ $b — birebir aynı ($(printf '%s' "$a" | wc -l | tr -d ' ') satır)"
	else
		echo "  ✗ $b — FARKLI:" >&2
		diff <(printf '%s\n' "$a") <(printf '%s\n' "$t") >&2
		hata=1
	fi
done

[ "$hata" -eq 0 ] && { echo "GEÇTİ — işaretli blokların hepsi eşit."; exit 0; }
echo "BAŞARISIZ" >&2; exit 1
