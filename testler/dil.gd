extends SceneTree

# İKİ DİL (K-010) — "ekranda görünen her metin tek bir saf veri modülünden
# gelir; kodun içine görünür metin yazılmaz."
#
# Asıl risk şu: kod bir anahtar bildirir (örn. defter.is.ates) ama CSV'de
# karşılığı yoktur. O zaman oyun ekrana ham anahtarı basar ve bu ancak o
# sahneye gelindiğinde fark edilir. Test bunu önceden yakalar.
#
# Çıkış: 0 geçti · 1 başarısız · 2 ÇALIŞTIRILAMADI.

const CSV := "res://varlik/metin/metinler.csv"
const DILLER: Array[String] = ["tr", "en"]
const Df := preload("res://betik/veri/defter.gd")
const Sz := preload("res://betik/veri/sozler.gd")

func _initialize() -> void:
	var f := FileAccess.open(CSV, FileAccess.READ)
	if f == null:
		printerr("ÇALIŞTIRILAMADI: CSV açılamadı: %s" % CSV); quit(2); return

	var baslik := f.get_csv_line()
	if baslik.size() < 3 or baslik[0] != "keys":
		printerr("ÇALIŞTIRILAMADI: başlık 'keys,tr,en' değil: %s" % str(baslik)); quit(2); return
	var sutun := {}
	for i in range(1, baslik.size()):
		sutun[baslik[i]] = i
	for d in DILLER:
		if not sutun.has(d):
			printerr("ÇALIŞTIRILAMADI: '%s' sütunu yok" % d); quit(2); return

	var hata: Array = []
	var anahtarlar: Array = []
	while not f.eof_reached():
		var satir := f.get_csv_line()
		if satir.size() < 2 or satir[0].strip_edges().is_empty():
			continue
		var anahtar := satir[0]
		if anahtar in anahtarlar:
			hata.append("anahtar tekrar ediyor: %s" % anahtar)
		anahtarlar.append(anahtar)
		for d in DILLER:
			var i: int = sutun[d]
			if i >= satir.size() or satir[i].strip_edges().is_empty():
				hata.append("%s: '%s' dilinde karşılığı YOK" % [anahtar, d])
	f.close()

	if anahtarlar.is_empty():
		printerr("ÇALIŞTIRILAMADI: CSV'de hiç anahtar yok — test bir şey ölçmez."); quit(2); return

	# Kodun bildirdiği her anahtar CSV'de olmalı. Çizim girdisinin metni yoktur.
	var kod_anahtarlari: Array = []
	for g in Df.GIRDILER:
		if g["tur"] != "cizim":
			kod_anahtarlari.append(g["anahtar"])
	kod_anahtarlari.append_array(Sz.anahtarlar())
	for h in Sz.dogrula():
		hata.append("söz değişmezi: " + h)
	for a in kod_anahtarlari:
		if a not in anahtarlar:
			hata.append("KOD '%s' bildiriyor ama CSV'de yok — ekrana ham anahtar basılır" % a)

	# Boru hattı gerçekten çalışıyor mu: çeviri anahtarın KENDİSİNİ döndürmemeli.
	for d in DILLER:
		TranslationServer.set_locale(d)
		for a in kod_anahtarlari:
			if tr(a) == a:
				hata.append("%s (%s): çeviri çözülmedi, ham anahtar döndü" % [a, d])

	print("anahtar: %d · dil: %s · kodun bildirdiği: %d" % [
		anahtarlar.size(), ", ".join(DILLER), kod_anahtarlari.size()])

	print("")
	if hata.is_empty():
		print("GEÇTİ — her anahtarın iki dilde de karşılığı var ve çözülüyor.")
		quit(0); return
	for h in hata:
		printerr("BAŞARISIZ: " + h)
	quit(1)
