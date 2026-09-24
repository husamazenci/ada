extends SceneTree

# A2 DEĞİŞMEZİ (K-055) — bu oyunun en önemli tek kuralı burada sınanır.
#
# "Arkadaş tehditten ÖLMEZ, senin yüzünden ölür." Eski tasarımda bu cümle
# kendi kendisiyle çelişiyordu: koşullar morali düşürüyordu, düşük moral
# öldürüyordu, yani arkadaş koşullardan ölüyordu — "kötü şans ölümü".
#
# Düzeltme tek satır:  taban = MORAL_ORTA_ALT × (1 − ihmal)
# İhmal 0 iken moral, koşullar ne kadar ağır olursa olsun ölümcül bölgeye
# İNEMEZ. Altı günlük koşu bunu ölçemez (fedakâr oyuncuda moral zaten tabana
# yaklaşmıyor); bu yüzden değişmezin kendi testi var.
#
# Çıkış: 0 geçti · 1 başarısız · 2 ÇALIŞTIRILAMADI.

const A := preload("res://betik/veri/ayarlar.gd")
const Gv := preload("res://betik/ai/guven.gd")
const D := preload("res://betik/sim/dunya.gd")

const EPS := 0.0005
const GUN_KESRI := 1.0 / 120.0

func _initialize() -> void:
	var hata: Array = []

	# 1 · İhmal YOKKEN, koşullar cehennem olsa bile moral taban altına inemez.
	var g1 := Gv.new()
	_ez(g1, 1.0, 10)     # 10 gün boyunca azami koşul baskısı
	print("ihmal 0.00 · 10 gün azami baskı → moral %.4f (taban %.4f)" % [g1.moral, g1.moral_tabani()])
	if g1.moral < A.MORAL_ORTA_ALT - EPS:
		hata.append("İHLAL: ihmal 0 iken moral tabanın altına indi (%.4f < %.4f)" % [g1.moral, A.MORAL_ORTA_ALT])
	if g1.cokuyor_mu():
		hata.append("İHLAL: ihmal 0 iken çöküş başladı")
	if g1.olebilir_mi(99):
		hata.append("İHLAL: ihmal 0 iken arkadaş ölebiliyor — kötü şans ölümü geri geldi")

	# 2 · İhmal TAMKEN moral dibe inebilmeli, yoksa mekanizma hiç çalışmıyordur.
	var g2 := Gv.new()
	g2.ihmal_ekle(1.0)
	_ez(g2, 1.0, 10)
	print("ihmal 1.00 · 10 gün azami baskı → moral %.4f (taban %.4f)" % [g2.moral, g2.moral_tabani()])
	if g2.moral > A.MORAL_COKUS_ESIGI:
		hata.append("ihmal 1 iken moral çöküş eşiğine inemedi (%.4f) — ölüm hiç mümkün değil" % g2.moral)

	# 3 · Ara değer: taban gerçekten ihmalle ölçekleniyor mu?
	var g3 := Gv.new()
	g3.ihmal_ekle(0.5)
	_ez(g3, 1.0, 10)
	var beklenen := A.MORAL_ORTA_ALT * 0.5
	print("ihmal 0.50 · 10 gün azami baskı → moral %.4f (beklenen taban %.4f)" % [g3.moral, beklenen])
	if absf(g3.moral - beklenen) > 0.01:
		hata.append("taban ihmalle ölçeklenmiyor: %.4f, beklenen %.4f" % [g3.moral, beklenen])

	# 4 · Ölüm en erken 6. gün (K-055): çöküş yeterince uzun sürse bile önce OLMAZ.
	var g4 := Gv.new()
	g4.ihmal_ekle(1.0)
	_ez(g4, 1.0, 10)
	if g4.olebilir_mi(5):
		hata.append("İHLAL: 5. günde ölüm mümkün oldu — en erken 6. gün olmalı")
	if not g4.olebilir_mi(6):
		hata.append("6. günde ölüm mümkün değil — çöküş hiç tamamlanmıyor")

	# 5 · Kısa çöküş öldürmemeli: müdahale penceresi gerçekten var mı?
	var g5 := Gv.new()
	g5.ihmal_ekle(1.0)
	_ez(g5, 1.0, 1)      # yalnızca 1 gün — COKUS_EN_AZ_GUN = 2
	if g5.olebilir_mi(6):
		hata.append("İHLAL: tek günlük çöküş öldürdü — 'defalarca müdahale fırsatı' kuralı çiğneniyor")

	# 6 · İKİNCİ ÖLÜM YOLU KAPALI OLMALI (K-062).
	# Arkadaş açlık/susuzluk sayacı 1.0'a vurunca ölebiliyordu; bu, görünür
	# çöküşü, iki günlük müdahale penceresini ve "en erken 6. gün" kuralını
	# TAMAMEN atlıyordu. Kıtlık gerçekten ısırmaya başlayınca ortaya çıktı.
	var w = D.new()
	if w.arkadas.ihtiyactan_olebilir:
		hata.append("İHLAL: arkadaş ihtiyaçtan ölebiliyor — çöküş sistemi atlanır")
	if not w.oyuncu.ihtiyactan_olebilir:
		hata.append("oyuncu ihtiyaçtan ölemiyor — oyuncunun ölümü hiç mümkün olmaz")
	w.arkadas.aclik = 1.0
	w.arkadas.susuzluk = 1.0
	w.arkadas.ilerle(0.5, false)
	if w.arkadas.oldu:
		hata.append("İHLAL: arkadaş açlık/susuzluktan ÖLDÜ — ani ölüm yolu hâlâ açık")
	print("arkadaş açlık 1.00 · susuzluk 1.00 → öldü mü: %s (hayır olmalı)" % w.arkadas.oldu)

	# 7 · "Denedi ama yetişemedi" ihanet SAYILMAZ (K-064).
	var d1 := Gv.new(); var d2 := Gv.new(); var d3 := Gv.new()
	var bas := d1.deger
	d1.tehlikede_birakti(true, true)     # gördü, denedi → ceza yok
	d2.tehlikede_birakti(true, false)    # gördü, denemedi → ceza
	d3.tehlikede_birakti(false, false)   # görmedi → ceza yok
	print("tehlikede bırakma → denedi %.2f · denemedi %.2f · görmedi %.2f (başlangıç %.2f)" % [
		d1.deger, d2.deger, d3.deger, bas])
	if d1.deger < bas:
		hata.append("İHLAL: denediği hâlde yetişemeyen oyuncu cezalandırıldı")
	if d2.deger >= bas:
		hata.append("bilerek bırakma cezalandırılmadı — ayrım hiç çalışmıyor")
	if d3.deger < bas:
		hata.append("İHLAL: görmediği bir şey için cezalandırdı (algı dürüstlüğü)")
	if d2.ihmal <= 0.0:
		hata.append("bilerek bırakma ihmal üretmedi — ikinci kaynak bağlanmamış")

	print("")
	if hata.is_empty():
		print("GEÇTİ — A2 değişmezi tutuyor: arkadaş koşullardan ölemiyor.")
		quit(0); return
	for h in hata:
		printerr("BAŞARISIZ: " + h)
	quit(1)

func _ez(g, baski: float, gun_sayisi: int) -> void:
	for i in range(gun_sayisi * 120):
		g.ilerle(baski, GUN_KESRI)
