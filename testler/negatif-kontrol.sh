#!/usr/bin/env bash
# Negatif kontrol (AGENTS.md §5.8): hatayı bilerek geri koy, testin DÜŞTÜĞÜNÜ gör.
# Düşmüyorsa test bir şey ölçmüyordur.
#
# ÖNEMLİ: sabotajın UYGULANDIĞI da doğrulanır. İkinci denemede sabotaj metinleri
# veri kayınca sessizce eşleşmiyor ve sabotaj hiç uygulanmadan test "geçti"
# diyordu — yani negatif kontrolün kendisi yalan söylüyordu (§5.10). Burada
# dosya gerçekten değişmediyse sonuç BAŞARISIZ sayılır.
set -u
cd "$(dirname "$0")/.."
GODOT="${GODOT:-godot}"
gecti=0; kalan=0

kos() {  # kos <test-adi> → çıkış kodu
	case "$1" in
		katman)  $GODOT --headless --path . --script res://testler/katman-kurallari.gd >/dev/null 2>&1 ;;
		esitlik) ./testler/degismez-esitlik.sh >/dev/null 2>&1 ;;
		altigun) $GODOT --headless --path . --script res://testler/alti-gun.gd >/dev/null 2>&1 ;;
		moral)   $GODOT --headless --path . --script res://testler/moral-tabani.gd >/dev/null 2>&1 ;;
		zincir)  $GODOT --headless --path . --script res://testler/zincir.gd >/dev/null 2>&1 ;;
		algi)    $GODOT --headless --path . --script res://testler/algi.gd >/dev/null 2>&1 ;;
		defter)  $GODOT --headless --path . --script res://testler/defter.gd >/dev/null 2>&1 ;;
		dil)     $GODOT --headless --path . --script res://testler/dil.gd >/dev/null 2>&1 ;;
		kayit)   $GODOT --headless --path . --script res://testler/kayit.gd >/dev/null 2>&1 ;;
		davranis) $GODOT --headless --path . --script res://testler/davranis.gd >/dev/null 2>&1 ;;
		cagri)   $GODOT --headless --path . --script res://testler/cagri.gd >/dev/null 2>&1 ;;
	esac
	return $?
}

dene() {  # dene <test> <ad> <beklenen>
	kos "$1"; local kod=$?
	if [ "$kod" -eq "$3" ]; then
		echo "  ✓ $2 → $kod"; gecti=$((gecti+1))
	else
		echo "  ✗ $2 → $kod (BEKLENEN $3)"; kalan=$((kalan+1))
	fi
}

sabotaj() {  # sabotaj <dosya> <sed-ifadesi>  → uygulanmadıysa 1 döner
	cp "$1" "/tmp/_sab.yedek"
	sed -i '' "$2" "$1"
	if cmp -s "$1" "/tmp/_sab.yedek"; then
		echo "  ✗ SABOTAJ UYGULANMADI: $1 ← '$2' (metin eşleşmedi, §5.10)"
		kalan=$((kalan+1)); return 1
	fi
	return 0
}
geri() { cp "/tmp/_sab.yedek" "$1"; }

# ============ katman-kurallari ============
echo "negatif-kontrol · katman-kurallari"
dene katman "temiz kopya" 0

echo 'var k = MeshInstance3D.new()' > betik/ai/_sabotaj.gd
dene katman "sabotaj: saf katmanda MeshInstance3D" 1
rm -f betik/ai/_sabotaj.gd

echo '# Node3D yalnızca yorumda' > betik/ai/_sabotaj.gd
dene katman "yorumdaki yasak kelime ihlal SAYILMAMALI" 0
rm -f betik/ai/_sabotaj.gd

# Saf katmanların TAMAMI boşalmadan "ölçemedim" tetiklenmez. Bu sabotaj
# tek dosya varken yazılmıştı ve dosya sayısı artınca eskidi — düzeltildi.
# Geri yükleme ELLE LİSTEYLE yapılmaz. İlk yazışımda liste vardı ve yeni bir
# dosya (surum.gd) eklenince listede olmadığı için SİLİNDİ — negatif kontrolün
# kendisi hasar verdi. Artık ağaç olduğu gibi yedeklenip olduğu gibi dönüyor.
rm -rf /tmp/_saf_yedek; mkdir -p /tmp/_saf_yedek
for k in sim ai veri; do cp -R "betik/$k" "/tmp/_saf_yedek/$k"; done
find betik/sim betik/ai betik/veri -name '*.gd' -delete
dene katman "saf katmanlarda hiç .gd yok → ölçemedi" 2
for k in sim ai veri; do cp -R "/tmp/_saf_yedek/$k/." "betik/$k/"; done
rm -rf /tmp/_saf_yedek
dene katman "geri yüklendi" 0

# ============ degismez-esitlik ============
echo "negatif-kontrol · degismez-esitlik"
dene esitlik "temiz kopya" 0
if sabotaj belge/OYUN-TASARIMI.md 's/tutarlı stilize/YARI GERÇEKÇİ/'; then
	dene esitlik "sabotaj: tek dosyada görsel yön değişti" 1; geri belge/OYUN-TASARIMI.md
fi
if sabotaj AGENTS.md 's/<!-- GORSEL-YON:BASLA -->//'; then
	dene esitlik "sabotaj: işaret silindi → ölçemedi" 2; geri AGENTS.md
fi
dene esitlik "geri yüklendi" 0

# ============ alti-gun ============
echo "negatif-kontrol · alti-gun"
dene altigun "temiz kopya" 0
if sabotaj betik/ai/guven.gd 's/deger + A.GUVEN_YUKSELIS/deger + 0.0/'; then
	dene altigun "sabotaj: bedelli jest güveni yükseltmiyor" 1; geri betik/ai/guven.gd
fi
if sabotaj betik/ai/guven.gd 's/deger - A.GUVEN_DUSUS/deger - 0.0/'; then
	dene altigun "sabotaj: ihanet güveni düşürmüyor" 1; geri betik/ai/guven.gd
fi
if sabotaj betik/sim/dunya.gd 's/and gun >= 5:/and gun >= 999:/'; then
	dene altigun "sabotaj: arkadaş hiç gitmiyor" 1; geri betik/sim/dunya.gd
fi
# KAPSAM SINIRI, kayıt için: alti-gun moral tabanını ÖLÇEMEZ. Fedakâr koşuda
# moral zaten tabana yaklaşmıyor, dolayısıyla taban kaldırılınca sonuç
# değişmiyor. Bu bir eksiklik değil, doğru iş bölümü — ama yazılmazsa biri
# "A2 kapsanıyor" sanır. Ölçen test: moral-tabani. Beklenen 0 = "kaçtı" değil,
# "bu testin işi değil".
if sabotaj betik/ai/guven.gd 's/moral = maxf(moral, taban)/moral = moral/'; then
	dene altigun "moral tabanı alti-gun'un KAPSAMI DIŞINDA (ölçen: moral-tabani)" 0; geri betik/ai/guven.gd
fi
dene altigun "geri yüklendi" 0

# ============ moral-tabani (A2 değişmezi) ============
echo "negatif-kontrol · moral-tabani"
dene moral "temiz kopya" 0

# Taban İKİ yerde korunuyor (hedef kırpması + son kırpma). Bu kasıtlı: biri
# düşerse öteki tutar. Tek tek sabotajın GEÇMESİ beklenir — savunma derinliği.
cp betik/ai/guven.gd /tmp/_g.yedek
sed -i '' 's/maxf(1.0 - kosul_baskisi, taban)/(1.0 - kosul_baskisi)/' betik/ai/guven.gd
cmp -s betik/ai/guven.gd /tmp/_g.yedek && { echo "  ✗ SABOTAJ UYGULANMADI (hedef kırpması)"; kalan=$((kalan+1)); }
dene moral "tek kırpma düşse ÖTEKİ tutmalı (savunma derinliği)" 0

# Ama İKİSİ birden düşerse değişmez çökmeli — düşmüyorsa test ölçmüyordur.
sed -i '' 's/moral = maxf(moral, taban)/moral = moral/' betik/ai/guven.gd
cmp -s betik/ai/guven.gd /tmp/_g.yedek && { echo "  ✗ SABOTAJ UYGULANMADI (son kırpma)"; kalan=$((kalan+1)); }
dene moral "sabotaj: İKİ kırpma da kaldırıldı → değişmez çökmeli" 1
cp /tmp/_g.yedek betik/ai/guven.gd

if sabotaj betik/veri/ayarlar.gd 's/const OLUM_EN_ERKEN_GUN := 6/const OLUM_EN_ERKEN_GUN := 1/'; then
	dene moral "sabotaj: ölüm 1. günden mümkün" 1; geri betik/veri/ayarlar.gd
fi
if sabotaj betik/veri/ayarlar.gd 's/const COKUS_EN_AZ_GUN := 2.0/const COKUS_EN_AZ_GUN := 0.0/'; then
	dene moral "sabotaj: müdahale penceresi kaldırıldı" 1; geri betik/veri/ayarlar.gd
fi
if sabotaj betik/sim/dunya.gd 's/	arkadas.ihtiyactan_olebilir = false/	pass/'; then
	dene moral "sabotaj: arkadaş açlıktan ölebiliyor (ikinci ölüm yolu)" 1; geri betik/sim/dunya.gd
fi
if sabotaj betik/ai/guven.gd 's/	if denedi_mi:/	if false:/'; then
	dene moral "sabotaj: denedi-yetişemedi de cezalandırılıyor" 1; geri betik/ai/guven.gd
fi
if sabotaj betik/ai/guven.gd 's/	if not gordu_mu:/	if false:/'; then
	dene moral "sabotaj: görmediği için de cezalandırıyor" 1; geri betik/ai/guven.gd
fi
if sabotaj betik/ai/guven.gd 's/	if not muhtac_mi:/	if false:/'; then
	dene moral "sabotaj: sağlamken ayrılmak da ihmal sayılıyor (ucuz ikiz)" 1; geri betik/ai/guven.gd
fi
if sabotaj betik/veri/ayarlar.gd 's/const IHMAL_GECE_YALNIZ_BIRAKMA := 0.25/const IHMAL_GECE_YALNIZ_BIRAKMA := 0.0/'; then
	dene moral "sabotaj: gece yalnız bırakma ihmal üretmiyor" 1; geri betik/veri/ayarlar.gd
fi
dene moral "geri yüklendi" 0
rm -f /tmp/_sab.yedek /tmp/_g.yedek

# ============ zincir (A1 değişmezi) ============
echo "negatif-kontrol · zincir"
dene zincir "temiz kopya" 0

# İLK SABOTAJ ESKİ HATANIN TA KENDİSİ: fırtınanın önkoşulunu koşullu ize
# bağlamak. Barınak kurmayan oyuncuda kriz ve sal hiç tetiklenmiyor, oyun
# kapanışa ulaşamıyordu (K-055/A1). Test bunu yakalamıyorsa hiçbir şey
# yakalamıyordur.
if sabotaj betik/veri/sahneler.gd 's/"onkosul": "kopek-gecti"/"onkosul": "barinak-hasarli"/'; then
	dene zincir "sabotaj: önkoşul KOŞULLU ize bağlandı (eski hata)" 1; geri betik/veri/sahneler.gd
fi
if sabotaj betik/veri/sahneler.gd 's/"ad": "ayrilik",     "gun": 6/"ad": "ayrilik",     "gun": 9/'; then
	dene zincir "sabotaj: son sahne takvim dışına itildi" 1; geri betik/veri/sahneler.gd
fi
if sabotaj betik/veri/sahneler.gd '/"ad": "barinak"/,+1s/"cutscene": false/"cutscene": true/'; then
	dene zincir "sabotaj: dördüncü cutscene eklendi (kilit D2)" 1; geri betik/veri/sahneler.gd
fi
if sabotaj belge/HIKAYE-OMURGASI.md 's/| barinak | 3 |/| barinak | 9 |/'; then
	dene zincir "sabotaj: belge tablosu koddan kaydı" 1; geri belge/HIKAYE-OMURGASI.md
fi
dene zincir "geri yüklendi" 0

# ============ algi (K-058 ateş ışığı istisnası) ============
echo "negatif-kontrol · algi"
dene algi "temiz kopya" 0

if sabotaj betik/sim/dunya.gd 's/if gece_mi() and not _ates_isiginda_mi():/if gece_mi():/'; then
	dene algi "sabotaj: ateş istisnası kaldırıldı" 1; geri betik/sim/dunya.gd
fi
if sabotaj betik/sim/dunya.gd 's/return ates_yaniyor and oyuncu_atesin_isiginda and arkadas_atesin_isiginda/return ates_yaniyor and oyuncu_atesin_isiginda/'; then
	dene algi "sabotaj: arkadaşın ışıkta olması aranmıyor" 1; geri betik/sim/dunya.gd
fi
if sabotaj betik/veri/ayarlar.gd 's/const GECE_GORUS_CARPANI := 0.45/const GECE_GORUS_CARPANI := 1.0/'; then
	dene algi "sabotaj: gece görüşü hiç daralmıyor" 1; geri betik/veri/ayarlar.gd
fi
if sabotaj betik/veri/ayarlar.gd 's/const BAKIS_ESIGI_ORTA := ESIK_HISSEDILIR/const BAKIS_ESIGI_ORTA := 0.55/'; then
	dene algi "sabotaj: bakış eşiği fırsattan yüksek (görünmez fırsat)" 1; geri betik/veri/ayarlar.gd
fi
if sabotaj betik/veri/ayarlar.gd 's/const BAKIS_KAPANIS_ORTA := 0.45/const BAKIS_KAPANIS_ORTA := 0.50/'; then
	dene algi "sabotaj: histerezis kaldırıldı" 1; geri betik/veri/ayarlar.gd
fi
dene algi "geri yüklendi" 0

# ============ defter (K-059 sınırı) ============
echo "negatif-kontrol · defter"
dene defter "temiz kopya" 0

# ASIL SINAV: defter arkadaş hakkında iş yazarsa yakalanmalı.
if sabotaj betik/veri/defter.gd 's/"hedef": "ates",    "anahtar"/"hedef": "arkadas", "anahtar"/'; then
	dene defter "sabotaj: iş arkadaşı hedef alıyor" 1; geri betik/veri/defter.gd
fi
if sabotaj betik/veri/defter.gd 's/\["ates", "su", "barinak", "sal", "yiyecek"\]/["ates", "su", "barinak", "sal", "yiyecek", "arkadas"]/'; then
	dene defter "sabotaj: arkadaş izinli hedef listesine sızdı" 1; geri betik/veri/defter.gd
fi
if sabotaj betik/veri/defter.gd 's/const EN_COK_IS := 6/const EN_COK_IS := 2/'; then
	dene defter "sabotaj: 'sayılı birkaç' aşıldı" 1; geri betik/veri/defter.gd
fi
if sabotaj betik/veri/defter.gd 's/"iz": "firtina-gecti"/"iz": "barinak-hasarli"/'; then
	dene defter "sabotaj: hafıza KOŞULLU ize bağlandı" 1; geri betik/veri/defter.gd
fi
if sabotaj betik/veri/defter.gd 's/"anahtar": "defter.is.su",      "gun": 2/"anahtar": "defter.is.su",      "gun": 1/'; then
	dene defter "sabotaj: defterden ÖNCE yazılmış girdi" 1; geri betik/veri/defter.gd
fi
dene defter "geri yüklendi" 0

# ============ dil (K-010) ============
echo "negatif-kontrol · dil"
dene dil "temiz kopya" 0

if sabotaj varlik/metin/metinler.csv 's/^defter.is.ates,Ateş.,Fire.$/defter.is.ates,Ateş.,/'; then
	dene dil "sabotaj: bir anahtarın İngilizcesi silindi" 1; geri varlik/metin/metinler.csv
fi
if sabotaj varlik/metin/metinler.csv '/^defter.hafiza.kopek,/d'; then
	dene dil "sabotaj: kodun bildirdiği anahtar CSV'den silindi" 1; geri varlik/metin/metinler.csv
fi
dene dil "geri yüklendi" 0

# ============ kayit (K-006) ============
echo "negatif-kontrol · kayit"
dene kayit "temiz kopya" 0

# ASIL SINAV: kayıttan bir alan DÜŞERSE gidiş-dönüş ayrışmalı.
if sabotaj betik/sim/kayit.gd 's/"_gun_icinde_yukselis": d.guven._gun_icinde_yukselis,/"_gun_icinde_yukselis": 0,/'; then
	dene kayit "sabotaj: günlük jest tavanı kaydedilmiyor" 1; geri betik/sim/kayit.gd
fi
if sabotaj betik/sim/kayit.gd 's/"_aclik_soylendi": i._aclik_soylendi,/"_aclik_soylendi": false,/'; then
	dene kayit "sabotaj: eşik cümlesi durumu kaydedilmiyor" 1; geri betik/sim/kayit.gd
fi
if sabotaj betik/sim/kayit.gd 's/"_cokus_suresi_gun": d.guven._cokus_suresi_gun,/"_cokus_suresi_gun": 0.0,/'; then
	dene kayit "sabotaj: çöküş süresi kaydedilmiyor" 1; geri betik/sim/kayit.gd
fi
if sabotaj betik/sim/kayit.gd 's/int(veri\["surum"\]) != SURUM/false/'; then
	dene kayit "sabotaj: kip denetimi kaldırıldı (eski yuva kabul edilir)" 1; geri betik/sim/kayit.gd
fi
if sabotaj betik/sim/kayit.gd 's/^	if FileAccess.file_exists(YUVA):$/	if false:/'; then
	dene kayit "sabotaj: ölünce yuva silinmiyor" 1; geri betik/sim/kayit.gd
fi
dene kayit "geri yüklendi" 0

# ============ davranis (gri kutu kapısı) ============
echo "negatif-kontrol · davranis"
dene davranis "temiz kopya" 0

# ASIL SINAV: iki kanal birbirine taşarsa yakalanmalı. Spekt bunu "dip moralin
# oturması izleyiciyi sistematik olarak 'düşük güven' yanıtına götürür" diye
# uyarmıştı; sayısal karşılığı budur.
if sabotaj betik/ai/davranis.gd 's/		return Vector2(1.5, 2.5)/		return Vector2(1.5, 4.0)/'; then
	dene davranis "sabotaj: yüksek ve orta mesafe bandı çakıştı" 1; geri betik/ai/davranis.gd
fi
if sabotaj betik/ai/davranis.gd 's/^	return 0.70$/	return 1.00/'; then
	dene davranis "sabotaj: orta moral temposu yüksekle aynı oldu" 1; geri betik/ai/davranis.gd
fi
if sabotaj betik/ai/davranis.gd 's/^	return 0.0$/	return 1.0/'; then
	dene davranis "sabotaj: düşük güvende göz teması kuruluyor" 1; geri betik/ai/davranis.gd
fi
dene davranis "geri yüklendi" 0

# ============ cagri (K-068) ============
echo "negatif-kontrol · cagri"
dene cagri "temiz kopya" 0

# Oyunun en yüksek sesli işareti: düşük güvende GELMEMEK.
if sabotaj betik/ai/davranis.gd 's/		return Vector2(-1.0, -1.0)     # gelmez/		return Vector2(1.0, 2.0)/'; then
	dene cagri "sabotaj: düşük güvende de geliyor" 1; geri betik/ai/davranis.gd
fi
# Cevapsızlık en yavaş cevaptan kısa olursa orta güven "gelmiyor" diye okunur.
if sabotaj betik/ai/davranis.gd 's/\.y + 1\.0$/.y - 1.0/'; then
	dene cagri "sabotaj: sessizlik en yavaş cevaptan kısa" 1; geri betik/ai/davranis.gd
fi
# Cevap mesafesi güveni okumayı bırakırsa mesafe kanalı çöker.
if sabotaj betik/ai/davranis.gd 's/^	return mesafe_bandi_m(guven)\.x$/	return 1.5/'; then
	dene cagri "sabotaj: çağrı herkesi aynı noktaya getiriyor" 1; geri betik/ai/davranis.gd
fi
# Menzil düşük güven bandının altına inerse "gelmedi" ile "duymadı" karışır.
if sabotaj betik/veri/ayarlar.gd 's/^const CAGRI_MENZILI_M := 25\.0$/const CAGRI_MENZILI_M := 8.0/'; then
	dene cagri "sabotaj: çağrı menzili duruş mesafesinin altında" 1; geri betik/veri/ayarlar.gd
fi
# En sinsi hata: her basış sayacı sıfırlarsa sabırsız oyuncu asla cevap alamaz.
if sabotaj betik/ai/cagri.gd 's/^	if _soguma_sn > 0\.0 or mesgul_mu():$/	if false:/'; then
	dene cagri "sabotaj: tekrar basmak bekleyen çağrıyı sıfırlıyor" 1; geri betik/ai/cagri.gd
fi
# Çağırmak ucuz jesttir; güveni yükseltemez (§2).
if sabotaj betik/sim/dunya.gd 's|^	return cagri\.cagir(guven\.deger, duyar_mi())$|	guven.bedelli_jest(); return cagri.cagir(guven.deger, duyar_mi())|'; then
	dene cagri "sabotaj: çağırmak güveni yükseltiyor" 1; geri betik/sim/dunya.gd
fi
# Cevap penceresi kapanmazsa tek çağrı mesafeyi kalıcı değiştirir.
if sabotaj betik/ai/cagri.gd '/GELIYOR, GELMEDI:/,+1s/durum = YOK/durum = GELIYOR/'; then
	dene cagri "sabotaj: cevap penceresi hiç kapanmıyor" 1; geri betik/ai/cagri.gd
fi
# Moral kanalı: çökmüş beden çağrıya kalkmamalı.
if sabotaj betik/sim/dunya.gd 's/^	cagri\.ilerle(dt_sn, not Dv\.oturuyor_mu(guven\.moral))$/	cagri.ilerle(dt_sn, true)/'; then
	dene cagri "sabotaj: çökmüş beden çağrıya yürüyor" 1; geri betik/sim/dunya.gd
fi
# Menzil hatası "küsme" diye okunmamalı — ayrı sayılır.
if sabotaj betik/ai/cagri.gd 's/^		duyulmayan += 1$/		yanitsiz += 1/'; then
	dene cagri "sabotaj: duyulmayan çağrı reddetme sayılıyor" 1; geri betik/ai/cagri.gd
fi
# Askıya alma dünyayı sürdürür, ANI değil: dünkü bağırış yüklenmemeli.
if sabotaj betik/sim/kayit.gd '/^static func yukle/,/^static func _kisi/s/^	return true$/	d.cagri.durum = 2; return true/'; then
	dene cagri "sabotaj: yüklenen oyunda dünkü çağrı bekliyor" 1; geri betik/sim/kayit.gd
fi
dene cagri "geri yüklendi" 0

echo "GENEL TOPLAM: $gecti geçti, $kalan kaldı"
[ "$kalan" -eq 0 ] && exit 0 || exit 1
