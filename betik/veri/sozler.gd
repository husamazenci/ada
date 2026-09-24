class_name Sozler
extends RefCounted

# OYUNCUNUN SÖZLERİ (K-063). Arkadaş konuşmaz; oyuncu **dener**.
#
# Duyulan şey KELİME DEĞİL: karakterin boğuk, anlaşılmayan mırıltısı. Ekranda
# beliren yazı o mırıltının YAKLAŞIK karşılığıdır. Bu ayrım önemli — seslendirilmiş
# diyalog olsaydı sahne bir konuşma denemesi olurdu; mırıltı + yazı olunca
# bir yalnızlık anı oluyor. Cevap gelmez, seçenek çıkmaz, diyalog açılmaz.
#
# DEĞİŞMEZ SINIR: yalnızca ÇAĞRI ve SORU olabilir. "Bildirim" diye bir tür
# YOKTUR — yani "seni bırakmam", "buna değer" gibi bir satır yazılamaz, çünkü
# yazılacak yeri yok. Sebep tasarım pusulası: oyuncunun arkadaşa karşı tutumunu
# oyun belirleyemez. Sınır burada inşa sırasında sağlanır.

# Kapalı tür listesi. "bildirim" BİLEREK yok.
const TURLER: Array[String] = ["cagri", "soru"]

# Bütün oyun boyunca. Az olması kasıtlı: her biri cevapsız kalacak.
const EN_COK := 6

const SOZLER: Array[Dictionary] = [
	{"anahtar": "soz.hey",            "tur": "cagri", "gun": 1},
	{"anahtar": "soz.iyi_misin",      "tur": "soru",  "gun": 1},
	{"anahtar": "soz.duyuyor_musun",  "tur": "soru",  "gun": 1},
	# "Bekle" ÇAĞRI türünde (K-072, kullanıcı kararı). Yeni bir tür açmak
	# yerine çağrının çeşidi sayıldı: Q'ya basmak "gel", basılı tutmak "kal".
	# Buyruk türü açılsaydı kapalı liste gevşerdi ve sonrasını tutmak zorlaşırdı.
	{"anahtar": "soz.bekle",          "tur": "cagri", "gun": 3},
]

static func dogrula() -> Array:
	var hata: Array = []
	var gorulen: Array = []
	for s in SOZLER:
		var a: String = s["anahtar"]
		if a in gorulen:
			hata.append("söz tekrar ediyor: %s" % a)
		gorulen.append(a)
		if not a.begins_with("soz."):
			hata.append("%s: anahtar 'soz.' ile başlamalı" % a)
		if s["tur"] not in TURLER:
			hata.append("%s: tür kapalı listede yok (%s) — yalnızca çağrı ve soru" % [a, s["tur"]])
	if SOZLER.size() > EN_COK:
		hata.append("söz sayısı %d — en çok %d; fazlası diyalog sistemine dönüşür" % [SOZLER.size(), EN_COK])
	if "bildirim" in TURLER:
		hata.append("İHLAL: 'bildirim' türü listeye sızmış — oyun oyuncunun tutumunu söyleyemez")
	return hata

static func anahtarlar() -> Array:
	var a: Array = []
	for s in SOZLER:
		a.append(s["anahtar"])
	return a
