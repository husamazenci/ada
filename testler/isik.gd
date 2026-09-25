extends SceneTree

# GÜNÜN IŞIĞI (K-073).
#
# Tek soru: **ekranın karanlığı ile simülasyonun gecesi aynı anda mı
# başlıyor?**
#
# Ayrı ayrı yazılmış olsalardı er geç kayarlardı ve şu doğardı: `gece_mi()`
# true döner, oyuncu ekranda gündüz görür. O kayma sessizdir — hiçbir hata
# vermez, yalnızca ateşin ışık çemberi, köpeğin "ışığın sınırında durması" ve
# K-058'in bütün gerekçesi karşılıksız kalır.
#
# Çıkış: 0 geçti · 1 başarısız · 2 ÇALIŞTIRILAMADI.

const I := preload("res://betik/veri/isik.gd")
const A := preload("res://betik/veri/ayarlar.gd")
const D := preload("res://betik/sim/dunya.gd")

func _initialize() -> void:
	var hata: Array = []

	# ---- 1 · SİMÜLASYON GECE DİYORSA EKRAN KARANLIK ----
	#
	# İlk yazışımda "ikisi HER NOKTADA aynı olmalı" diye yazdım ve test düştü:
	# t=0.000'da ekran karanlık ama `gece_mi()` false. Kod doğruydu, DEĞİŞMEZİM
	# fazla katıydı — t=0 ŞAFAK ANI; fiziksel olarak karanlık ama simülasyonun
	# "gece" dediği evre (günün son çeyreği) değil.
	#
	# Önemli olan yön TEK: simülasyon gece diyorsa ekran karanlık OLMALI.
	# Tersi serbest ve doğru — şafak kısa bir karanlıktır.
	var d = D.new()
	var ihlal := 0
	var ornek := 0
	for i in 2000:
		var t := float(i) / 2000.0
		d.t = t
		ornek += 1
		if d.gece_mi() and not I.ekranda_gece_mi(t):
			ihlal += 1
	print("%d örnek · 'sim gece ama ekran aydınlık' ihlali: %d" % [ornek, ihlal])
	if ornek == 0:
		printerr("ÇALIŞTIRILAMADI: hiç örnek denetlenmedi"); quit(2); return
	if ihlal > 0:
		hata.append("%d noktada simülasyon gece diyor ama ekran aydınlık" % ihlal)

	# Ters yöndeki karanlık YALNIZCA şafak olmalı ve KISA olmalı. Uzun
	# olsaydı oyuncu gündüzün bir bölümünü gece sanırdı.
	var gunduz_karanlik: Array = []
	for i in 2000:
		var t := float(i) / 2000.0
		d.t = t
		if I.ekranda_gece_mi(t) and not d.gece_mi():
			gunduz_karanlik.append(t)
	var en_gec: float = gunduz_karanlik.max() if not gunduz_karanlik.is_empty() else 0.0
	print("gece olmadığı hâlde karanlık olan en geç an: t=%.4f (şafak sınırı %.4f)" % [
		en_gec, I.SAFAK_SURESI])
	if en_gec > I.SAFAK_SURESI + 0.001:
		hata.append("t=%.4f'e kadar karanlık sürüyor ama gece değil — gündüzün bir kısmı gece sanılır" % en_gec)

	# ---- 2 · GECE GERÇEKTEN KARANLIK ----
	var gunduz_isik := I.gunes_enerjisi(0.35) + I.ortam_enerjisi(0.35)
	var gece_isik := I.gunes_enerjisi(0.85) + I.ortam_enerjisi(0.85)
	print("ışık toplamı: gündüz %.3f · gece %.3f (oran %.1f×)" % [
		gunduz_isik, gece_isik, gunduz_isik / maxf(gece_isik, 0.001)])
	if gece_isik >= gunduz_isik * 0.25:
		hata.append("gece ışığı gündüzün %.0f%%'i — yeterince karanlık değil" % (
			100.0 * gece_isik / gunduz_isik))

	# ---- 3 · GECE GÜNEŞ TAM SIFIR ----
	# Sıfırın biraz üstünde kalsaydı gölgeler her yeri aydınlatır, ateşin
	# çemberi diye bir şey kalmazdı.
	for t in [0.76, 0.85, 0.99]:
		if I.gunes_enerjisi(t) > 0.0001:
			hata.append("t=%.2f gecede güneş hâlâ yanıyor (%.3f)" % [t, I.gunes_enerjisi(t)])

	# ---- 4 · ATEŞ GECEYİ YENMELİ ----
	# Ateşin ışığı ortam ışığından belirgin biçimde güçlü olmalı, yoksa
	# "ışığın sınırı" diye bir sınır oluşmaz.
	var ates_gucu := 2.4       # betik/cizim/ates.gd'deki tepe enerji
	print("gece ortamı %.3f · ateş %.2f (oran %.0f×)" % [
		I.ORTAM_GECE, ates_gucu, ates_gucu / I.ORTAM_GECE])
	if ates_gucu < I.ORTAM_GECE * 8.0:
		hata.append("ateş gece ortamından yeterince güçlü değil — ışığın sınırı okunmaz")

	# ---- 5 · SÜREKLİ: SIÇRAMA YOK ----
	var en_buyuk_sicrama := 0.0
	var nerede := 0.0
	var onceki := I.gunduz_orani(0.0)
	for i in range(1, 4000):
		var t := float(i) / 4000.0
		var su := I.gunduz_orani(t)
		var fark := absf(su - onceki)
		if fark > en_buyuk_sicrama:
			en_buyuk_sicrama = fark
			nerede = t
		onceki = su
	print("en büyük tek adım sıçraması %.4f (t=%.3f)" % [en_buyuk_sicrama, nerede])
	if en_buyuk_sicrama > 0.02:
		hata.append("t=%.3f'te ışık %.3f sıçrıyor — gün dönümü göze çarpar" % [
			nerede, en_buyuk_sicrama])

	# ---- 6 · ALACAKARANLIK TEK YÖNLÜ İNİYOR ----
	var onceki2 := I.gunduz_orani(A.GUNDUZ_BITIS)
	for i in range(1, 200):
		var t: float = A.GUNDUZ_BITIS + (A.ALACAKARANLIK_BITIS - A.GUNDUZ_BITIS) * float(i) / 200.0
		var su := I.gunduz_orani(t)
		if su > onceki2 + 0.0001:
			hata.append("alacakaranlıkta ışık ARTIYOR (t=%.3f) — güneş geri doğuyor" % t)
			break
		onceki2 = su

	# ---- 7 · ŞAFAK GECEDEN ÇIKARIYOR ----
	if I.gunduz_orani(0.0) > 0.0001:
		hata.append("gün şafakta değil tam ışıkta başlıyor")
	if I.gunduz_orani(I.SAFAK_SURESI) < 0.999:
		hata.append("şafak bitiminde gündüz tam değil")

	# ---- 8 · EŞİKLER AYARLAR'DAN TÜREV ----
	# Eğri kendi eşiğini tutmamalı; Ayarlar'daki sayı değişince eğri de
	# değişmeli. Gece başlangıcı tam ALACAKARANLIK_BITIS'te olmalı.
	var eps := 0.0005
	if I.gunduz_orani(A.ALACAKARANLIK_BITIS - eps) <= 0.0:
		hata.append("gece ALACAKARANLIK_BITIS'ten ÖNCE başlıyor")
	if I.gunduz_orani(A.ALACAKARANLIK_BITIS + eps) > 0.0:
		hata.append("gece ALACAKARANLIK_BITIS'te başlamıyor")

	print("")
	if hata.is_empty():
		print("GEÇTİ — ekran ile simülasyon aynı anda kararıyor; ateş geceyi yeniyor.")
		quit(0); return
	for h in hata:
		printerr("BAŞARISIZ: " + h)
	quit(1)
