extends SceneTree

# ALGI KANALI (K-058) — "arkadaş yalnızca gördüğünü değerlendirir" değişmezinin
# gece davranışı. Buradaki asıl soru şu: güveni en çok kazanman gereken anda
# kanal tamamen kapalı mı?
#
# Ölçülmüştü: gece görüşü 5.4 m'ye daralıyor, düşük güvende arkadaş 7–10 m'de
# duruyor → gece yapılan hiçbir jest kaydedilmiyordu. Kullanıcı kararı: ateşin
# aydınlattığı çemberde algı gündüz gibi çalışsın.
#
# Çıkış: 0 geçti · 1 başarısız · 2 ÇALIŞTIRILAMADI.

const D := preload("res://betik/sim/dunya.gd")
const A := preload("res://betik/veri/ayarlar.gd")

func _initialize() -> void:
	var hata: Array = []
	var durumlar := [
		# ad, gece?, ateş?, oyuncu ışıkta?, arkadaş ışıkta?, mesafe, beklenen
		["gündüz · uzak",                 false, false, false, false, 10.0, true],
		["gündüz · çok uzak (menzil dışı)", false, false, false, false, 15.0, false],
		["gece · ateşsiz · uzak",          true,  false, false, false, 10.0, false],
		["gece · ateşsiz · yakın",         true,  false, false, false,  5.0, true],
		["gece · ateş · İKİSİ ışıkta",     true,  true,  true,  true,  10.0, true],
		["gece · ateş · arkadaş ışıkta DEĞİL", true, true, true, false, 10.0, false],
		["gece · ateş SÖNMÜŞ · ikisi de orada", true, false, true, true, 10.0, false],
	]
	for d in durumlar:
		var w = D.new()
		w.t = 0.85 if d[1] else 0.30      # gece 0.75+, gündüz < 0.65
		w.ates_yaniyor = d[2]
		w.oyuncu_atesin_isiginda = d[3]
		w.arkadas_atesin_isiginda = d[4]
		w.mesafe_m = d[5]
		var goruyor: bool = w.goruyor_mu()
		var isaret := "✓" if goruyor == d[6] else "✗"
		print("  %s %-38s → görüyor=%s (beklenen %s)" % [isaret, d[0], goruyor, d[6]])
		if goruyor != d[6]:
			hata.append("%s: görüyor=%s, beklenen %s" % [d[0], goruyor, d[6]])

	# Değişmez: ateş istisnası gece görüşünü GÜNDÜZ menziline çıkarır, ötesine değil.
	var w2 = D.new()
	w2.t = 0.85; w2.ates_yaniyor = true
	w2.oyuncu_atesin_isiginda = true; w2.arkadas_atesin_isiginda = true
	w2.mesafe_m = A.GORUS_MESAFESI_M + 1.0
	if w2.goruyor_mu():
		hata.append("İHLAL: ateş ışığı gündüz menzilinin ÖTESİNİ de görünür yaptı")

	print("")
	if hata.is_empty():
		print("GEÇTİ — ateş ışığı istisnası çalışıyor, menzili aşmıyor.")
		quit(0); return
	for h in hata:
		printerr("BAŞARISIZ: " + h)
	quit(1)
