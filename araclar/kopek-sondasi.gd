extends SceneTree

# KÖPEK SONDASI: gece köpeği ışığın sınırında mı duruyor, saldırırken
# çemberi terk ediyor mu? Tasarımın tek cümlesi ("ışığın sınırında durur,
# yaklaşmaz") ekranda ölçülüyor.
#
# Sonda SİMÜLASYONU sürer, düğümü değil: köprü her kare düğümün üzerine
# yazıyor, o yüzden düğüme yazmak hiçbir şey yapmıyordu (ilk koşuda köpek
# "kenarda" denmesine rağmen görünmedi). Simülasyondan sürmek aynı zamanda
# zincirin TAMAMINI sınıyor.
#
# --headless ile ÇALIŞMAZ. Çıkış: 0 · 1 · 2.

const A := preload("res://betik/veri/ayarlar.gd")
const Kp := preload("res://betik/sim/kopek.gd")

var _o: Node3D
var _kopek: Node3D
var _ates: Node3D
var _b := 0
var _asama := 0
var _en_yakin := 999.0
var _oyuncu: Node3D

func _initialize() -> void:
	root.add_child(load("res://sahne/dunya.tscn").instantiate())

func _mesafe_ates() -> float:
	var d := _kopek.global_position - _ates.global_position
	d.y = 0.0
	return d.length()

func _process(_dt: float) -> bool:
	if _o == null:
		_o = root.find_child("Dunya", true, false)
		_kopek = root.find_child("Kopek", true, false)
		_oyuncu = root.find_child("Oyuncu", true, false)
		_ates = root.find_child("Ates", true, false)
		if _o == null or _kopek == null or _ates == null:
			printerr("ÇALIŞTIRILAMADI: Dunya/Kopek/Ates bulunamadı"); quit(2); return true
		_o.set("zaman_carpani", 0.001)
		return false
	# Gece, ateş zayıf: köpek gelsin
	_o.sim.gun = 3
	_o.sim.t = 0.85
	_o.sim.ates_yaniyor = true
	_o.sim.ates_yakit = 0.10        # caydırma eşiğinin altında
	_b += 1

	# KAMERAYI KÖPEĞE ÇEVİR. İlk koşuda sayı doğruydu (6.00 m) ama kadrajda
	# köpek YOKTU — kamera başka yöne bakıyordu. Ölçüp görüntü almamak, ya da
	# görüntüye bakmadan "oldu" demek, bu projenin en pahalı hata ailesi (§7).
	if _oyuncu and _kopek:
		var bak: Vector3 = _kopek.global_position - _oyuncu.global_position
		bak.y = 0.0
		if bak.length() > 0.1:
			_oyuncu.rotation.y = atan2(-bak.x, -bak.z)

	match _asama:
		0:   # kenarda dur
			_o.sim.kopek.durum = Kp.KENARDA
			if _b > 240:
				_en_yakin = minf(_en_yakin, _mesafe_ates())
			if _b >= 480:
				RenderingServer.force_draw()
				root.get_texture().get_image().save_png("res://.scratch/kopek-kenarda.png")
				print("KENARDA · ateşe uzaklık %.2f m (ışık yarıçapı %.1f m) · görünür %s" % [
					_mesafe_ates(), A.ATES_ISIK_YARICAPI_M, str(_kopek.visible)])
				if not _kopek.visible:
					printerr("BAŞARISIZ: kenardayken görünmüyor"); quit(1); return true
				if _mesafe_ates() < A.ATES_ISIK_YARICAPI_M - 0.5:
					printerr("BAŞARISIZ: köpek ışık çemberinin İÇİNE girdi (%.2f m < %.1f m)" % [
						_mesafe_ates(), A.ATES_ISIK_YARICAPI_M])
					quit(1); return true
				_b = 0
				_asama = 1
		1:   # saldır
			_o.sim.kopek.durum = Kp.SALDIRIYOR
			if _b >= 300:
				RenderingServer.force_draw()
				root.get_texture().get_image().save_png("res://.scratch/kopek-saldiri.png")
				var ark := root.find_child("Arkadas", true, false)
				var d: Vector3 = _kopek.global_position - ark.global_position
				d.y = 0.0
				print("SALDIRI · arkadaşa uzaklık %.2f m · ateşe %.2f m" % [d.length(), _mesafe_ates()])
				if d.length() > 2.5:
					printerr("BAŞARISIZ: saldırırken arkadaşa yaklaşmadı (%.2f m)" % d.length())
					quit(1); return true
				_b = 0
				_asama = 2
		2:   # kaybol
			_o.sim.kopek.durum = Kp.YOK
			if _b >= 60:
				print("YOK · görünür %s (gizlenmeli)" % str(_kopek.visible))
				if _kopek.visible:
					printerr("BAŞARISIZ: köpek yokken hâlâ görünüyor"); quit(1); return true
				quit(0); return true
	return false
