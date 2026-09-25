extends SceneTree

# NEFES SONDASI: çökmüş ama CANLI beden kıpırdıyor mu, ÖLÜ beden duruyor mu?
#
# Tasarım çöküşün günlerce sürmesini ve oyuncunun defalarca müdahale şansı
# olmasını istiyor (K-049). O pencere ancak "çökmüş ama yaşıyor" ile "öldü"
# EKRANDA ayrılabiliyorsa vardır. Ölçü basit: iki kare arasındaki piksel
# farkı. Canlıda > 0, ölüde = 0.
#
# --headless ile ÇALIŞMAZ. Çıkış: 0 · 1 · 2.

var _o: Node3D
var _ark: Node3D
var _b := 0
var _i := 0
var _ilk: Image
var _sonuc: Array = []
const DURUMLAR := [
	{"ad": "cokmus-canli", "oldu": false},
	{"ad": "cokmus-olu",   "oldu": true},
]

func _initialize() -> void:
	root.add_child(load("res://sahne/dunya.tscn").instantiate())

func _fark(a: Image, b: Image) -> int:
	var k1 := a.duplicate(); k1.resize(160, 90)
	var k2 := b.duplicate(); k2.resize(160, 90)
	var n := 0
	for y in 90:
		for x in 160:
			var c1: Color = k1.get_pixel(x, y)
			var c2: Color = k2.get_pixel(x, y)
			if absf(c1.r - c2.r) + absf(c1.g - c2.g) + absf(c1.b - c2.b) > 0.012:
				n += 1
	return n

func _process(_dt: float) -> bool:
	if _o == null:
		_o = root.find_child("Dunya", true, false)
		_ark = root.find_child("Arkadas", true, false)
		if _o == null or _ark == null:
			printerr("ÇALIŞTIRILAMADI: Dunya/Arkadas yok"); quit(2); return true
		_o.set("zaman_carpani", 0.001)
		return false
	var d: Dictionary = DURUMLAR[_i]
	# Gündüz: ışık sabit kalsın, fark yalnızca BEDENDEN gelsin (§5.7).
	_o.sim.t = 0.35
	_o.sim.gun = 4
	_ark.set("guven_zorla", 0.80)
	_ark.set("moral_zorla", 0.05)      # çöküş eşiğinin altında
	_o.sim.arkadas.oldu = d["oldu"]
	_b += 1
	if _b == 400:
		RenderingServer.force_draw()
		_ilk = root.get_texture().get_image()
	elif _b >= 560:                    # ~2.6 sn sonra (nefes 0.22 Hz)
		RenderingServer.force_draw()
		var ikinci := root.get_texture().get_image()
		var f := _fark(_ilk, ikinci)
		_sonuc.append({"ad": d["ad"], "fark": f})
		ikinci.save_png("res://.scratch/nefes-%s.png" % d["ad"])
		print("%-16s iki kare arası farklı piksel: %d" % [d["ad"], f])
		_b = 0
		_i += 1
		if _i >= DURUMLAR.size():
			var canli: int = _sonuc[0]["fark"]
			var olu: int = _sonuc[1]["fark"]
			print("")
			print("canlı %d · ölü %d" % [canli, olu])
			if canli < 20:
				printerr("BAŞARISIZ: çökmüş CANLI beden kıpırdamıyor (%d piksel) — ölümden ayrılmıyor" % canli)
				quit(1); return true
			if olu > 4:
				printerr("BAŞARISIZ: ÖLÜ beden kıpırdıyor (%d piksel)" % olu)
				quit(1); return true
			quit(0); return true
	return false
