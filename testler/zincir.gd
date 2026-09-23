extends SceneTree

# A1 DEĞİŞMEZİ (K-055) — zincir kırılamaz.
#
# Eski tasarımda barınak kurmayan oyuncu kapanış sahnesine HİÇ ulaşamıyordu.
# Bu test iki şeyi ayrı ayrı sınar: (1) inşa değişmezleri tutuyor mu,
# (2) HİÇBİR ŞEY YAPMAYAN oyuncuda zincir sonuna kadar çözülüyor mu.
#
# Çıkış: 0 geçti · 1 başarısız · 2 ÇALIŞTIRILAMADI.

const S := preload("res://betik/veri/sahneler.gd")
const A := preload("res://betik/veri/ayarlar.gd")

func _initialize() -> void:
	if S.OMURGA.is_empty():
		printerr("ÇALIŞTIRILAMADI: omurga boş — test bir şey ölçmez."); quit(2); return

	var hata: Array = S.dogrula()
	for h in hata:
		printerr("İNŞA DEĞİŞMEZİ: " + h)

	# Hiç katılmayan oyuncu: her sahne 'sensiz' geçer, koşulsuz izi yine düşer.
	var dunyadaki_izler: Array = []
	var acilan: Array = []
	for gun in range(1, A.TOPLAM_GUN + 1):
		for s in S.OMURGA:
			if s["ad"] in acilan:
				continue
			if gun < s["gun"]:
				continue
			if s["onkosul"] != "" and s["onkosul"] not in dunyadaki_izler:
				continue
			acilan.append(s["ad"])
			dunyadaki_izler.append(s["iz"])   # KOŞULSUZ: oyuncu orada olmasa bile

	print("hiç katılmayan oyuncu: %d/%d sahne açıldı" % [acilan.size(), S.OMURGA.size()])
	print("sıra: %s" % ", ".join(acilan))

	if acilan.size() != S.OMURGA.size():
		var kalan: Array = []
		for s in S.OMURGA:
			if s["ad"] not in acilan:
				kalan.append(s["ad"])
		hata.append("zincir KIRILDI — açılamayan sahneler: %s" % ", ".join(kalan))
	if "oyun-bitti" not in dunyadaki_izler:
		hata.append("oyun hiç bitmiyor: 'oyun-bitti' izi düşmedi")
	if S.cutscene_sayisi() != 3:
		hata.append("tam cutscene sayısı %d — KİLİTLİ olan 3 (K-055/D2)" % S.cutscene_sayisi())

	print("")
	if hata.is_empty():
		print("GEÇTİ — zincir kırılmıyor, cutscene sayısı kilitli.")
		quit(0); return
	for h in hata:
		printerr("BAŞARISIZ: " + h)
	quit(1)
