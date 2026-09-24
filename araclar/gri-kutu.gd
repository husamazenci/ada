extends SceneTree

# GRİ KUTU KAPISI — görsel yarısı.
# Üç güven seviyesini sırayla zorlar, arkadaşın yerleşmesini bekler, her biri
# için PNG yazar ve gerçekleşen mesafeyi ölçer. --headless ile ÇALIŞMAZ.

const D := preload("res://betik/ai/davranis.gd")
const YERLESME_KARE := 420
const GOSTERIM_KARE := 400   # duruş değişiminin tamamlanması için

var _kare := 0
var _i := 0
var _yerlesti := false
var _arkadas: Node3D
var _oyuncu: Node3D
var _oyuncu_konum := Vector3.INF
# Her durum İKİ AŞAMALI: önce "yerleşme" değerleriyle konumlanır, sonra
# "gösterim" değerleri uygulanır. Sebep: dip moralde arkadaş yerinden
# kalkamaz — moral düşmeden önce yakına yerleşmezse, uzakta oturan biri
# "düşük güven" diye okunur ve iki kanal görsel olarak karışır. Spektin
# uyardığı tuzak tam buydu.
const DURUMLAR := [
	{"ad": "guven-yuksek",       "yer_g": 0.80, "yer_m": 0.80, "g": 0.80, "m": 0.80},
	{"ad": "guven-orta",         "yer_g": 0.50, "yer_m": 0.80, "g": 0.50, "m": 0.80},
	{"ad": "guven-dusuk",        "yer_g": 0.10, "yer_m": 0.80, "g": 0.10, "m": 0.80},
	{"ad": "yuksek-guven-dip-moral", "yer_g": 0.80, "yer_m": 0.80, "g": 0.80, "m": 0.20},
	{"ad": "dusuk-guven-dip-moral",  "yer_g": 0.10, "yer_m": 0.80, "g": 0.10, "m": 0.20},
]

func _mesafe() -> float:
	return Vector2(_arkadas.global_position.x - _oyuncu.global_position.x,
		_arkadas.global_position.z - _oyuncu.global_position.z).length()

func _initialize() -> void:
	var sahne := load("res://sahne/dunya.tscn")
	if sahne == null:
		printerr("ÇALIŞTIRILAMADI: sahne yüklenemedi"); quit(2); return
	root.add_child(sahne.instantiate())

func _process(_d: float) -> bool:
	if _arkadas == null:
		_arkadas = root.find_child("Arkadas", true, false)
		_oyuncu = root.find_child("Oyuncu", true, false)
		if _arkadas == null or _oyuncu == null:
			printerr("ÇALIŞTIRILAMADI: Arkadas/Oyuncu bulunamadı"); quit(2); return true
		print("%-24s %-8s %-9s %-11s %s" % ["durum", "mesafe", "duruş", "gövde", "kadraj"])
	# KAMERAYI KİLİTLE. Kilitsizken kadrajlar arasında ufuk 68 piksel kaydı
	# (yerçekimiyle oturma + kamera salınımı), ve iki kadrajı piksel piksel
	# karşılaştırmak anlamsız hâle geldi: farkın çoğu arkadaştan değil zemin
	# ile gökyüzü sınırından geliyordu. Ölçüm aracı ölçtüğü şeyden başka
	# hiçbir şeyin değişmediğini garanti etmeli (§5.7).
	if _oyuncu_konum == Vector3.INF:
		if _kare > 120:
			_oyuncu_konum = _oyuncu.global_position
		_kare += 1
		return false
	_oyuncu.set("velocity", Vector3.ZERO)
	_oyuncu.global_position = _oyuncu_konum
	var kam := _oyuncu.get_node_or_null(^"Kamera")
	if kam:
		kam.position = Vector3(0.0, _oyuncu.get("goz_yuksekligi_m"), 0.0)

	var d: Dictionary = DURUMLAR[_i]
	_kare += 1
	# 1. aşama: HEDEFE VARANA KADAR yerleş (sabit kare sayısı yetmiyordu —
	# önceki durumdan kalan mesafeye göre gereken süre değişiyor).
	if not _yerlesti:
		_arkadas.set("guven_zorla", d["yer_g"])
		_arkadas.set("moral_zorla", d["yer_m"])
		var su_an := _mesafe()
		if absf(su_an - D.hedef_mesafe_m(d["yer_g"])) < 0.35:
			_yerlesti = true
			_kare = 0
		elif _kare > 3000:
			printerr("ÇALIŞTIRILAMADI: %s yerleşemedi (%.2f m)" % [d["ad"], su_an])
			quit(2); return true
		return false
	_arkadas.set("guven_zorla", d["g"])
	_arkadas.set("moral_zorla", d["m"])

	# 2. aşama: gösterim değerleri OTURANA KADAR bekle. Sabit kare sayısı
	# zamanlamaya duyarlıydı — iki koşu farklı sonuç verdi (bir seferinde
	# 6.00 m, ötekinde 8.28 m). Koşula bağlanınca belirlenimci oluyor.
	var govde0 := _arkadas.get_node_or_null(^"Govde")
	# Taban yüksekliği ve oturma düşümü DÜĞÜMDEN okunur, sabit yazılmaz.
	# Sabit yazılıydı (0.875 − 0.55, kapsülün sayıları) ve kapsül gerçek
	# gövdeyle değişince sonda "gösterimde oturmadı" diye ÇALIŞTIRILAMADI
	# verdi. Ölçüm aracı ölçtüğü şeyin sayılarını kendi tutmamalı.
	var taban_y: float = _arkadas.get("_govde_y0")
	var dusum: float = _arkadas.get("oturma_dusumu_m")
	var hedef_govde_y: float = taban_y - (dusum if D.oturuyor_mu(d["m"]) else 0.0)
	var govde_oturdu: bool = govde0 == null or absf(govde0.position.y - hedef_govde_y) < 0.005
	var durdu: bool = _arkadas.velocity.length() < 0.02
	var mesafe_tamam: bool = absf(_mesafe() - D.hedef_mesafe_m(d["g"])) < 0.35 or D.oturuyor_mu(d["m"])
	if not (govde_oturdu and durdu and mesafe_tamam):
		if _kare > 3000:
			printerr("ÇALIŞTIRILAMADI: %s gösterimde oturmadı" % d["ad"]); quit(2); return true
		return false

	var olculen := _mesafe()
	var oturuyor: bool = D.oturuyor_mu(d["m"])
	var govde := _arkadas.get_node_or_null(^"Govde")
	var govde_y: float = govde.position.y if govde else -1.0
	# _process çizimden ÖNCE koşar; zorlamadan okunan doku bir önceki karenin
	# dokusudur ve sonda gerçek zamandan hızlı aktığı için kadrajlar aynı
	# kareye denk gelebilir (çağrı sondasında tam bu oldu, §5.8).
	RenderingServer.force_draw()
	root.get_texture().get_image().save_png("res://.scratch/gri-%s.png" % d["ad"])
	print("%-24s %-8.2f %-9s gövde y %.3f  .scratch/gri-%s.png" % [d["ad"], olculen, "OTURUYOR" if oturuyor else "ayakta", govde_y, d["ad"]])

	_i += 1
	_kare = 0
	_yerlesti = false
	if _i >= DURUMLAR.size():
		quit(0); return true
	return false
