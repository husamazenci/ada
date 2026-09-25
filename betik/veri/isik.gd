class_name Isik
extends RefCounted

# GÜNÜN IŞIĞI — saf eğri, çizim değil.
#
# Buraya kadar gece YALNIZCA SİMÜLASYONDA vardı: `Dunya.gece_mi()` true
# dönüyordu ama ekran gündüz gibi duruyordu. Sonuç şuydu — ateşin 6 m'lik
# ışık çemberi hiçbir şey ifade etmiyordu (ortam ışığı zaten her yeri
# aydınlatıyordu), köpeğin "ışığın sınırında durması" görünmüyordu, ve
# K-058'in bütün gerekçesi ekranda karşılıksız kalıyordu.
#
# Eğri SAF katmanda çünkü asıl soru sayısal ve sınanabilir olmalı:
# **ekranın karanlığı ile simülasyonun gecesi aynı anda mı başlıyor?**
# Ayrı ayrı yazılsalardı er geç kayarlardı; burada `Ayarlar`ın eşiklerinden
# TÜREV alınıyorlar.

const A := preload("res://betik/veri/ayarlar.gd")

## Şafak bu kadarlık sürede tamamlanır (gün kesri).
const SAFAK_SURESI := 0.08

# Uç değerler. Gündüz sayıları gri kutunun mevcut ışığından alındı ki
# görüntü bozulmasın; gece sayıları ateşin okunabilmesi için seçildi.
const GUNES_GUNDUZ := 1.1
const GUNES_GECE := 0.0
const ORTAM_GUNDUZ := 0.65
const ORTAM_GECE := 0.08        # ay ışığı: sıfır değil, ama ateşten çok altta

const GOK_GUNDUZ := Color(0.58, 0.60, 0.62)
const GOK_GECE := Color(0.045, 0.055, 0.075)
const GOK_ALACAKARANLIK := Color(0.42, 0.26, 0.18)
const GUNES_RENK_GUNDUZ := Color(1.0, 0.97, 0.92)
const GUNES_RENK_ALACAKARANLIK := Color(1.0, 0.62, 0.34)

## 0 = tam gece · 1 = tam gündüz. Öteki her şey bundan türer.
static func gunduz_orani(t: float) -> float:
	var g := fposmod(t, 1.0)
	if g < SAFAK_SURESI:
		return g / SAFAK_SURESI
	if g < A.GUNDUZ_BITIS:
		return 1.0
	if g < A.ALACAKARANLIK_BITIS:
		# Alacakaranlık: gündüzün bitişinden gecenin başlangıcına iner.
		# Payda EŞİKLERDEN gelir, elle yazılmaz — kayamasınlar.
		return 1.0 - (g - A.GUNDUZ_BITIS) / (A.ALACAKARANLIK_BITIS - A.GUNDUZ_BITIS)
	return 0.0

## Alacakaranlığın turuncusu. Tepe noktası geçişin ortasında.
static func alacakaranlik_orani(t: float) -> float:
	var g := fposmod(t, 1.0)
	if g < A.GUNDUZ_BITIS or g >= A.ALACAKARANLIK_BITIS:
		# Şafak da alacakaranlıktır; aynı turuncuyu ters yönde kullanır.
		if g < SAFAK_SURESI:
			return 1.0 - g / SAFAK_SURESI
		return 0.0
	var k := (g - A.GUNDUZ_BITIS) / (A.ALACAKARANLIK_BITIS - A.GUNDUZ_BITIS)
	return sin(k * PI)     # 0 → 1 → 0

static func gunes_enerjisi(t: float) -> float:
	return lerpf(GUNES_GECE, GUNES_GUNDUZ, gunduz_orani(t))

static func ortam_enerjisi(t: float) -> float:
	return lerpf(ORTAM_GECE, ORTAM_GUNDUZ, gunduz_orani(t))

static func gok_rengi(t: float) -> Color:
	var taban := GOK_GECE.lerp(GOK_GUNDUZ, gunduz_orani(t))
	return taban.lerp(GOK_ALACAKARANLIK, alacakaranlik_orani(t) * 0.7)

static func gunes_rengi(t: float) -> Color:
	return GUNES_RENK_GUNDUZ.lerp(GUNES_RENK_ALACAKARANLIK, alacakaranlik_orani(t))

## Güneşin yükseklik açısı: tepe noktasında dik, ufka inerken yatay.
## Godot'da yönlü ışığın yönü −Z SÜTUNUdur (K-045'in dersi); burada yalnızca
## açıyı veriyoruz, dönüşümü çizim katmanı kuruyor.
static func gunes_egimi_derece(t: float) -> float:
	return lerpf(-4.0, -62.0, gunduz_orani(t))

## Ekranın karanlığı ile simülasyonun gecesi AYNI ANDA mı başlıyor?
## Bu soruyu testler/isik.gd soruyor; cevabı burada tek yerde duruyor.
static func ekranda_gece_mi(t: float) -> bool:
	return gunduz_orani(t) <= 0.0
