extends SceneTree

# DEFTER DEĞİŞMEZİ (K-059) — defterin ilişkiye yön vermediğini sınar.
#
# Kullanıcı defteri isterken K-041'in "görev listesi yok" maddesi değişti.
# Kuralın korunan yarısı şu: defter DÜNYA hakkında iş yazabilir, ARKADAŞ
# hakkında asla. Bu sınır olmadan tasarım pusulası ("oyuncu tutumunu tamamen
# kendi belirler") ve kabul kriteri birlikte çöker.
#
# Çıkış: 0 geçti · 1 başarısız · 2 ÇALIŞTIRILAMADI.

const Df := preload("res://betik/veri/defter.gd")

func _initialize() -> void:
	if Df.GIRDILER.is_empty():
		printerr("ÇALIŞTIRILAMADI: defter boş — test bir şey ölçmez."); quit(2); return

	var hata: Array = Df.dogrula()
	for h in hata:
		printerr("İNŞA DEĞİŞMEZİ: " + h)

	# 1 · Hiçbir İŞ arkadaşı hedef alamaz (asıl sınır).
	for g in Df.GIRDILER:
		if g["tur"] != "is":
			continue
		if g["hedef"] in Df.YASAK_HEDEFLER:
			hata.append("İHLAL: iş arkadaşı hedef alıyor (%s)" % g["anahtar"])

	# 2 · Arkadaş, izin verilen hedefler listesinde HİÇ bulunmamalı.
	for y in Df.YASAK_HEDEFLER:
		if y in Df.IS_HEDEFLERI:
			hata.append("İHLAL: '%s' izin verilen hedefler listesine sızmış" % y)

	# 3 · "Sayılı birkaç" gerçekten sayılı mı?
	if Df.is_sayisi() > Df.EN_COK_IS:
		hata.append("iş sayısı %d > %d" % [Df.is_sayisi(), Df.EN_COK_IS])

	# 4 · Anahtarlar benzersiz olmalı (aynı satır iki kez yazılmasın).
	var gorulen: Array = []
	for a in Df.anahtarlar():
		if a in gorulen:
			hata.append("anahtar tekrar ediyor: %s" % a)
		gorulen.append(a)

	# 5 · Metin koda yazılmamalı (K-010): girdiler yalnızca ANAHTAR taşır.
	for g in Df.GIRDILER:
		if not String(g["anahtar"]).begins_with("defter."):
			hata.append("%s: anahtar değil düz metin olabilir" % g["anahtar"])

	print("girdi: %d (iş %d, en çok %d) · anahtar hepsi benzersiz" % [
		Df.GIRDILER.size(), Df.is_sayisi(), Df.EN_COK_IS])

	print("")
	if hata.is_empty():
		print("GEÇTİ — defter dünyaya yön veriyor, ilişkiye değil.")
		quit(0); return
	for h in hata:
		printerr("BAŞARISIZ: " + h)
	quit(1)
