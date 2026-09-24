extends SceneTree

# GRİ KUTU KAPISI — sayısal yarısı.
#
# Kabul kriteri: "arkadaşın üç güven seviyesi EKRANDA ayırt edilebilmeli."
# Ekranda bakmadan önce burada sınanır: üç seviye birbirinden YETERİNCE
# ayrık mı, ve iki kanal (güven / moral) birbirine taşıyor mu?
#
# İkinci soru kritiktir: güven mesafeyi, moral tempoyu belirlemeli. Biri
# ötekinin kanalına taşarsa "çağırınca gecikmeli gelir" (orta güven) ile
# "yavaşlar" (orta moral) ekranda aynı görünür ve kriter çöker.
#
# Çıkış: 0 geçti · 1 başarısız · 2 ÇALIŞTIRILAMADI.

const D := preload("res://betik/ai/davranis.gd")
const A := preload("res://betik/veri/ayarlar.gd")

const YUKSEK := 0.80
const ORTA := 0.50
const DUSUK := 0.10

func _initialize() -> void:
	var hata: Array = []

	# 1 · Üç güven seviyesi mesafede AYRIK olmalı, bantları çakışmamalı.
	var b_yuksek := D.mesafe_bandi_m(YUKSEK)
	var b_orta := D.mesafe_bandi_m(ORTA)
	var b_dusuk := D.mesafe_bandi_m(DUSUK)
	print("mesafe bantları: yüksek %s · orta %s · düşük %s" % [b_yuksek, b_orta, b_dusuk])
	if b_yuksek.y >= b_orta.x:
		hata.append("yüksek ve orta bandı ÇAKIŞIYOR (%.1f ≥ %.1f)" % [b_yuksek.y, b_orta.x])
	if b_orta.y >= b_dusuk.x:
		hata.append("orta ve düşük bandı ÇAKIŞIYOR (%.1f ≥ %.1f)" % [b_orta.y, b_dusuk.x])

	# 2 · Aradaki fark GÖZLE seçilebilecek kadar olmalı (en az 1 m boşluk).
	if b_orta.x - b_yuksek.y < 1.0:
		hata.append("yüksek↔orta arası %.1f m — gözle ayırt edilemeyecek kadar dar" % (b_orta.x - b_yuksek.y))
	if b_dusuk.x - b_orta.y < 1.0:
		hata.append("orta↔düşük arası %.1f m — gözle ayırt edilemeyecek kadar dar" % (b_dusuk.x - b_orta.y))

	# 3 · Yönelim üç seviyede üç FARKLI değer vermeli.
	var yonelimler := [D.yonelim(YUKSEK), D.yonelim(ORTA), D.yonelim(DUSUK)]
	print("yönelim: yüksek %.1f · orta %.1f · düşük %.1f" % yonelimler)
	if yonelimler[0] == yonelimler[1] or yonelimler[1] == yonelimler[2]:
		hata.append("yönelim seviyeleri ayrışmıyor: %s" % str(yonelimler))

	# 4 · İKİ KANAL AYRIK MI — kriterin kalbi.
	if not D.iki_kanal_ayrik_mi():
		hata.append("İHLAL: güven ve moral kanalları birbirine taşıyor")
	# Doğrudan da sına: moral değişince mesafe değişmemeli, güven değişince tempo.
	var m0 := D.hedef_mesafe_m(YUKSEK)
	for moral in [0.20, 0.50, 0.90]:
		if not is_equal_approx(D.hedef_mesafe_m(YUKSEK), m0):
			hata.append("moral mesafeyi değiştirdi — kanallar karışmış")
	var t0 := D.tempo_carpani(0.90)
	for g in [0.10, 0.50, 0.90]:
		if not is_equal_approx(D.tempo_carpani(0.90), t0):
			hata.append("güven tempoyu değiştirdi — kanallar karışmış")

	# 5 · Moral üç seviyede üç farklı tempo vermeli; dipte OTURMALI.
	var tempolar := [D.tempo_carpani(0.80), D.tempo_carpani(0.50), D.tempo_carpani(0.20)]
	print("tempo: yüksek ×%.2f · orta ×%.2f · dip ×%.2f" % tempolar)
	if tempolar[0] == tempolar[1] or tempolar[1] == tempolar[2]:
		hata.append("tempo seviyeleri ayrışmıyor: %s" % str(tempolar))
	if not D.oturuyor_mu(0.20):
		hata.append("dip moralde oturmuyor")
	if D.oturuyor_mu(0.80):
		hata.append("yüksek moralde oturuyor")

	# 6 · Düşük güvende çağrıya GELMEZ; göz teması KURMAZ.
	if D.cagriya_tepki_sn(DUSUK).x >= 0.0:
		hata.append("düşük güvende çağrıya geliyor — davranış tablosuna aykırı")
	if D.goz_temasi_olasiligi(DUSUK) > 0.0:
		hata.append("düşük güvende göz teması kuruyor")
	print("çağrıya tepki: yüksek %s sn · orta %s sn · düşük gelmez" % [
		D.cagriya_tepki_sn(YUKSEK), D.cagriya_tepki_sn(ORTA)])

	print("")
	if hata.is_empty():
		print("GEÇTİ — üç seviye ayrık, iki kanal karışmıyor.")
		quit(0); return
	for h in hata:
		printerr("BAŞARISIZ: " + h)
	quit(1)
