extends SceneTree

# GÜN DÖNÜŞÜ SONDASI: günün beş anını kadrajlar ve ekranın gerçekten
# karardığını ÖLÇER (ortalama piksel parlaklığı). "Gece geldi" demeden önce
# bak — ve bakmakla yetinme, say (§7, §5.8).
#
# --headless ile ÇALIŞMAZ. Çıkış: 0 · 1 · 2.

const I := preload("res://betik/veri/isik.gd")
const A := preload("res://betik/veri/ayarlar.gd")

const ANLAR := [
	{"ad": "safak",          "t": 0.03},
	{"ad": "gunduz",         "t": 0.35},
	{"ad": "alacakaranlik",  "t": 0.70},
	{"ad": "gece",           "t": 0.85},
	{"ad": "gece-atessiz",   "t": 0.85, "ates": false},
]

var _o: Node3D
var _b := 0
var _i := 0
var _sonuc: Array = []

func _initialize() -> void:
	root.add_child(load("res://sahne/dunya.tscn").instantiate())

func _process(_d: float) -> bool:
	if _o == null:
		_o = root.find_child("Dunya", true, false)
		if _o == null:
			printerr("ÇALIŞTIRILAMADI: Dunya bulunamadı"); quit(2); return true
		_o.set("zaman_carpani", 0.001)
		var gok := _o.get_node_or_null(^"Gokyuzu")
		if gok:
			gok.gecis_hizi = 100.0     # sonda beklemesin
		print("%-16s %-7s %-7s %-8s %s" % ["an", "t", "güneş", "parlaklık", "kadraj"])
		return false
	var d: Dictionary = ANLAR[_i]
	_o.sim.gun = 3
	_o.sim.t = d["t"]
	_o.sim.ates_yaniyor = d.get("ates", true)
	_o.sim.ates_yakit = 1.0
	_b += 1
	if _b < 90:
		return false
	RenderingServer.force_draw()
	var img := root.get_texture().get_image()
	img.save_png("res://.scratch/gun-%s.png" % d["ad"])
	# Ortalama parlaklık: ekranın gerçekten karardığını sayıyla gösterir.
	var kucuk := img.duplicate()
	kucuk.resize(64, 36)
	var toplam := 0.0
	for y in 36:
		for x in 64:
			var c: Color = kucuk.get_pixel(x, y)
			toplam += (c.r + c.g + c.b) / 3.0
	var parlaklik := toplam / (64.0 * 36.0)
	_sonuc.append({"ad": d["ad"], "t": d["t"], "parlaklik": parlaklik})
	print("%-16s %-7.2f %-7.2f %-8.4f .scratch/gun-%s.png" % [
		d["ad"], d["t"], I.gunes_enerjisi(d["t"]), parlaklik, d["ad"]])
	_b = 0
	_i += 1
	if _i < ANLAR.size():
		return false

	# --- ÖLÇÜT: gece gündüzden BELİRGİN biçimde karanlık olmalı ---
	var gunduz := 0.0
	var gece := 0.0
	for r in _sonuc:
		if r["ad"] == "gunduz":
			gunduz = r["parlaklik"]
		elif r["ad"] == "gece":
			gece = r["parlaklik"]
	print("")
	print("gündüz %.4f · gece %.4f · oran %.2f×" % [gunduz, gece, gunduz / maxf(gece, 0.0001)])
	if gece >= gunduz * 0.5:
		printerr("BAŞARISIZ: gece gündüzün yarısından karanlık değil — ateşin ışığı hiçbir şey ifade etmez")
		quit(1); return true
	quit(0); return true
