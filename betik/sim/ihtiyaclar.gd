class_name Ihtiyaclar
extends RefCounted

# Bir kişinin (oyuncu ya da arkadaş) bedensel durumu. SAF: hiçbir görsel düğüm
# bilmez, kendini çizmez. Sebep: arkadaşın davranışı pencere açmadan ölçülebilmeli.

const A := preload("res://betik/veri/ayarlar.gd")

var aclik := 0.15
var susuzluk := 0.20
var yorgunluk := 0.10
var yarali := false
var yara_kalan_gun := 0.0
var oldu := false

# ARKADAŞ İHTİYAÇTAN ÖLEMEZ (K-055/K-062). Değişmez kural ölümün ani
# olamayacağını söylüyor: çöküş 4. günden itibaren görünür olmalı, iki tam gün
# müdahale penceresi bulunmalı, ve en erken 6. günün şafağında gelmeli.
# Açlık sayacının 1.0'a vurmasıyla gelen ölüm bu sistemin TAMAMINI atlıyordu —
# iki ayrı ölüm yolu vardı ve yalnızca biri kurala tabiydi.
# Arkadaşta bu yol kapalıdır: aşırı açlık yalnızca baskı üretir, baskı morali
# iter, moral ancak İHMAL varsa ölümcül bölgeye iner (Guven.olebilir_mi).
var ihtiyactan_olebilir := true

# Duyum cümlesi eşiği bir kez geçilir; her karede tekrar bağırmaz (K-056).
var _aclik_soylendi := false
var _susuzluk_soylendi := false

func ilerle(gun_kesri: float, uyuyor: bool) -> Array:
	# Dönüş: bu adımda ilk kez geçilen eşiklerin listesi ("aclik", "susuzluk").
	# Duyum cümlesini tetikleyen şey budur.
	if oldu:
		return []
	aclik = minf(aclik + A.ACLIK_HIZI * gun_kesri, 1.0)
	susuzluk = minf(susuzluk + A.SUSUZLUK_HIZI * gun_kesri, 1.0)
	if uyuyor:
		yorgunluk = maxf(yorgunluk - A.UYKU_TOPARLAMA * gun_kesri, 0.0)
	else:
		yorgunluk = minf(yorgunluk + A.YORGUNLUK_HIZI * gun_kesri, 1.0)

	var yeni: Array = []
	if not _aclik_soylendi and aclik >= A.ESIK_HISSEDILIR:
		_aclik_soylendi = true
		yeni.append("aclik")
	if not _susuzluk_soylendi and susuzluk >= A.ESIK_HISSEDILIR:
		_susuzluk_soylendi = true
		yeni.append("susuzluk")

	# Yara İYİLEŞİR. Süresiz olsaydı 3. gecedeki bir ısırık oyunun kalanını
	# tamamen belirlerdi; tasarım iki gün diyor (4. gün ağır, 5. gün hafif).
	if yara_kalan_gun > 0.0:
		yara_kalan_gun = maxf(yara_kalan_gun - gun_kesri, 0.0)
		if yara_kalan_gun <= 0.0:
			yarali = false

	if ihtiyactan_olebilir and (aclik >= A.ESIK_OLUM or susuzluk >= A.ESIK_OLUM):
		oldu = true
	return yeni

func yarala() -> bool:
	# Dönüş: bu YARALIYKEN gelen ikinci yara mı (ölümcül olabilir).
	# "İlk saldırı yaralar, yaralıyken ikincisi öldürebilir" (tasarım §dilim).
	var ikinci := yarali
	yarali = true
	yara_kalan_gun = A.YARA_SURESI_GUN
	return ikinci

func ye() -> void:
	aclik = maxf(aclik - A.YIYECEK_DOYURUR, 0.0)
	if aclik < A.ESIK_HISSEDILIR:
		_aclik_soylendi = false

func ic() -> void:
	susuzluk = maxf(susuzluk - A.SU_KANDIRIR, 0.0)
	if susuzluk < A.ESIK_HISSEDILIR:
		_susuzluk_soylendi = false

func muhtac_mi() -> bool:
	# "Bedelli jest" ancak karşı taraf gerçekten muhtaçken anlam taşır.
	return aclik >= A.ESIK_HISSEDILIR or susuzluk >= A.ESIK_HISSEDILIR

func en_acil() -> String:
	if aclik < A.ESIK_HISSEDILIR and susuzluk < A.ESIK_HISSEDILIR:
		return ""
	return "su" if susuzluk >= aclik else "yiyecek"

func baski() -> float:
	# Koşulların moral üzerindeki toplam ağırlığı [0,1].
	var b := aclik * 0.35 + susuzluk * 0.35 + yorgunluk * 0.15
	if yarali:
		b += 0.25
	return minf(b, 1.0)

func ozet() -> String:
	return "aç %.2f · susuz %.2f · yorgun %.2f%s" % [
		aclik, susuzluk, yorgunluk, " · YARALI" if yarali else ""]
