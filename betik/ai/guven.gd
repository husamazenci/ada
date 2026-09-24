class_name Guven
extends RefCounted

# Güven ve moral: İKİ AYRI EKSEN (K-005).
#   Güveni SEN düşürürsün; morali koşullar iter — ama DİBİ senin ihmalin açar.
#
# A2 düzeltmesi (K-055): eskiden "morali koşullar düşürür" + "düşük moral
# öldürür" + "arkadaş senin yüzünden ölür" üçü yan yana duramıyordu; koşullar
# öldürüyordu, yani "kötü şans ölümü" değişmez kuralı çiğniyordu.
# Çözüm tek satır:  taban = MORAL_ORTA_ALT × (1 − ihmal)
# ihmal = 0 iken moral matematiksel olarak ölümcül bölgeye İNEMEZ.

const A := preload("res://betik/veri/ayarlar.gd")

var deger := A.GUVEN_BASLANGIC
var moral := A.MORAL_BASLANGIC
var ihmal := 0.0

var _gun_icinde_yukselis := 0
var _cokus_suresi_gun := 0.0
var bakim_gordu_bugun := false

func bedelli_jest() -> bool:
	# Yalnızca arkadaşın GÖRDÜĞÜ ve gerçekten bedel taşıyan jest buraya gelir.
	# Günlük tavan, jesti çiftliğe çevirmeyi engeller — "yavaş yükselir".
	if _gun_icinde_yukselis >= A.GUVEN_GUNLUK_YUKSELIS_TAVANI:
		return false
	_gun_icinde_yukselis += 1
	deger = minf(deger + A.GUVEN_YUKSELIS, 1.0)
	bakim_gordu_bugun = true
	return true

func ihanet() -> void:
	deger = maxf(deger - A.GUVEN_DUSUS, 0.0)

func ihmal_ekle(miktar: float) -> void:
	ihmal = minf(ihmal + miktar, 1.0)

func moral_tabani() -> float:
	return A.MORAL_ORTA_ALT * (1.0 - ihmal)

func ilerle(kosul_baskisi: float, gun_kesri: float) -> void:
	var taban := moral_tabani()
	var hedef := maxf(1.0 - kosul_baskisi, taban)
	moral = move_toward(moral, hedef, gun_kesri * 1.2)
	moral = maxf(moral, taban)   # koşullar tabanın altına İNEMEZ
	if moral <= A.MORAL_COKUS_ESIGI:
		_cokus_suresi_gun += gun_kesri
	else:
		_cokus_suresi_gun = 0.0

func gun_dondu() -> void:
	_gun_icinde_yukselis = 0
	if bakim_gordu_bugun:
		ihmal = maxf(ihmal - A.IHMAL_GUNLUK_GERILEME, 0.0)
	bakim_gordu_bugun = false

func cokuyor_mu() -> bool:
	return moral <= A.MORAL_COKUS_ESIGI

func olebilir_mi(gun: int) -> bool:
	# Üç şart birden: çöküş eşiğinin altında · yeterince uzun sürmüş ·
	# en erken gün gelmiş. İkisi eksikse ölüm YOK (K-055).
	return cokuyor_mu() \
		and _cokus_suresi_gun >= A.COKUS_EN_AZ_GUN \
		and gun >= A.OLUM_EN_ERKEN_GUN

func seviye() -> String:
	if deger < A.GUVEN_DUSUK_UST:
		return "düşük"
	if deger >= A.GUVEN_YUKSEK_ALT:
		return "yüksek"
	return "orta"

func moral_seviye() -> String:
	if moral < A.MORAL_ORTA_ALT:
		return "dip"
	if moral >= 0.66:
		return "yüksek"
	return "orta"
