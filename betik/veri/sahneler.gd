class_name Sahneler
extends RefCounted

# Hikâye omurgası: 9 sahne, 6 gün. SAF VERİ — hiçbir görsel düğüm bilmez.
#
# A1 DÜZELTMESİ (K-055). Eski zincir kırılabiliyordu: fırtınanın izi
# `barinak-hasarli` idi ve kriz + sal buna bağlıydı, ama barınak ZORUNLU
# DEĞİLDİ. Barınak yoksa iz düşmüyor, iz düşmeyince kriz ve sal hiç
# tetiklenmiyor, oyun kapanışa HİÇ ulaşamıyordu.
#
# Kural: zincirin önkoşulu YALNIZCA koşulsuz iz olabilir.
#   · koşulsuz iz  → sahne olduysa her hâlükârda düşer. Zinciri besler.
#   · koşullu iz   → o sahnede ne yapıldıysa. VARYANTLARI besler, zinciri asla.

const OMURGA: Array[Dictionary] = [
	{"ad": "uyanis",      "gun": 1, "onkosul": "",                 "iz": "oyun-basladi",
	 "kosullu": [], "cutscene": true},
	{"ad": "ates",        "gun": 2, "onkosul": "oyun-basladi",     "iz": "ates-sahnesi-gecti",
	 "kosullu": ["ates-yakildi", "ilk-gece-yalniz"], "cutscene": false},
	{"ad": "kim-gidecek", "gun": 3, "onkosul": "ates-sahnesi-gecti", "iz": "ayrilik-gecti",
	 "kosullu": ["uzaga-giden", "soz-tutuldu"], "cutscene": false},
	{"ad": "kopek",       "gun": 3, "onkosul": "ayrilik-gecti",    "iz": "kopek-gecti",
	 "kosullu": ["yara-kimde", "korudu-mu"], "cutscene": false},
	{"ad": "firtina",     "gun": 4, "onkosul": "kopek-gecti",      "iz": "firtina-gecti",
	 "kosullu": ["barinak-hasarli", "firtinada-birlikte"], "cutscene": true},
	{"ad": "kriz",        "gun": 5, "onkosul": "firtina-gecti",    "iz": "kriz-gecti",
	 "kosullu": ["kriz-siddeti"], "cutscene": false},
	{"ad": "sal",         "gun": 5, "onkosul": "firtina-gecti",    "iz": "sal-dunyada",
	 "kosullu": [], "cutscene": false},
	{"ad": "son-gece",    "gun": 6, "onkosul": "sal-dunyada",      "iz": "son-gece-gecti",
	 "kosullu": [], "cutscene": false},
	{"ad": "ayrilik",     "gun": 6, "onkosul": "son-gece-gecti",   "iz": "oyun-bitti",
	 "kosullu": ["kim-gitti"], "cutscene": true},
]

# İnşa değişmezleri. Bozulursa oyun HİÇ yüklenmez — "testte geçiyor ama
# ekranda bozuk" durumu yapısal olarak imkânsız olmalı (AGENTS.md §5.2).
static func dogrula() -> Array:
	var hata: Array = []
	var gorulen_izler: Array = []
	var butun_kosullu: Array = []
	for s in OMURGA:
		butun_kosullu.append_array(s["kosullu"])
	for i in OMURGA.size():
		var s: Dictionary = OMURGA[i]
		if s["iz"] in gorulen_izler:
			hata.append("%s: koşulsuz iz tekrar ediyor (%s)" % [s["ad"], s["iz"]])
		var ok: String = s["onkosul"]
		if ok == "":
			if i != 0:
				hata.append("%s: yalnızca ilk sahnenin önkoşulu boş olabilir" % s["ad"])
		else:
			if ok in butun_kosullu:
				hata.append("%s: önkoşul KOŞULLU iz (%s) — zincir kırılabilir" % [s["ad"], ok])
			elif ok not in gorulen_izler:
				hata.append("%s: önkoşul (%s) daha ÖNCEKİ bir sahnenin izi değil" % [s["ad"], ok])
		gorulen_izler.append(s["iz"])
	if OMURGA[OMURGA.size() - 1]["iz"] != "oyun-bitti":
		hata.append("son sahne 'oyun-bitti' izini bırakmıyor — oyun hiç bitmez")
	return hata

static func cutscene_sayisi() -> int:
	var n := 0
	for s in OMURGA:
		if s["cutscene"]:
			n += 1
	return n
