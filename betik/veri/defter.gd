class_name Defter
extends RefCounted

# DEFTER (K-059). Enkazda bulunan boş defter; karakter onu kendi eliyle
# doldurur. Üç tür girdi: hafıza (olan biten), iş (çekirdek, dünyaya dair),
# çizim (adanın krokisi).
#
# DEĞİŞMEZ SINIR: defter ARKADAŞ hakkında hiçbir İŞ yazmaz. Tasarım pusulası
# "oyuncu arkadaşa karşı tutumunu TAMAMEN kendi belirlemeli" diyor; defterde
# "ona yiyecek ver" yazsaydı tutumu oyun belirlemiş olurdu ve kabul kriteri
# ("güveni davranıştan okuyabiliyor mu") çökerdi. Sınır burada inşa sırasında
# sağlanır, sonradan kontrol edilmez.
#
# Metin YOK, yalnızca ANAHTAR var (K-010: koda görünür metin yazılmaz).

const S := preload("res://betik/veri/sahneler.gd")

# İşlerin hedefi yalnızca bu KAPALI listeden olabilir. Hepsi dünyaya dair.
const IS_HEDEFLERI: Array[String] = ["ates", "su", "barinak", "sal", "yiyecek"]

# Defterin asla iş yazamayacağı alan. Liste kapalı ve tek maddelik olması
# kasıtlı: ilişkiye dair her şey oyuncunundur.
const YASAK_HEDEFLER: Array[String] = ["arkadas"]

const EN_COK_IS := 6

const GIRDILER: Array[Dictionary] = [
	# --- çekirdek işler (dünyaya dair, sayılı) ---
	{"tur": "is", "hedef": "su",      "anahtar": "defter.is.su",      "gun": 1},
	{"tur": "is", "hedef": "ates",    "anahtar": "defter.is.ates",    "gun": 2},
	{"tur": "is", "hedef": "barinak", "anahtar": "defter.is.barinak", "gun": 2},
	{"tur": "is", "hedef": "yiyecek", "anahtar": "defter.is.yiyecek", "gun": 3},
	{"tur": "is", "hedef": "sal",     "anahtar": "defter.is.sal",     "gun": 5},

	# --- hafıza (GEÇMİŞ ZAMAN; sahnenin koşulsuz iziyle tetiklenir) ---
	{"tur": "hafiza", "iz": "oyun-basladi",        "anahtar": "defter.hafiza.uyanis"},
	{"tur": "hafiza", "iz": "ates-sahnesi-gecti",  "anahtar": "defter.hafiza.ates"},
	{"tur": "hafiza", "iz": "ayrilik-gecti",       "anahtar": "defter.hafiza.ayrilik"},
	{"tur": "hafiza", "iz": "kopek-gecti",         "anahtar": "defter.hafiza.kopek"},
	{"tur": "hafiza", "iz": "firtina-gecti",       "anahtar": "defter.hafiza.firtina"},
	{"tur": "hafiza", "iz": "kriz-gecti",          "anahtar": "defter.hafiza.kriz"},
	{"tur": "hafiza", "iz": "sal-dunyada",         "anahtar": "defter.hafiza.sal"},

	# --- çizim (ada fazında doldurulacak) ---
	{"tur": "cizim", "anahtar": "defter.cizim.ada", "gun": 2},
]

static func dogrula() -> Array:
	var hata: Array = []
	var kosulsuz_izler: Array = []
	for s in S.OMURGA:
		kosulsuz_izler.append(s["iz"])

	var is_sayisi := 0
	for g in GIRDILER:
		var tur: String = g["tur"]
		var anahtar: String = g["anahtar"]

		if tur == "is":
			is_sayisi += 1
			var hedef: String = g["hedef"]
			if hedef in YASAK_HEDEFLER:
				hata.append("İŞ arkadaşı hedef alıyor (%s) — defter ilişkiye yön veremez" % anahtar)
			elif hedef not in IS_HEDEFLERI:
				hata.append("%s: hedef kapalı listede yok (%s)" % [anahtar, hedef])
			# Anahtar da denetlenir: hedef alanı doğru olsa bile metin
			# arkadaşa işaret ediyorsa sınır delinmiş demektir.
			for y in YASAK_HEDEFLER:
				if y in anahtar:
					hata.append("%s: iş anahtarı arkadaşa işaret ediyor" % anahtar)
		elif tur == "hafiza":
			var iz: String = g["iz"]
			if iz not in kosulsuz_izler:
				hata.append("%s: hafıza girdisi KOŞULSUZ bir ize bağlı değil (%s) — sahne kaçırılırsa defter boş kalır" % [anahtar, iz])
		elif tur != "cizim":
			hata.append("%s: bilinmeyen girdi türü (%s)" % [anahtar, tur])

	if is_sayisi > EN_COK_IS:
		hata.append("iş girdisi %d — en çok %d olabilir; 'sayılı birkaç' görev listesine dönüşüyor" % [is_sayisi, EN_COK_IS])
	return hata

static func is_sayisi() -> int:
	var n := 0
	for g in GIRDILER:
		if g["tur"] == "is":
			n += 1
	return n

static func anahtarlar() -> Array:
	var a: Array = []
	for g in GIRDILER:
		a.append(g["anahtar"])
	return a
