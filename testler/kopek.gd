extends SceneTree

# YABAN KÖPEĞİ (K-071) — dilimin tek tehdidi.
#
# İki değişmez kural bu testin omurgası:
#
#   K-049: **arkadaş tehditten ÖLMEZ.** Hayvan yaralar, yıpratır, korkutur.
#          Ölümü ancak SENİN birikmiş davranışının sonucudur.
#   K-064: **denemek ile çekilmek aynı şey değildir.** Araya girmeye çalışıp
#          yetişememek ihanet sayılmaz.
#
# Üçüncü soru adalet: ateşe bakan oyuncu saldırıya uğramamalı. Uğrarsa
# hazırlık anlamsızlaşır ve oyunun reddettiği "kötü şans ölümü" doğar.
#
# Çıkış: 0 geçti · 1 başarısız · 2 ÇALIŞTIRILAMADI.

const D := preload("res://betik/sim/dunya.gd")
const Kp := preload("res://betik/sim/kopek.gd")
const A := preload("res://betik/veri/ayarlar.gd")
const ADIM := 1.0 / 960.0

func _initialize() -> void:
	var hata: Array = []

	# ---- 1 · UYARISIZ SALDIRI YOK ----
	var sira: Array = []
	var k := Kp.new()
	var gecen := 0.0
	while gecen < 0.2:
		var olay := k.ilerle(ADIM, true, 3, 2, false, 0.0)
		if not olay.is_empty():
			sira.append("%s@%.4f" % [olay, gecen])
		gecen += ADIM
	print("olay sırası: %s" % str(sira))
	var adlar: Array = []
	for o in sira:
		adlar.append(String(o).split("@")[0])
	if adlar.slice(0, 4) != ["uluma", "kenarda", "saldiri", "cozuldu"]:
		hata.append("olay sırası yanlış: %s — uyarı saldırıdan önce gelmeli" % str(adlar))
	# Uyarı süresi SABİTLERDEN değil, OLAYIN ZAMAN DAMGASINDAN ölçülür.
	# Sabitleri toplamak yanıltıcıydı: ulumayı sıfırlayan sabotaj yine de
	# "uluma" olayını üretiyor (durum girilirken), yalnızca hemen ardından
	# "kenarda" geliyor. Toplam sabit hâlâ eşiği geçiyordu ve sabotaj kaçtı.
	# Asıl soru şu: ilk uyarı ile saldırı ARASINDA kaç gün var?
	var ilk_uyari := -1.0
	var saldiri_ani := -1.0
	for o in sira:
		var p := String(o).split("@")
		if p[0] == "uluma":
			ilk_uyari = float(p[1])
		elif p[0] == "saldiri":
			saldiri_ani = float(p[1])
	var uyari_suresi := saldiri_ani - ilk_uyari
	print("uyarı penceresi: %.4f gün (%.0f sn, 20 dk'lık günde)" % [
		uyari_suresi, uyari_suresi * 1200.0])
	if ilk_uyari < 0.0 or saldiri_ani < 0.0:
		hata.append("uyarı ya da saldırı olayı hiç doğmadı")
	elif uyari_suresi < 0.025:
		hata.append("uyarı penceresi %.4f gün (~%.0f sn) — hazırlanmaya yetmez" % [
			uyari_suresi, uyari_suresi * 1200.0])
	# Her aşamanın kendi payı da olmalı; biri sıfırlanırsa üç fırsat ikiye iner.
	if A.KOPEK_ULUMA_SURESI < 0.008 or A.KOPEK_KENAR_SURESI < 0.008:
		hata.append("uyarı aşamalarından biri çok kısa (uluma %.4f · kenar %.4f)" % [
			A.KOPEK_ULUMA_SURESI, A.KOPEK_KENAR_SURESI])

	# ---- 2 · ATEŞ CAYDIRIR ----
	var k2 := Kp.new()
	var cekildi := false
	var saldirdi := false
	gecen = 0.0
	while gecen < 0.2:
		var olay := k2.ilerle(ADIM, true, 3, 2, true, 1.0)
		if olay == "cekildi":
			cekildi = true
		if olay == "saldiri":
			saldirdi = true
		gecen += ADIM
	print("dolu ateşte: çekildi %s · saldırdı %s" % [str(cekildi), str(saldirdi)])
	if not cekildi or saldirdi:
		hata.append("beslenen ateş köpeği caydırmadı — hazırlığın karşılığı yok")

	# Caydırma eşiği besleme eşiğinin ALTINDA olmalı; eşit ya da üstünde
	# olursa besleme ile denetim arasındaki boşlukta saldırı tetiklenir.
	if A.KOPEK_CAYDIRAN_YAKIT >= A.ATES_YAKIT_ESIGI:
		hata.append("İHLAL: caydırma eşiği (%.2f) besleme eşiğinin (%.2f) altında değil" % [
			A.KOPEK_CAYDIRAN_YAKIT, A.ATES_YAKIT_ESIGI])

	# ---- 3 · ADALET: ATEŞE BAKAN OYUNCU SALDIRI YEMEZ ----
	var iyi = D.new()
	for i in 12000:
		iyi.adim(ADIM, func(w): return _atesci(w))
		if iyi.bitti:
			break
	print("ateşe bakan oyuncu · gün %d · köpek görünme %d · saldırı %d · caydırma %d" % [
		iyi.gun, iyi.kopek.gorunme_sayisi, iyi.kopek.saldiri_sayisi, iyi.kopek.caydirma_sayisi])
	if iyi.kopek.gorunme_sayisi == 0:
		hata.append("ÇALIŞTIRILAMADI kokusu: köpek hiç görünmedi — bu senaryo bir şey ölçmedi")
	elif iyi.kopek.saldiri_sayisi > 0:
		hata.append("ateşe bakan oyuncu %d kez saldırıya uğradı — adalet ihlali" % iyi.kopek.saldiri_sayisi)

	# ---- 4 · ÜÇ SONUÇ ----
	var girdi := _saldiri(1.0, true)        # yakın + araya girdi
	# Mesafe kurtarma menzilinin DIŞINDA ama GÖRÜŞ menzilinin İÇİNDE olmalı.
	# İlk yazışımda 20 m kullandım: gece görüşü 5.4 m'ye daraldığı için
	# arkadaş hiçbir şey görmüyordu, tehlikede_birakti zaten false dönüyordu
	# ve "denedi/denemedi" ayrımını bozan sabotaj KAÇTI. Test ayrımı
	# ölçmüyordu, algıyı ölçüyordu (§5.8).
	var yetisemedi := _saldiri(4.5, true)  # 3 m'den uzak, 5.4 m'den yakın
	var girmedi := _saldiri(1.0, false)     # yakın ama girmedi
	for r in [girdi, yetisemedi, girmedi]:
		if not r["oldu_mu"]:
			hata.append("%s: saldırı hiç çözülmedi" % r["ad"])
	print("")
	for r in [girdi, yetisemedi, girmedi]:
		print("  %-22s → %s" % [r["ad"], r["ozet"]])

	# araya girdin: SEN yaralanırsın, o SAĞLAM, güven YÜKSELİR
	if not girdi["oyuncu_yarali"]:
		hata.append("araya girdin ama yaralanmadın — bedel yok")
	if girdi["arkadas_yarali"]:
		hata.append("araya girdin ama arkadaş yine yaralandı")
	if girdi["guven_fark"] <= 0.0:
		hata.append("araya girmek güveni yükseltmedi (%.3f) — 'onu tehlikeden çıkarmak' bedelli jesttir" % girdi["guven_fark"])

	# denedin yetişemedin: o yaralanır ama güven DÜŞMEZ (K-064)
	if not yetisemedi["arkadas_yarali"]:
		hata.append("yetişemedin ama arkadaş yaralanmadı")
	if yetisemedi["guven_fark"] < -0.0001:
		hata.append("İHLAL: denediği hâlde güven düştü (%.3f) — K-064" % yetisemedi["guven_fark"])
	if yetisemedi["ihmal_fark"] > 0.0001:
		hata.append("İHLAL: denediği hâlde ihmal yazıldı (%.3f) — K-064" % yetisemedi["ihmal_fark"])

	# girmedin: o yaralanır, yiyecek gider, güven düşer, ihmal yazılır
	if not girmedi["arkadas_yarali"]:
		hata.append("girmedin ama arkadaş yaralanmadı")
	if girmedi["guven_fark"] >= 0.0:
		hata.append("girmedin ama güven düşmedi (%.3f)" % girmedi["guven_fark"])
	if not is_equal_approx(girmedi["ihmal_fark"], A.IHMAL_TEHLIKEDE_BIRAKMA):
		hata.append("girmedin: ihmal %.3f — %.3f olmalıydı" % [
			girmedi["ihmal_fark"], A.IHMAL_TEHLIKEDE_BIRAKMA])
	if girmedi["yiyecek_fark"] >= 0:
		hata.append("girmedin ama yiyecek eksilmedi — 'bir balık düşer, köpek kapıp kaçar'")

	# ---- 5 · ARKADAŞ KÖPEKTEN ÖLMEZ (K-049) ----
	# GERÇEK SALDIRILARDAN geçerek. İlk yazışımda arkadas.yarala()'yı doğrudan
	# çağırıyordum, yani Dunya._kopek_saldirisini_cozumle() hiç koşmuyordu ve
	# "arkadaş köpekten ölebilsin" sabotajı KAÇTI. Kural doğruydu, DÜNYAYA
	# BAĞLI OLDUĞU doğrulanmamıştı — bu hatayı bu projede üçüncü kez yapıyorum.
	# AYNI DÜNYADA, ÜST ÜSTE GECELER. İki kez yanlış yazdım:
	#   (1) arkadas.yarala()'yı doğrudan çağırıyordum — sarmal hiç koşmuyordu;
	#   (2) düzelttim ama her saldırı için YENİ dünya kuruyordum, yani arkadaş
	#       hiçbir zaman İKİNCİ kez yaralanmıyordu. Sabotaj ("ikinci yara
	#       öldürsün") tam da o yolda saklıydı ve yine kaçtı.
	# Kural "arkadaş ölmez"; onu sınamak için önce ÖLEBİLECEĞİ duruma sokmak
	# gerekiyor — üst üste gecelerde, yarası iyileşmeden.
	var olum = D.new()
	olum.gun = 3
	olum.guven.deger = 0.50
	var yara_sayisi := 0
	var ikinci_yara := false
	for gece in 3:
		olum.t = A.ALACAKARANLIK_BITIS + 0.001
		olum.ates_yaniyor = false
		olum.ates_yakit = 0.0
		olum.yiyecek = 2
		olum.mesafe_m = 1.0
		olum.kopek.sifirla_gece()
		olum.kopek_sonucu = ""
		var zaten_yarali: bool = olum.arkadas.yarali
		var gecen2 := 0.0
		while gecen2 < 0.2 and olum.kopek_sonucu.is_empty() and not olum.bitti:
			olum.adim(ADIM, func(_d): return "bekle")
			gecen2 += ADIM
		if not olum.kopek_sonucu.is_empty():
			yara_sayisi += 1
			if zaten_yarali:
				ikinci_yara = true
		olum.gun += 1
	print("arkadaş %d gerçek saldırı yedi (yaralıyken %s) → öldü mü: %s (hayır olmalı)" % [
		yara_sayisi, "EVET" if ikinci_yara else "hayır", str(olum.arkadas.oldu)])
	if yara_sayisi < 2:
		hata.append("ÇALIŞTIRILAMADI kokusu: arkadaş yeterince saldırı yemedi (%d)" % yara_sayisi)
	if not ikinci_yara:
		hata.append("ÇALIŞTIRILAMADI kokusu: arkadaş hiç YARALIYKEN saldırı yemedi — ölüm yolu sınanmadı")
	if olum.arkadas.oldu:
		hata.append("İHLAL: arkadaş tehditten öldü — K-049, ölümü YALNIZCA ihmalden gelir")

	# ---- 6 · OYUNCU YARALIYKEN ARAYA GİRERSE ÖLEBİLİR ----
	var ikinci := _saldiri(1.0, true, true)   # oyuncu ZATEN yaralı
	print("yaralı oyuncu araya girdi → öldü mü: %s (evet olmalı)" % str(ikinci["oyuncu_oldu"]))
	if not ikinci["oyuncu_oldu"]:
		hata.append("yaralı oyuncu ikinci kez araya girdi ve ölmedi — 'yaralıyken ikincisi öldürebilir'")

	# ---- 7 · 3. GÜNDEN ÖNCE YOK ----
	var erken := Kp.new()
	var erken_olay := false
	gecen = 0.0
	while gecen < 0.2:
		if not erken.ilerle(ADIM, true, 2, 2, false, 0.0).is_empty():
			erken_olay = true
		gecen += ADIM
	if erken_olay:
		hata.append("köpek %d. günden önce göründü" % A.KOPEK_ILK_GUN)

	# ---- 8 · BİR GECEDE BİR EPİZOT ----
	var tek := Kp.new()
	gecen = 0.0
	while gecen < 0.9:
		tek.ilerle(ADIM, true, 3, 2, false, 0.0)
		gecen += ADIM
	print("bir gecede görünme sayısı: %d" % tek.gorunme_sayisi)
	if tek.gorunme_sayisi != 1:
		hata.append("bir gecede %d kez geldi — bir gece bir epizot" % tek.gorunme_sayisi)

	# ---- 9 · YARA İKİ GÜNDE İYİLEŞİR ----
	var iyilesme = D.new()
	# Ölüm yolu KAPATILIYOR: Ihtiyaclar.ilerle() ölü kişide erken dönüyor ve
	# yara sayacı da duruyor. İlk yazışımda sonda oyuncuyu kullanıyordu,
	# oyuncu 1.2 günde susuzluktan ölüyordu ve yara "iyileşmedi" görünüyordu —
	# ölçtüğüm şey yara süresi değil, ölü bir bedendi (§5.8).
	iyilesme.oyuncu.ihtiyactan_olebilir = false
	iyilesme.oyuncu.yarala()
	# SINIR MUTLAK, sabitten türetilmiyor. İlk yazışımda döngü sınırı
	# "YARA_SURESI_GUN + 0.1" idi; sabiti 99'a çıkaran sabotaj sınırı da
	# 99'a çıkarıyordu ve test yine geçiyordu. Ölçüm aracı ölçtüğü şeyin
	# sayısını kendi tutmamalı.
	const EN_COK_GUN := 3.0
	var gun_gecti := 0.0
	while gun_gecti < EN_COK_GUN and iyilesme.oyuncu.yarali:
		iyilesme.oyuncu.ilerle(ADIM, false)
		gun_gecti += ADIM
	print("yara %.2f günde iyileşti (sabit %.1f, üst sınır %.1f)" % [
		gun_gecti, A.YARA_SURESI_GUN, EN_COK_GUN])
	if iyilesme.oyuncu.yarali:
		hata.append("yara %.1f günde iyileşmedi — süresiz yara bütün oyunu belirler" % EN_COK_GUN)
	if A.YARA_SURESI_GUN < 1.0 or A.YARA_SURESI_GUN > 3.0:
		hata.append("yara süresi %.1f gün — tasarım iki gün diyor (4. gün ağır, 5. gün hafif)" % A.YARA_SURESI_GUN)

	# ---- 10 · PENCERE DIŞINDA BASMAK İŞE YARAMAZ ----
	var bos = D.new()
	bos.gun = 3
	bos.t = 0.10                       # gündüz: köpek yok
	bos.adim(ADIM, func(_d): return "araya_gir")
	if bos._araya_girdi:
		hata.append("İHLAL: saldırı yokken 'araya gir' kaydedildi — tuş basılı tutmak her saldırıyı karşılar")

	print("")
	if hata.is_empty():
		print("GEÇTİ — köpek yaralıyor ama öldürmüyor; ateş caydırıyor; denemek çekilmekten ayrı.")
		quit(0); return
	for h in hata:
		printerr("BAŞARISIZ: " + h)
	quit(1)

func _saldiri(mesafe: float, girsin: bool, oyuncu_yarali := false, gece := 3) -> Dictionary:
	# Bir gece kurar, köpeği saldırtır, sonucu ölçer.
	var w = D.new()
	w.gun = gece
	w.t = A.ALACAKARANLIK_BITIS + 0.001
	w.ates_yaniyor = false            # ateş yok: caydırma yok
	w.ates_yakit = 0.0
	w.yiyecek = 2
	w.mesafe_m = mesafe
	w.guven.deger = 0.50
	if oyuncu_yarali:
		w.oyuncu.yarala()
	var g0: float = w.guven.deger
	var i0: float = w.guven.ihmal
	var y0: int = w.yiyecek
	var oldu := false
	var gecen := 0.0
	while gecen < 0.2 and not w.bitti:
		w.adim(ADIM, func(d): return "araya_gir" if girsin and d.kopek.saldiri_penceresi_acik_mi() else "bekle")
		if not w.kopek_sonucu.is_empty():
			oldu = true
			break
		gecen += ADIM
	var ad := "girdi" if girsin else "girmedi"
	if girsin and mesafe > A.KURTARMA_MESAFESI_M:
		ad = "denedi, yetişemedi"
	return {
		"ad": ad, "ozet": w.kopek_sonucu, "oldu_mu": oldu,
		"oyuncu_yarali": w.oyuncu.yarali, "arkadas_yarali": w.arkadas.yarali,
		"oyuncu_oldu": w.oyuncu.oldu, "arkadas_oldu": w.arkadas.oldu,
		"guven_fark": w.guven.deger - g0, "ihmal_fark": w.guven.ihmal - i0,
		"yiyecek_fark": w.yiyecek - y0,
	}

func _atesci(w) -> String:
	if not w.ates_yaniyor and w.odun > 0 and w.gun >= A.ATES_ILK_GUN:
		return "ates_yak"
	if w.ates_yaniyor and w.ates_yakit < A.ATES_YAKIT_ESIGI and w.odun > 0:
		return "yakit_at"
	if w.gece_mi():
		return "bekle"
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
