#!/usr/bin/env bash
# Bütün testleri koşar. Hem elde hem CI'da aynı betik çalışır — iki ayrı
# liste tutulsaydı biri eksik kalırdı ve CI yeşil görünürken bir test hiç
# koşmuyor olurdu.
#
# ÇIKIŞ KODU: 0 geçti · 1 başarısız · 2 ÇALIŞTIRILAMADI.
# 2 BAŞARISIZLIKTIR. "Atlandı" diye bir sonuç yoktur (K-003).
set -u
cd "$(dirname "$0")/.."
GODOT="${GODOT:-godot}"

TESTLER=(
	katman-kurallari zincir moral-tabani algi defter dil kayit
	davranis cagri animasyon ates kopek soz isik alti-gun
)

gecti=0; kalan=0; olcemedi=0
for t in "${TESTLER[@]}"; do
	$GODOT --headless --path . --script "res://testler/$t.gd" >/tmp/ada-test-$t.log 2>&1
	kod=$?
	case $kod in
		0) printf "  ✓ %-18s\n" "$t"; gecti=$((gecti+1)) ;;
		2) printf "  ✗ %-18s ÇALIŞTIRILAMADI (ölçüm yapılamadı — geçti SAYILMAZ)\n" "$t"
		   tail -3 "/tmp/ada-test-$t.log" | sed 's/^/      /'
		   olcemedi=$((olcemedi+1)) ;;
		*) printf "  ✗ %-18s BAŞARISIZ (%d)\n" "$t" "$kod"
		   tail -6 "/tmp/ada-test-$t.log" | sed 's/^/      /'
		   kalan=$((kalan+1)) ;;
	esac
done

./testler/degismez-esitlik.sh >/tmp/ada-test-esitlik.log 2>&1
kod=$?
if [ $kod -eq 0 ]; then
	printf "  ✓ %-18s\n" "degismez-esitlik"; gecti=$((gecti+1))
else
	printf "  ✗ %-18s (%d)\n" "degismez-esitlik" "$kod"
	tail -6 /tmp/ada-test-esitlik.log | sed 's/^/      /'
	kalan=$((kalan+1))
fi

echo ""
echo "TOPLAM: $gecti geçti · $kalan başarısız · $olcemedi ölçülemedi"
[ $((kalan + olcemedi)) -eq 0 ] && exit 0 || exit 1
