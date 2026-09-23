extends SceneTree

# 6 GÜNLÜK KOŞU — oyunun TEZİNİ ölçer, penceresiz, saniyenin altında.
#
# Tez: "sen açken yiyeceğini verdiğinde onun davranışı gözle görülür biçimde
# değişir." Bu cümle çalışmıyorsa oyun yok demektir (K-056). Grafik yapmadan
# önce burada doğrulanır.
#
# Hedefler (K-056):
#   · 6 günde 12–16 bedelli fırsat doğsun
#   · 5–6 tanesini almak yüksek güvene çıkarsın
#   · hiç almayan oyuncuda güven 3. gün ortaya, 5. gün dibe insin
#
# Çıkış: 0 geçti · 1 başarısız · 2 ÇALIŞTIRILAMADI.

const D := preload("res://betik/sim/dunya.gd")
const A := preload("res://betik/veri/ayarlar.gd")

const ADIM := 1.0 / 120.0        # günde 120 adım (20 dk ≈ 10 sn'lik dilimler)

func _initialize() -> void:
	var sonuc := {}
	for tur in ["fedakar", "dengeli", "bencil"]:
		sonuc[tur] = _kos(tur)

	print("\n=== 6 GÜNLÜK KOŞU ===")
	for tur in ["fedakar", "dengeli", "bencil"]:
		var s: Dictionary = sonuc[tur]
		print("%-9s · %2d fırsat doğdu · %2d alındı · %d ihanet · güven %.2f (%s) · moral %.2f (%s) · ihmal %.2f%s" % [
			tur, s.firsat, s.alinan, s.ihanet, s.guven, s.seviye,
			s.moral, s.moral_seviye, s.ihmal,
			"" if s.son == "" else " · " + s.son])

	var hata: Array = []
	var f: Dictionary = sonuc["fedakar"]
	var b: Dictionary = sonuc["bencil"]

	# FIRSAT SAYISI: 12–16 hedefi K-056'da TAHMİNLE konuldu ve dayandığı
	# ekonomi (kaynak yoğunluğu, yolculuk süreleri, mevsim) henüz tasarlanmadı.
	# Tahmini iddiaya çevirmek testi yalancı yapar. Bu yüzden burada yalnızca
	# TEZE YER KALIYOR MU diye bakılır; hedef bandı rapor edilir, kullanıcı
	# ekonomi tasarlandıktan sonra onaylar.
	if f.firsat < 8:
		hata.append("fırsat çok az: %d — tez sınanamıyor (en az 8 gerekir)" % f.firsat)
	var band := "hedef bandında" if f.firsat >= 12 and f.firsat <= 16 else "BAND DIŞI (K-056 hedefi 12–16, ONAYLANMAMIŞ tahmin)"
	print("fırsat bandı: %d — %s" % [f.firsat, band])
	if f.seviye != "yüksek":
		hata.append("fedakâr oyuncu yüksek güvene çıkamadı: %.2f (%s)" % [f.guven, f.seviye])
	if b.seviye != "düşük":
		hata.append("bencil oyuncuda güven düşmedi: %.2f (%s)" % [b.guven, b.seviye])
	if f.guven - b.guven < 0.5:
		hata.append("bencil ile fedakâr yeterince ayrışmadı (%.2f fark) — mekanik ölçmüyor" % (f.guven - b.guven))
	if not b.son.begins_with("arkadaş gitti"):
		hata.append("bencil oyuncuda arkadaş gitmedi — gidiş hiç tetiklenmiyor olabilir")
	# A2 değişmezi: ihmal sıfırken moral ölümcül bölgeye İNEMEZ.
	if f.ihmal <= 0.001 and f.moral < A.MORAL_ORTA_ALT - 0.001:
		hata.append("İHLAL: ihmal 0 iken moral tabanın altına indi (%.3f)" % f.moral)

	print("")
	if hata.is_empty():
		print("GEÇTİ — tez ölçülebiliyor ve mekanik ayrışıyor.")
		quit(0); return
	for h in hata:
		printerr("BAŞARISIZ: " + h)
	quit(1)

func _kos(tur: String) -> Dictionary:
	var d: Dictionary = {}
	var w = D.new()
	var sayac := 0
	while not w.bitti and sayac < 20000:
		w.adim(ADIM, func(d): return _politika(d, tur, sayac))
		sayac += 1
	return {
		"firsat": w.firsat_sayisi, "alinan": w.alinan_firsat,
		"ihanet": w.ihanet_sayisi, "guven": w.guven.deger,
		"seviye": w.guven.seviye(), "moral": w.guven.moral,
		"moral_seviye": w.guven.moral_seviye(), "ihmal": w.guven.ihmal,
		"son": ("arkadaş gitti" if w.arkadas_gitti else ("arkadaş öldü" if w.arkadas_oldu else "")),
	}

func _politika(w, tur: String, adim_no: int) -> String:
	# Üç oyuncu tipi. Hepsi hayatta kalmaya çalışır; fark YALNIZCA fırsat anında.
	if w.gece_mi():
		return "bekle"
	if not w.kap_dolu:
		return "doldur"

	var firsat: bool = w.firsat_var_mi()
	if firsat:
		match tur:
			"fedakar":
				return "ver_su" if w.arkadas.en_acil() == "su" else "ver_yiyecek"
			"dengeli":
				if int(adim_no / 60) % 2 == 0:
					return "ver_su" if w.arkadas.en_acil() == "su" else "ver_yiyecek"
			"bencil":
				pass
		# bencil (ve dengelinin sırası değilse): kendi ihtiyacını görür
		return "ic" if w.oyuncu.susuzluk >= w.oyuncu.aclik else "ye"

	# Fırsat yoksa: kendi ihtiyacını karşıla, yoksa topla
	if w.oyuncu.susuzluk >= A.ESIK_HISSEDILIR and w.kap_dolu:
		return "ic"
	if w.oyuncu.aclik >= A.ESIK_HISSEDILIR and w.yiyecek > 0:
		return "ye"
	if w.yiyecek < 2:
		return "topla"
	return "bekle"
