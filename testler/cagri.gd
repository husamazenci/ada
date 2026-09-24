extends SceneTree

# ÇAĞIRMA TESTİ (K-068).
#
# Çağrı oyunun TEK ölçüm aletidir: ilişki barı olmadığı için oyuncu güveni
# ancak seslenip ne olduğuna bakarak okur. O yüzden buradaki soru "kod
# çalışıyor mu" değil, ŞU:
#
#   Üç güven seviyesi çağrıya ÜÇ AYRI cevap veriyor mu, ve o cevapların
#   hiçbiri başka bir sebeple taklit edilebiliyor mu?
#
# Taklit yolları gerçek ve hepsi burada kapatılıyor: menzil dışında kalmak
# (duymadı), tuşa hızlı basmak (sayaç sıfırlanır), bekleme sırasında güvenin
# değişmesi, cevapsızlık penceresinin cevaptan kısa olması.
#
# Çıkış: 0 geçti · 1 başarısız · 2 ÇALIŞTIRILAMADI.

const Cg := preload("res://betik/ai/cagri.gd")
const Dv := preload("res://betik/ai/davranis.gd")
const D := preload("res://betik/sim/dunya.gd")
const A := preload("res://betik/veri/ayarlar.gd")
const Ky := preload("res://betik/sim/kayit.gd")

const YUKSEK := 0.80
const ORTA := 0.50
const DUSUK := 0.10
const KARE := 1.0 / 60.0

func _initialize() -> void:
	var hata: Array = []

	# ---- 1 · ÜÇ SEVİYE, ÜÇ AYRI CEVAP ----
	var y := _cagir_ve_olc(YUKSEK)
	var o := _cagir_ve_olc(ORTA)
	var d := _cagir_ve_olc(DUSUK)
	print("cevap süresi: yüksek %.2f sn · orta %.2f sn · düşük %s" % [
		y, o, "GELMEDİ" if d < 0.0 else "%.2f sn" % d])
	if y < 0.0:
		hata.append("yüksek güvende gelmedi")
	if o < 0.0:
		hata.append("orta güvende gelmedi")
	if d >= 0.0:
		hata.append("İHLAL: düşük güvende GELDİ — cevapsızlık oyunun en yüksek sesli işareti")

	# Gecikmeler gözle ayırt edilebilecek kadar ayrık mı? İkisi de 1 sn
	# civarında olsaydı "hemen geldi" ile "gecikti" aynı görünürdü.
	var by := Dv.cagriya_tepki_sn(YUKSEK)
	var bo := Dv.cagriya_tepki_sn(ORTA)
	if by.y >= bo.x:
		hata.append("gecikme bantları ÇAKIŞIYOR (%.1f ≥ %.1f)" % [by.y, bo.x])
	elif bo.x - by.y < 0.5:
		hata.append("yüksek↔orta gecikme farkı %.2f sn — ayırt edilemez" % (bo.x - by.y))

	# ---- 2 · "GELMEDİ" ASLA "DUYMADI" OLMAMALI ----
	# Arkadaş kendi bandında dururken her seviyede menzil İÇİNDE olmalı;
	# yoksa bir menzil hatası "arkadaş küsmüş" diye okunur.
	for g in [YUKSEK, ORTA, DUSUK]:
		var band := Dv.mesafe_bandi_m(g)
		if band.y >= A.CAGRI_MENZILI_M:
			hata.append("güven %.2f: durduğu yer (%.1f m) çağrı menzilinin (%.1f m) DIŞINDA" % [
				g, band.y, A.CAGRI_MENZILI_M])
	print("çağrı menzili %.0f m · en uzak duruş %.0f m" % [
		A.CAGRI_MENZILI_M, Dv.mesafe_bandi_m(DUSUK).y])

	# ---- 3 · SESSİZLİK EN YAVAŞ CEVAPTAN UZUN ----
	var sessizlik := Dv.cagri_sessizlik_sn()
	if sessizlik <= bo.y:
		hata.append("sessizlik %.1f sn ≤ en yavaş cevap %.1f sn — orta güven 'gelmiyor' diye okunur" % [
			sessizlik, bo.y])
	print("sessizlik %.1f sn · en yavaş cevap %.1f sn" % [sessizlik, bo.y])

	# ---- 4 · ÇAĞIRMAK GÜVENE DOKUNMAZ ----
	# Yükseltmemeli (ucuz jest), düşürmemeli de (okumak cezalandırılmaz).
	var w = D.new()
	for i in 120:
		w.adim(1.0 / 240.0, func(_d): return _yasat(w))
	# §5.8: ölçmek istediğim şeyi mi ölçüyorum? İlk yazışımda 600 adım
	# koşturuyordum ve politika hiç su içmiyordu — oyuncu susuzluktan ÖLÜYOR,
	# dünya bitiyor, cagri_ilerle her kareyi kes() ile karşılıyordu. Test
	# "soğuma kilitliyor" diye düştü; oysa ölçülen şey ölü bir dünyaydı.
	if w.bitti:
		printerr("ÇALIŞTIRILAMADI: ısınma koşusunda dünya bitti (%s)" % w.bitis_sebebi)
		quit(2); return
	var g0: float = w.guven.deger
	var m0: float = w.guven.moral
	var i0: float = w.guven.ihmal
	for i in 3000:
		w.cagir()
		w.cagri_ilerle(KARE)
	print("50× çağrı sonrası: güven %.4f→%.4f · moral %.4f→%.4f · ihmal %.4f→%.4f" % [
		g0, w.guven.deger, m0, w.guven.moral, i0, w.guven.ihmal])
	if absf(w.guven.deger - g0) > 0.000001:
		hata.append("İHLAL: çağırmak güveni DEĞİŞTİRDİ (%.4f → %.4f)" % [g0, w.guven.deger])
	if absf(w.guven.ihmal - i0) > 0.000001:
		hata.append("İHLAL: çağırmak ihmali değiştirdi")
	if w.cagri.cagri_sayisi < 2:
		hata.append("3000 karede %d çağrı çıktı — soğuma çağrıyı tamamen kilitliyor" % w.cagri.cagri_sayisi)

	# ---- 5 · TUŞA BASMAYA DEVAM ETMEK GELİŞİ ENGELLEMEZ ----
	# En sinsi hata bu olurdu: her çağrı sayacı sıfırlasaydı sabırsız oyuncu
	# asla cevap alamaz, bunu "düşük güven" sanır ve oyunun kalbi yalan söyler.
	var c := Cg.new()
	c.cagir(YUKSEK, true)
	var kare := 0
	while c.durum != Cg.GELIYOR and kare < 600:
		c.cagir(YUKSEK, true)          # her karede yine bas
		c.ilerle(KARE)
		kare += 1
	var surekli_basarak := kare * KARE
	print("her karede tuşa basarak: %.2f sn'de geldi (band %.1f–%.1f)" % [
		surekli_basarak, by.x, by.y])
	if c.durum != Cg.GELIYOR:
		hata.append("İHLAL: tuşa basmaya devam edince HİÇ gelmedi — sayaç sıfırlanıyor")
	elif surekli_basarak > by.y + 0.1:
		hata.append("tuşa basmaya devam etmek gelişi geciktirdi (%.2f sn > %.2f)" % [
			surekli_basarak, by.y])

	# ---- 6 · CEVAP MESAFESİ HÂLÂ GÜVENİ OKUR ----
	# Çağrı herkesi aynı noktaya getirseydi mesafe güveni değil "en son ne
	# zaman seslendin"i okurdu.
	var hy := Dv.cagri_hedef_mesafe_m(YUKSEK)
	var ho := Dv.cagri_hedef_mesafe_m(ORTA)
	var hd := Dv.cagri_hedef_mesafe_m(DUSUK)
	print("cevap mesafesi: yüksek %.1f m · orta %.1f m · düşük %.1f m" % [hy, ho, hd])
	if ho - hy < 1.0 or hd - ho < 1.0:
		hata.append("cevap mesafeleri ayrışmıyor: %.1f / %.1f / %.1f" % [hy, ho, hd])
	for g in [YUKSEK, ORTA, DUSUK]:
		var band := Dv.mesafe_bandi_m(g)
		var h := Dv.cagri_hedef_mesafe_m(g)
		if h < band.x - 0.001 or h > band.y + 0.001:
			hata.append("güven %.2f: cevap mesafesi %.1f m KENDİ bandının (%.1f–%.1f) dışına çıkıyor" % [
				g, h, band.x, band.y])

	# ---- 7 · KARAR ÇAĞRI ANINDA DONAR ----
	# Yüksek güvenle çağır, beklerken güveni dibe indir: yine de gelmeli.
	# Yoksa gecikme hiçbir şey anlatmaz, son karenin güvenini anlatır.
	var c2 := Cg.new()
	c2.cagir(YUKSEK, true)
	for i in 200:
		c2.ilerle(KARE)
		if c2.durum == Cg.GELIYOR:
			break
	if c2.durum != Cg.GELIYOR:
		hata.append("İHLAL: çağrı anındaki karar korunmadı — bekleme sırasında iptal oldu")

	# ---- 8 · KARAR VERDİ AMA KALKAMADI (moral kanalı) ----
	# Yüksek güven + dip moral: gelmeye karar eder, çöken beden kalkamaz.
	var c3 := Cg.new()
	c3.cagir(YUKSEK, true)
	for i in 600:
		c3.ilerle(KARE, false)          # gelebiliyor_mu = false
	if c3.yanitlanan != 0:
		hata.append("İHLAL: çökmüş beden çağrıya YÜRÜDÜ — moral kanalı bağlı değil")
	if c3.yanitsiz != 1:
		hata.append("çökmüş bedenin cevapsızlığı sayılmadı (yanıtsız %d)" % c3.yanitsiz)

	# ---- 8b · AYNI ŞEY, SARMALIN İÇİNDEN ----
	# 8. madde saf makineyi doğrudan çağırıyordu ve Dunya.cagri_ilerle'yi HİÇ
	# geçmiyordu: negatif kontrol "çökmüş beden çağrıya yürüyor" sabotajını
	# uyguladığında test yine GEÇTİ. Yani ölçtüğüm şey ölçmek istediğim şey
	# değildi (§5.8) — kuralın kendisi doğruydu, DÜNYAYA BAĞLI OLDUĞU
	# doğrulanmamıştı. Burası o bağı sınar.
	var wc = D.new()
	wc.guven.deger = YUKSEK
	wc.guven.ihmal_ekle(0.9)
	for i in 400:
		wc.guven.ilerle(1.0, 1.0 / 240.0)
	if not Dv.oturuyor_mu(wc.guven.moral):
		hata.append("ÇALIŞTIRILAMADI kokusu: çöküş kurulamadı (moral %.3f)" % wc.guven.moral)
	else:
		wc.cagir()
		for i in 900:
			wc.cagri_ilerle(KARE)
		print("çökmüş beden · moral %.3f · yanıtlanan %d · yanıtsız %d" % [
			wc.guven.moral, wc.cagri.yanitlanan, wc.cagri.yanitsiz])
		if wc.cagri.yanitlanan != 0:
			hata.append("İHLAL: dünyada çökmüş beden çağrıya YÜRÜDÜ — moral kanalı köprüde bağlı değil")

	# ---- 9 · MENZİL DIŞI: AYRI SAYILIR ----
	var c4 := Cg.new()
	c4.cagir(YUKSEK, false)
	if c4.duyulmayan != 1:
		hata.append("menzil dışı çağrı ayrı sayılmadı")
	if c4.yanitsiz != 0:
		hata.append("İHLAL: duyulmayan çağrı REDDETME diye sayıldı — menzil hatası küsme gibi okunur")
	if c4.mesgul_mu():
		hata.append("duyulmayan çağrı durum makinesini meşgul etti")

	# ---- 10 · CEVAP PENCERESİ KAPANIR ----
	var c5 := Cg.new()
	c5.cagir(YUKSEK, true)
	var toplam := 0.0
	while c5.durum != Cg.YOK and toplam < 60.0:
		c5.ilerle(KARE)
		toplam += KARE
	if c5.durum != Cg.YOK:
		hata.append("İHLAL: cevap penceresi hiç kapanmadı — tek çağrı mesafeyi kalıcı değiştirir")
	print("cevap penceresi %.1f sn sonra kapandı" % toplam)

	# ---- 11 · GİDEN/ÖLEN ARKADAŞ ÇAĞRIYI KESER ----
	var w2 = D.new()
	w2.cagir()
	w2.arkadas_gitti = true
	w2.cagri_ilerle(KARE)
	if w2.cagri.mesgul_mu():
		hata.append("İHLAL: giden arkadaş hâlâ çağrıya cevap veriyor")
	if w2.duyar_mi():
		hata.append("İHLAL: giden arkadaş hâlâ çağrıyı duyuyor")

	# ---- 12 · YÜKLENEN OYUNDA BEKLEYEN ÇAĞRI OLMAZ ----
	# Askıya alma dünyayı sürdürür, ANI değil: dünkü bağırışa hâlâ yürüyen bir
	# arkadaşla uyanmak yanlış olur. kayit.gd bunu bilerek kaydetmiyor; burası
	# o kararın gerçekten uygulandığını kanıtlar (yoksa "unutulmuş alan" ile
	# "verilmiş karar" ayırt edilemez).
	var w3 = D.new()
	w3.cagir()
	w3.cagri_ilerle(KARE)
	if not w3.cagri.mesgul_mu():
		hata.append("ÇALIŞTIRILAMADI kokusu: kaydedilecek dünyada bekleyen çağrı yok")
	var w4 = D.new()
	if not Ky.yukle(w4, Ky.topla(w3)):
		hata.append("yükleme reddedildi")
	elif w4.cagri.mesgul_mu():
		hata.append("İHLAL: yüklenen oyunda dünkü çağrı hâlâ bekliyor")

	print("")
	if hata.is_empty():
		print("GEÇTİ — üç seviye üç ayrı cevap veriyor; 'gelmedi' taklit edilemiyor.")
		quit(0); return
	for h in hata:
		printerr("BAŞARISIZ: " + h)
	quit(1)

func _yasat(w) -> String:
	# Isınma koşusunun tek işi güveni/morali oynatmak; oyuncuyu öldürmemeli.
	if not w.kap_dolu:
		return "doldur"
	if w.oyuncu.susuzluk >= A.ESIK_HISSEDILIR:
		return "ic"
	if w.oyuncu.aclik >= A.ESIK_HISSEDILIR and w.yiyecek > 0:
		return "ye"
	return "bekle"

func _cagir_ve_olc(guven: float) -> float:
	# Cevap kaç saniyede geldi? Gelmediyse −1.
	var c := Cg.new()
	if not c.cagir(guven, true):
		return -2.0
	var gecen := 0.0
	while gecen < 30.0:
		c.ilerle(KARE)
		gecen += KARE
		if c.durum == Cg.GELIYOR:
			return gecen
		if c.durum == Cg.YOK:
			return -1.0
	return -1.0
