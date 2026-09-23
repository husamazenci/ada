#!/usr/bin/env bash
# Negatif kontrol (AGENTS.md §5.9): hatayı bilerek geri koy, testin DÜŞTÜĞÜNÜ gör.
# Düşmüyorsa test bir şey ölçmüyordur.
set -u
cd "$(dirname "$0")/.."
GODOT="${GODOT:-godot}"
KOS="$GODOT --headless --path . --script res://testler/katman-kurallari.gd"
gecti=0; kalan=0

dene() {  # dene <ad> <beklenen-kod>
	$KOS >/dev/null 2>&1
	local kod=$?
	if [ "$kod" -eq "$2" ]; then
		echo "  ✓ $1 → $kod (beklenen $2)"; gecti=$((gecti+1))
	else
		echo "  ✗ $1 → $kod (BEKLENEN $2)"; kalan=$((kalan+1))
	fi
}

echo "negatif-kontrol · katman-kurallari"
dene "temiz kopya" 0

echo 'var k = MeshInstance3D.new()' > betik/ai/_sabotaj.gd
dene "sabotaj: saf katmanda MeshInstance3D" 1
rm -f betik/ai/_sabotaj.gd

echo '# Node3D yalnızca yorumda' > betik/ai/_sabotaj.gd
dene "yorumdaki yasak kelime ihlal SAYILMAMALI" 0
rm -f betik/ai/_sabotaj.gd

mv betik/veri/surum.gd /tmp/_surum.gd.yedek
dene "hiç .gd yok → ölçemedi" 2
mv /tmp/_surum.gd.yedek betik/veri/surum.gd

dene "geri yüklendi" 0


# ---- degismez-esitlik ----
KOS2="./testler/degismez-esitlik.sh"
dene2() {  # dene2 <ad> <beklenen>
	$KOS2 >/dev/null 2>&1
	local kod=$?
	if [ "$kod" -eq "$2" ]; then
		echo "  ✓ $1 → $kod (beklenen $2)"; gecti=$((gecti+1))
	else
		echo "  ✗ $1 → $kod (BEKLENEN $2)"; kalan=$((kalan+1))
	fi
}

echo "negatif-kontrol · degismez-esitlik"
dene2 "temiz kopya" 0

cp belge/OYUN-TASARIMI.md /tmp/_tasarim.yedek
sed -i '' 's/tutarlı stilize/YARI GERÇEKÇİ/' belge/OYUN-TASARIMI.md
dene2 "sabotaj: tek dosyada görsel yön değişti" 1
cp /tmp/_tasarim.yedek belge/OYUN-TASARIMI.md

cp AGENTS.md /tmp/_agents.yedek
sed -i '' 's/<!-- GORSEL-YON:BASLA -->//' AGENTS.md
dene2 "sabotaj: işaret silindi → ölçemedi" 2
cp /tmp/_agents.yedek AGENTS.md

dene2 "geri yüklendi" 0
rm -f /tmp/_tasarim.yedek /tmp/_agents.yedek

echo "TOPLAM: $gecti geçti, $kalan kaldı"
[ "$kalan" -eq 0 ] && exit 0 || exit 1
