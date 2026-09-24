extends SceneTree

# "BEKLE" SÖZÜ (K-072) — ihmalin BEŞİNCİ ve son kaynağı.
#
# Söz basit: "orada kal, döneceğim". Tutmak dönmek demek.
#
# Buradaki asıl sorular üç tane ve hepsi kural sorusu:
#
#   1. TUTMANIN ÖDÜLÜ VAR MI? Olmamalı. Dönmek jestin kendisi değil asgarisi;
#      ödüllendirilseydi oyuncu söz verip dönerek güven çiftliği kurardı ve
#      "ucuz jest yükseltmez" (§2) delinirdi.
#   2. TUTMAK MÜMKÜN MÜ? Sözün ömrü gidip dönmeye yetmeli, yoksa ceza
#      davranışa değil saate bağlanır.
#   3. SÖZ TÜRÜ AÇILDI MI? Açılmamalı: "bekle" çağrının çeşidi (kullanıcı
#      kararı). Kapalı liste yalnızca çağrı ve soru içermeli.
#
# Çıkış: 0 geçti · 1 başarısız · 2 ÇALIŞTIRILAMADI.

const D := preload("res://betik/sim/dunya.gd")
const A := preload("res://betik/veri/ayarlar.gd")
const Sz := preload("res://betik/veri/sozler.gd")
const ADIM := 1.0 / 960.0

func _initialize() -> void:
	var hata: Array = []

	# ---- 1 · SÖZ TÜRÜ AÇILMADI ----
	for h in Sz.dogrula():
		hata.append("sozler.gd: " + h)
	var bekle_turu := ""
	for s in Sz.SOZLER:
		if s["anahtar"] == "soz.bekle":
			bekle_turu = s["tur"]
	print("'soz.bekle' türü: '%s' · kapalı liste: %s" % [bekle_turu, str(Sz.TURLER)])
	if bekle_turu.is_empty():
		hata.append("'soz.bekle' söz listesinde yok")
	elif bekle_turu != "cagri":
		hata.append("'soz.bekle' türü '%s' — çağrının ÇEŞİDİ olmalıydı (K-072)" % bekle_turu)
	if Sz.TURLER.size() != 2:
		hata.append("söz türü sayısı %d — kapalı liste iki tür içermeli (çağrı, soru)" % Sz.TURLER.size())

	# ---- 2 · ADALET: TUTMAK MÜMKÜN OLMALI ----
	# Sözün ömrü, ışığın kenarına gidip dönmeye yetmeli. 1.6 m/s yürüyüşle.
	var sn := A.SOZ_SURESI_GUN * 1200.0          # 20 dk'lık günde
	var menzil_m := sn * 1.6 * 0.5               # gidiş-dönüş
	print("söz ömrü %.3f gün (~%.0f sn) → ~%.0f m gidiş-dönüş" % [A.SOZ_SURESI_GUN, sn, menzil_m])
	if menzil_m < A.CAGRI_MENZILI_M:
		hata.append("söz ömrü %.0f m'lik gidiş-dönüşe yetiyor ama çağrı menzili %.0f m — ceza mesafeye değil SAATE bağlanır" % [
			menzil_m, A.CAGRI_MENZILI_M])

	# ---- 3 · GİDİP DÖNMEK: SÖZ TUTULUR, GÜVEN DEĞİŞMEZ ----
	var d = _kur()
	var g0: float = d.guven.deger
	var i0: float = d.guven.ihmal
	d.adim(ADIM, func(_w): return "bekle_de")
	if not d.soz_bekle:
		hata.append("ÇALIŞTIRILAMADI kokusu: söz hiç verilmedi")
	# SÖZ VERİLİR VERİLMEZ KAPANMAMALI. Oyuncu zaten yanında duruyor; uzaklaşma
	# mandalı olmasaydı söz daha ağzından çıkarken "tutuldu" sayılırdı ve hiçbir
	# şey ifade etmezdi. İlk yazışımda bunu hiçbir madde ölçmüyordu: mandalı
	# kaldıran sabotaj testi düşürmedi, çünkü sonuç ("tutuldu 1") ikisinde de
	# aynıydı. Ölçülmesi gereken şey SONUÇ değil, sözün ARADA AÇIK KALDIĞI.
	for i in 10:
		d.adim(ADIM, func(_w): return "bekle")
	print("yanı başında 10 adım → söz hâlâ açık mı: %s (evet olmalı) · tutuldu %d" % [
		str(d.soz_bekle), d.soz_tutuldu])
	if not d.soz_bekle or d.soz_tutuldu > 0:
		hata.append("İHLAL: söz, oyuncu hiç gitmeden kapandı — uzaklaşma mandalı yok, söz anlamsız")
	d.mesafe_m = 15.0                            # gittin
	for i in 40:
		d.adim(ADIM, func(_w): return "bekle")
	d.mesafe_m = 2.0                             # döndün
	for i in 5:
		d.adim(ADIM, func(_w): return "bekle")
	print("gidip döndün → tutuldu %d · tutulmadı %d · güven %.3f→%.3f · ihmal %.3f→%.3f" % [
		d.soz_tutuldu, d.soz_tutulmadi, g0, d.guven.deger, i0, d.guven.ihmal])
	if d.soz_tutuldu != 1:
		hata.append("gidip dönmek sözü tutmuş saymadı")
	if d.soz_bekle:
		hata.append("dönüşte söz kapanmadı")
	if absf(d.guven.deger - g0) > 0.000001:
		hata.append("İHLAL: sözü tutmak güveni DEĞİŞTİRDİ (%.3f→%.3f) — dönmek asgaridir, jest değil" % [g0, d.guven.deger])
	if absf(d.guven.ihmal - i0) > 0.000001:
		hata.append("sözü tutmak ihmali değiştirdi")

	# ---- 4 · DÖNMEMEK: İHMAL VE GÜVEN DÜŞÜŞÜ ----
	var e = _kur()
	var g1: float = e.guven.deger
	var i1: float = e.guven.ihmal
	e.adim(ADIM, func(_w): return "bekle_de")
	e.mesafe_m = 15.0
	var sayac := 0
	while e.soz_bekle and sayac < 2000:
		e.adim(ADIM, func(_w): return "bekle")
		sayac += 1
	print("dönmedin → tutulmadı %d · güven %.3f→%.3f · ihmal %.3f→%.3f" % [
		e.soz_tutulmadi, g1, e.guven.deger, i1, e.guven.ihmal])
	if e.soz_tutulmadi != 1:
		hata.append("dönmemek sözü bozmuş saymadı")
	if not is_equal_approx(e.guven.ihmal - i1, A.IHMAL_SOZ_TUTMAMA):
		hata.append("ihmal %.3f — %.3f olmalıydı" % [e.guven.ihmal - i1, A.IHMAL_SOZ_TUTMAMA])
	if e.guven.deger >= g1:
		hata.append("sözü bozmak güveni düşürmedi (%.3f→%.3f)" % [g1, e.guven.deger])

	# ---- 5 · HİÇ GİTMEDİYSEN SÖZ BOZULMAZ ----
	# Yanı başında kalan oyuncu sözü zaten tutuyor. Mandal olmasaydı ya
	# anında "tuttu" sayılırdı (söz anlamsız), ya da süre dolunca "bozdu"
	# sayılırdı (hiç gitmemişken ceza).
	var f = _kur()
	var i2: float = f.guven.ihmal
	f.adim(ADIM, func(_w): return "bekle_de")
	sayac = 0
	while f.soz_bekle and sayac < 2000:
		f.adim(ADIM, func(_w): return "bekle")
		sayac += 1
	print("hiç gitmedin → tutuldu %d · tutulmadı %d · ihmal %.3f→%.3f" % [
		f.soz_tutuldu, f.soz_tutulmadi, i2, f.guven.ihmal])
	if f.soz_tutulmadi > 0:
		hata.append("İHLAL: hiç gitmeyen oyuncu söz bozmuş sayıldı")
	if f.guven.ihmal > i2 + 0.0001:
		hata.append("hiç gitmeyen oyuncuya ihmal yazıldı")

	# ---- 6 · DUYULMAYAN SÖZ VERİLEMEZ ----
	# Verilmemiş bir sözden ceza yenmesin.
	var uzak = _kur()
	uzak.mesafe_m = A.CAGRI_MENZILI_M + 10.0
	uzak.adim(ADIM, func(_w): return "bekle_de")
	print("menzil dışında 'bekle' → söz açıldı mı: %s (hayır olmalı)" % str(uzak.soz_bekle))
	if uzak.soz_bekle:
		hata.append("İHLAL: duyulmayan söz kabul edildi — oyuncu vermediği sözden ceza yer")

	# ---- 7 · GÜN DÖNÜNCE AÇIK SÖZ TUTULMAMIŞ SAYILIR ----
	var gece = _kur()
	gece.t = 0.999
	var i3: float = gece.guven.ihmal
	gece.adim(ADIM, func(_w): return "bekle_de")
	gece.mesafe_m = 15.0
	for i in 5:
		gece.adim(ADIM, func(_w): return "bekle")
	print("gün dönerken açık söz → tutulmadı %d · ihmal %.3f→%.3f" % [
		gece.soz_tutulmadi, i3, gece.guven.ihmal])
	if gece.soz_tutulmadi != 1:
		hata.append("gün dönerken açık kalan söz tutulmamış sayılmadı")

	# ---- 8 · İKİNCİ SÖZ BİRİNCİYİ EZMEZ ----
	var iki = _kur()
	iki.adim(ADIM, func(_w): return "bekle_de")
	var kalan1: float = iki._soz_kalan
	iki.mesafe_m = 15.0
	for i in 20:
		iki.adim(ADIM, func(_w): return "bekle_de")
	print("söz açıkken tekrar 'bekle' → kalan %.4f → %.4f (azalmalı)" % [kalan1, iki._soz_kalan])
	if iki._soz_kalan >= kalan1:
		hata.append("İHLAL: tekrar 'bekle' demek sayacı sıfırlıyor — oyuncu sözü sonsuza kadar erteler")

	print("")
	if hata.is_empty():
		print("GEÇTİ — söz tutulabiliyor, tutmanın ödülü yok, bozmanın bedeli var.")
		quit(0); return
	for h in hata:
		printerr("BAŞARISIZ: " + h)
	quit(1)

func _kur():
	var w = D.new()
	w.gun = 3
	w.t = 0.30                    # gündüz: köpek karışmasın (§5.7)
	w.mesafe_m = 2.0
	w.guven.deger = 0.50
	return w
