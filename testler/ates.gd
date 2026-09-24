extends SceneTree

# ATEŞ VE YAKIT (K-070) — ihmal kanalının dördüncü kaynağı.
#
# Buradaki asıl soru "yakıt tükeniyor mu" değil, ŞU:
#
#   Ateşin sönmesi OYUNCUNUN İHMALİ mi, yoksa kıtlığın kaçınılmaz sonucu mu?
#
# İkincisiyse ceza adaletsizdir ve oyunun en ağır yaptırımı (moral tabanını
# indirmek) şansa bağlanmış olur. K-055'te kullanıcı bunu açıkça istemişti:
# "ölüm bir kazaya değil, bir birikime bağlı." Testin çoğu o adaleti ölçüyor.
#
# Çıkış: 0 geçti · 1 başarısız · 2 ÇALIŞTIRILAMADI.

const D := preload("res://betik/sim/dunya.gd")
const A := preload("res://betik/veri/ayarlar.gd")
const ADIM := 1.0 / 480.0

func _initialize() -> void:
	var hata: Array = []

	# ---- 1 · ADALET, YAPIYLA ----
	# Bir gecenin istediği yakıt, bir günde toplanabilen odundan AZ olmalı.
	# Aksi hâlde oyuncu elinden geleni yapsa bile ateş söner ve ihmal yazılır.
	var gece_uzunlugu := 1.0 - A.ALACAKARANLIK_BITIS
	var gece_ister := gece_uzunlugu * A.ATES_GECE_YAKIT_HIZI
	var gun_verir := float(A.GUNLUK_ODUN_BULUNUR) * A.ODUN_KATKISI
	print("gece %.2f yakıt ister · bir gün %.2f verir (%d kütük × %.2f)" % [
		gece_ister, gun_verir, A.GUNLUK_ODUN_BULUNUR, A.ODUN_KATKISI])
	if gun_verir < gece_ister:
		hata.append("İHLAL: kıtlık ateşi söndürüyor — günde %.2f toplanıyor, gece %.2f istiyor. İhmal oyuncunun değil dünyanın suçu olur." % [gun_verir, gece_ister])

	# Ocak tavanı geceden KÜÇÜK olmalı: tek besleme geceyi çıkarırsa
	# "gecenin ortasında kalkmak" diye bir şey kalmaz — mekaniğin sebebi o.
	if A.ATES_YAKIT_TAVANI >= gece_ister:
		hata.append("ocak tavanı (%.2f) geceyi tek başına çıkarıyor (%.2f) — gece kalkma yok" % [
			A.ATES_YAKIT_TAVANI, gece_ister])

	# İlk gece ateşsiz geçer (K-063): oyunun ilk bedeli olan an orada doğar.
	# Ateş 1. güne alınırsa o an hediye edilmiş olur.
	if A.ATES_ILK_GUN < 2:
		hata.append("İHLAL: ateş %d. günde yakılabiliyor — ilk gece ateşsiz geçmeli (K-063)" % A.ATES_ILK_GUN)

	# ---- 2 · GÜNDÜZ TÜKETMEZ ----
	var g = D.new()
	g.gun = 3
	g.t = 0.10
	g.ates_yaniyor = true
	g.ates_yakit = 1.0
	for i in 200:
		g.adim(ADIM, func(_d): return "bekle")
	print("gündüz 200 adım sonra yakıt: %.3f" % g.ates_yakit)
	if not is_equal_approx(g.ates_yakit, 1.0):
		hata.append("gündüz yakıt tükendi (%.3f) — gece bütçesi kurulamaz" % g.ates_yakit)

	# ---- 3 · GECE TÜKETİR VE SÖNER, İHMAL BİR KEZ YAZILIR ----
	# 2. GECEDE ölçülüyor, 3'te değil: köpek 3. geceden itibaren geliyor
	# (K-071) ve ateşsiz gece onu da çağırıyor, o da 0.20 ihmal yazıyor.
	# 3. gecede ölçseydim 0.10 yerine 0.30 görürdüm ve "mandal bozuk"
	# derdim — oysa bozuk olan ölçüm olurdu (§5.7: tek değişken değiştir).
	var n = D.new()
	n.gun = 2
	n.t = A.ALACAKARANLIK_BITIS + 0.001
	n.ates_yaniyor = true
	n.ates_yakit = 0.20
	n.guven.deger = 0.20      # düşük güven: arkadaş ateşi BESLEMEZ
	var i0: float = n.guven.ihmal
	for i in 400:
		n.adim(ADIM, func(_d): return "bekle")
	print("gece: ateş %s · ihmal %.3f → %.3f · sönen gece %d" % [
		"yanıyor" if n.ates_yaniyor else "SÖNDÜ", i0, n.guven.ihmal, n.ates_sondu_gece])
	if n.ates_yaniyor:
		hata.append("gece boyunca beslenmeyen ateş sönmedi")
	var artis: float = n.guven.ihmal - i0
	if not is_equal_approx(artis, A.IHMAL_ATESI_SONDURME):
		hata.append("ihmal artışı %.3f — bir kez %.3f olmalıydı (mandal çalışmıyor mu?)" % [
			artis, A.IHMAL_ATESI_SONDURME])

	# ---- 3b · AYNI GECEDE İKİ KEZ SÖNERSE İHMAL YİNE BİR KEZ ----
	# Mandalın tek işi bu. İlk yazışımda test bu senaryoyu hiç kurmuyordu ve
	# "mandalı kaldır" sabotajı YAKALANMADI — çünkü ateş söndükten sonra
	# fonksiyon zaten erken dönüyor, mandal o yolda hiç çalışmıyor. Mandalın
	# gerçekten gerektiği tek an, oyuncunun ateşi YENİDEN YAKIP bir daha
	# söndürmesi. Kural: bir gece bir kez.
	var iki = D.new()
	iki.gun = 2
	iki.t = A.ALACAKARANLIK_BITIS + 0.001
	iki.ates_yaniyor = true
	iki.ates_yakit = 0.05
	iki.odun = 3
	iki.guven.deger = 0.20
	var j0: float = iki.guven.ihmal
	for i in 400:
		iki.adim(ADIM, func(w): return "ates_yak" if not w.ates_yaniyor and w.odun > 0 else "bekle")
	print("aynı gecede %d kez söndü · ihmal %.3f → %.3f" % [
		iki.ates_sondu_gece, j0, iki.guven.ihmal])
	if iki.ates_sondu_gece < 2:
		hata.append("ÇALIŞTIRILAMADI kokusu: senaryoda ateş iki kez sönmedi (%d)" % iki.ates_sondu_gece)
	elif not is_equal_approx(iki.guven.ihmal - j0, A.IHMAL_ATESI_SONDURME):
		hata.append("aynı gecede iki sönme %.3f ihmal yazdı — bir gece BİR KEZ sayılmalı" % (iki.guven.ihmal - j0))

	# ---- 4 · HİÇ YANMAMIŞ ATEŞ SÖNMÜŞ SAYILMAZ ----
	# İlk gece ateşsiz geçiyor (K-063). O gece için ihmal yazılsaydı oyun
	# daha başlamadan borç yüklerdi.
	var ilk = D.new()
	var b0: float = ilk.guven.ihmal
	for i in 600:
		ilk.adim(ADIM, func(_d): return "bekle")
	print("1. gece (ateşsiz): ihmal %.3f → %.3f" % [b0, ilk.guven.ihmal])
	if ilk.guven.ihmal > b0 + 0.0001:
		hata.append("İHLAL: hiç yakılmamış ateş için ihmal yazıldı — ilk gece ateşsiz geçiyor")

	# ---- 5 · İLGİLENEN OYUNCU HİÇ İHMAL BİRİKTİRMEZ ----
	var iyi = D.new()
	var iyi_ihmal := 0.0
	for i in 6000:
		iyi.adim(ADIM, func(w): return _atesci(w))
		if iyi.bitti:
			break
	iyi_ihmal = float(iyi.guven.ihmal)
	print("ateşe bakan oyuncu · gün %d · sönen gece %d · ihmal %.3f" % [
		iyi.gun, iyi.ates_sondu_gece, iyi_ihmal])
	if iyi.ates_sondu_gece > 0:
		hata.append("elinden geleni yapan oyuncunun ateşi %d gece söndü — adalet ihlali" % iyi.ates_sondu_gece)

	# ---- 6 · YAKIP SONRA BIRAKAN OYUNCUNUN ATEŞİ SÖNER ----
	# İlk yazışımda senaryo "hiç odun toplamayan oyuncu"ydu ve test düştü —
	# ama KOD DOĞRUYDU: ateş hiç yakılmadığı için sönemezdi de. İhmal
	# "ateşi yakmamak" değil, "YAKTIĞIN ateşi söndürmek". Hiç ateş yakmamanın
	# cezası başka yerden gelir (gece tehdidi), ihmalden değil.
	var kotu = D.new()
	kotu.gun = 2
	kotu.t = 0.10
	kotu.odun = 2
	kotu.guven.deger = 0.20      # düşük güven: arkadaş beslemez
	var yakti := false
	for i in 4000:
		kotu.adim(ADIM, func(w):
			if not w.ates_yaniyor and w.odun > 0 and not yakti:
				return "ates_yak"
			return "bekle")
		if kotu.ates_yaniyor:
			yakti = true
		if kotu.bitti:
			break
	print("yakıp bırakan oyuncu · sönen gece %d · ihmal %.3f" % [
		kotu.ates_sondu_gece, kotu.guven.ihmal])
	if not yakti:
		hata.append("ÇALIŞTIRILAMADI kokusu: senaryoda ateş hiç yanmadı")
	elif kotu.ates_sondu_gece == 0:
		hata.append("beslenmeyen ateş hiç sönmedi — mekanik ısırmıyor")
	elif kotu.guven.ihmal < A.IHMAL_ATESI_SONDURME - 0.0001:
		hata.append("ateş söndü ama ihmal yazılmadı")

	# ---- 7 · GECE EN AZ İKİ BESLEME İSTER ----
	var say = D.new()
	say.gun = 2
	say.t = A.ALACAKARANLIK_BITIS + 0.001
	say.ates_yaniyor = true
	say.ates_yakit = A.ATES_YAKIT_TAVANI
	say.odun = 9
	say.guven.deger = 0.20
	var besleme := 0
	for i in 400:
		var onceki: int = say.odun
		say.adim(ADIM, func(w): return "yakit_at" if w.ates_yakit < A.ATES_YAKIT_ESIGI else "bekle")
		if say.odun < onceki:
			besleme += 1
	print("dolu ocakla başlayan gece: %d besleme gerekti" % besleme)
	if besleme < 1:
		hata.append("dolu ocak geceyi tek başına çıkardı — gece kalkma mekaniği yok")

	# ---- 8 · ARKADAŞ: YÜKSEK GÜVENDE BESLER, DÜŞÜKTE BESLEMEZ ----
	var yuksek := _arkadas_besledi_mi(0.80)
	var dusuk := _arkadas_besledi_mi(0.20)
	print("arkadaş ateşi besledi mi → yüksek güven %s · düşük güven %s" % [
		str(yuksek), str(dusuk)])
	if not yuksek:
		hata.append("yüksek güvende arkadaş ateşi beslemedi")
	if dusuk:
		hata.append("düşük güvende arkadaş ateşi besledi — güvenin maddi karşılığı yok")

	print("")
	if hata.is_empty():
		print("GEÇTİ — ateş ısırıyor, ama yalnızca oyuncu ilgilenmediğinde.")
		quit(0); return
	for h in hata:
		printerr("BAŞARISIZ: " + h)
	quit(1)

func _arkadas_besledi_mi(guven: float) -> bool:
	var w = D.new()
	w.gun = 2
	w.t = A.ALACAKARANLIK_BITIS + 0.001
	w.ates_yaniyor = true
	w.ates_yakit = 0.20        # eşiğin altında
	w.odun = 4
	w.guven.deger = guven
	var o0: int = w.odun
	for i in 60:
		w.adim(ADIM, func(_d): return "bekle")
	return w.odun < o0

func _atesci(w) -> String:
	# Elinden geleni yapan oyuncu: gündüz odun toplar, gece ateşi besler.
	if w.gece_mi():
		if not w.ates_yaniyor and w.odun > 0 and w.gun >= A.ATES_ILK_GUN:
			return "ates_yak"
		if w.ates_yakit < A.ATES_YAKIT_ESIGI and w.odun > 0:
			return "yakit_at"
		return "bekle"
	if not w.ates_yaniyor and w.odun > 0 and w.gun >= A.ATES_ILK_GUN:
		return "ates_yak"
	if w.odun < A.GUNLUK_ODUN_BULUNUR:
		return "odun_topla"
	if not w.kap_dolu:
		return "doldur"
	if w.oyuncu.susuzluk >= A.ESIK_HISSEDILIR:
		return "ic"
	if w.oyuncu.aclik >= A.ESIK_HISSEDILIR and w.yiyecek > 0:
		return "ye"
	if w.yiyecek < 2:
		return "topla"
	return "bekle"
