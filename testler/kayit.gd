extends SceneTree

# GİDİŞ-DÖNÜŞ TESTİ (K-006) — kaydın EKSİKSİZ olduğunu kanıtlar.
#
# Yöntem: dünyayı N adım koştur, kaydet, TERTEMİZ bir dünyaya yükle, ikisini
# de aynı politikayla M adım daha koştur ve sonuçları karşılaştır. Tek bir
# alan bile unutulmuşsa iki koşu AYRIŞIR ve test düşer.
#
# Gözle "kaydediliyor gibi" bakmak bunu asla yakalamaz: unutulan alanların
# çoğu (eşik söylendi mi, günlük jest tavanı, çöküş süresi) ekranda
# görünmez — yalnızca sonraki davranışı sessizce değiştirir.
#
# Çıkış: 0 geçti · 1 başarısız · 2 ÇALIŞTIRILAMADI.

const D := preload("res://betik/sim/dunya.gd")
const K := preload("res://betik/sim/kayit.gd")
const A := preload("res://betik/veri/ayarlar.gd")
const ADIM := 1.0 / 120.0

func _initialize() -> void:
	var hata: Array = []

	# Tek senaryo yetmez. İlk yazışımda 400 adım koşup kaydediyordum ve İKİ
	# sabotaj kaçtı: "_aclik_soylendi kaydedilmiyor" ve "_cokus_suresi_gun
	# kaydedilmiyor". Sebep şuydu — o kayıt anında ikisi de zaten varsayılan
	# değerindeydi, yani yanlış kaydetmek hiçbir şeyi değiştirmiyordu.
	# Bir alanı sınamak için onu AYIRT EDİCİ bir duruma sokmak gerekir.
	_senaryo("sıradan akış", "fedakar", func(d): return d.gun >= 3, null, hata)
	_senaryo("oyuncu AÇ iken", "fedakar", func(d): return d.oyuncu._aclik_soylendi, null, hata)
	_senaryo("ÇÖKÜŞ sürerken", "bencil", func(d): return d.guven._cokus_suresi_gun > 0.0, _cokus_hazirla, hata)

	# Kipi uymayan yuva ATILMALI (eski kayıt oyunu bozmasın).
	var d2 = D.new()
	for i in 100:
		d2.adim(ADIM, func(d): return _politika(d, i, "fedakar"))
	var eski_yuva := K.topla(d2)
	eski_yuva["surum"] = K.SURUM + 1
	if K.yukle(D.new(), eski_yuva):
		hata.append("İHLAL: kipi uymayan yuva kabul edildi")

	# Dosya katmanı: yaz, oku, sil.
	var d4 = D.new()
	for i in 200:
		d4.adim(ADIM, func(d): return _politika(d, i, "fedakar"))
	if not K.yaz(d4):
		printerr("ÇALIŞTIRILAMADI: yuvaya yazılamadı"); quit(2); return
	if not K.yuva_var_mi():
		hata.append("yazıldı ama yuva yok")
	var d5 = D.new()
	if not K.oku(d5):
		hata.append("yuva okunamadı")
	else:
		_esit(d4, d5, "dosyadan okuma", hata)
	K.sil()
	if K.yuva_var_mi():
		hata.append("İHLAL: sil() sonrası yuva duruyor — ölünce kayıt kalmamalı")

	print("")
	if hata.is_empty():
		print("GEÇTİ — üç senaryoda da kayıt eksiksiz; kip denetimi ve silme çalışıyor.")
		quit(0); return
	for h in hata:
		printerr("BAŞARISIZ: " + h)
	quit(1)

func _cokus_hazirla(d) -> void:
	# Çöküş oynanışla bu sürede oluşmuyor: ihmal kanalının yalnızca 1/5'i
	# bağlı (yalnızca "gözünün önünde yiyip vermeme"). Öteki dördü —
	# çökmüşken yalnız bırakma, tehlikede bırakma, ateşi söndürme, sözü
	# tutmama — henüz dünyaya bağlanmadı (pano: açık borç).
	# Serileştirmeyi sınamak için durumu DOĞRUDAN kuruyoruz.
	d.guven.ihmal_ekle(0.9)
	for i in 200:
		d.guven.ilerle(1.0, ADIM)

func _senaryo(ad: String, tur: String, kosul: Callable, hazirlik, hata: Array) -> void:
	# Koşul sağlanana kadar koştur, KAYDET, temiz dünyaya yükle, ikisini de
	# aynı politikayla devam ettir. Tek alan bile unutulmuşsa ayrışırlar.
	var asil = D.new()
	if hazirlik is Callable:
		hazirlik.call(asil)
	var adim := 0
	while adim < 6000 and not kosul.call(asil):
		asil.adim(ADIM, func(d): return _politika(d, adim, tur))
		adim += 1
	if not kosul.call(asil):
		hata.append("%s: durum HİÇ oluşmadı — bu senaryo bir şey ölçmedi" % ad)
		return

	var kopya = D.new()
	if not K.yukle(kopya, K.topla(asil)):
		hata.append("%s: yükleme reddedildi" % ad)
		return
	# Rapor KAYIT ANININ durumunu yazar. Önce 300 adım sonrasını yazıyordum ve
	# çöküş değeri 0 görünüyordu — ölçülen an ile raporlanan an farklıydı (§5.8).
	var anlik := "  %-18s kayıt %4d. adımda · gün %d · güven %.3f · çöküş %.3f · duyum %d" % [
		ad, adim, asil.gun, asil.guven.deger, asil.guven._cokus_suresi_gun, asil.duyumlar.size()]
	_esit(asil, kopya, ad + " · yükleme anı", hata)
	for i in range(adim, adim + 300):
		asil.adim(ADIM, func(d): return _politika(d, i, tur))
		kopya.adim(ADIM, func(d): return _politika(d, i, tur))
	_esit(asil, kopya, ad + " · 300 adım sonra", hata)
	print(anlik)

func _esit(a, b, nerede: String, hata: Array) -> bool:
	var alanlar := {
		"gun": [a.gun, b.gun], "t": [a.t, b.t],
		"yiyecek": [a.yiyecek, b.yiyecek], "kap_dolu": [a.kap_dolu, b.kap_dolu],
		"firsat": [a.firsat_sayisi, b.firsat_sayisi],
		"alinan": [a.alinan_firsat, b.alinan_firsat],
		"ihanet": [a.ihanet_sayisi, b.ihanet_sayisi],
		"guven": [a.guven.deger, b.guven.deger],
		"moral": [a.guven.moral, b.guven.moral],
		"ihmal": [a.guven.ihmal, b.guven.ihmal],
		"cokus": [a.guven._cokus_suresi_gun, b.guven._cokus_suresi_gun],
		"gun_yukselis": [a.guven._gun_icinde_yukselis, b.guven._gun_icinde_yukselis],
		"o.aclik": [a.oyuncu.aclik, b.oyuncu.aclik],
		"o.susuzluk": [a.oyuncu.susuzluk, b.oyuncu.susuzluk],
		"a.aclik": [a.arkadas.aclik, b.arkadas.aclik],
		"a.susuzluk": [a.arkadas.susuzluk, b.arkadas.susuzluk],
		"duyum": [a.duyumlar.size(), b.duyumlar.size()],
		"gitti": [a.arkadas_gitti, b.arkadas_gitti],
	}
	var temiz := true
	for ad in alanlar:
		var x = alanlar[ad][0]
		var y = alanlar[ad][1]
		var ayri := false
		if typeof(x) == TYPE_FLOAT:
			ayri = absf(x - y) > 0.000001
		else:
			ayri = x != y
		if ayri:
			hata.append("%s — '%s' AYRIŞTI: %s vs %s" % [nerede, ad, str(x), str(y)])
			temiz = false
	return temiz

func _politika(w, adim_no: int, tur: String) -> String:
	if w.gece_mi():
		return "bekle"
	if not w.kap_dolu:
		return "doldur"
	if w.firsat_var_mi():
		if tur == "fedakar":
			return "ver_su" if w.arkadas.en_acil() == "su" else "ver_yiyecek"
		return "ic" if w.oyuncu.susuzluk >= w.oyuncu.aclik else "ye"
	if w.oyuncu.susuzluk >= A.ESIK_HISSEDILIR and w.kap_dolu:
		return "ic"
	if w.oyuncu.aclik >= A.ESIK_HISSEDILIR and w.yiyecek > 0:
		return "ye"
	if w.yiyecek < 2:
		return "topla"
	return "bekle"
