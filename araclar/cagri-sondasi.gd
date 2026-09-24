extends SceneTree

# ÇAĞRI SONDASI (K-068). Üç güven seviyesinde Q'ya basar ve ekranda NE OLDUĞUNU
# ölçer: cevap kaç saniyede geldi, arkadaş nereye kadar geldi, geldi mi.
#
# Saf test (testler/cagri.gd) kuralın doğru olduğunu kanıtlar; bu sonda
# kuralın SAHNEDE gerçekleştiğini kanıtlar. İkisi ayrı şeydir: ikinci denemenin
# en pahalı hataları "testte geçiyor ama ekranda yok" ailesindendi.
#
# --headless ile ÇALIŞMAZ (görüntü alır). Çıkış: 0 · 1 · 2.

const Dv := preload("res://betik/ai/davranis.gd")
const Cg := preload("res://betik/ai/cagri.gd")

const DURUMLAR := [
	{"ad": "cagri-guven-yuksek", "g": 0.80},
	{"ad": "cagri-guven-orta",   "g": 0.50},
	{"ad": "cagri-guven-dusuk",  "g": 0.10},
]

var _i := 0
var _evre := "ariyor"
var _sure := 0.0
var _gecikme := -1.0
var _mesafe0 := 0.0
var _en_yakin := 999.0
var _oyun: Node3D
var _arkadas: Node3D
var _oyuncu: Node3D

func _initialize() -> void:
	var sahne := load("res://sahne/dunya.tscn")
	if sahne == null:
		printerr("ÇALIŞTIRILAMADI: sahne yüklenemedi"); quit(2); return
	root.add_child(sahne.instantiate())

func _mesafe() -> float:
	return Vector2(_arkadas.global_position.x - _oyuncu.global_position.x,
		_arkadas.global_position.z - _oyuncu.global_position.z).length()

func _process(dt: float) -> bool:
	if _oyun == null:
		_oyun = root.find_child("Dunya", true, false)
		_arkadas = root.find_child("Arkadas", true, false)
		_oyuncu = root.find_child("Oyuncu", true, false)
		if _oyun == null or _arkadas == null or _oyuncu == null:
			printerr("ÇALIŞTIRILAMADI: Dunya/Arkadas/Oyuncu bulunamadı"); quit(2); return true
		if _oyun.sim == null:
			printerr("ÇALIŞTIRILAMADI: köprüde simülasyon yok"); quit(2); return true
		# Gecikme bandın içinde rastgeledir; sonda BELİRLENİMCİ olsun diye
		# tohum sabitlenir. Oyun kendi tohumunu atar, sonda atmaz.
		_oyun.sim.cagri.rastgele.seed = 20260924
		print("%-22s %-9s %-11s %-11s %s" % ["durum", "duruş m", "cevap sn", "en yakın m", "kadraj"])

	var d: Dictionary = DURUMLAR[_i]
	_oyun.sim.guven.deger = d["g"]
	_oyun.sim.guven.moral = 0.80          # moral kanalı sabit: yalnızca güveni sınıyoruz
	_sure += dt

	match _evre:
		"ariyor":
			# Kendi bandına YERLEŞENE kadar bekle (sabit kare sayısı değil:
			# önceki durumdan kalan mesafeye göre gereken süre değişiyor).
			if absf(_mesafe() - Dv.hedef_mesafe_m(d["g"])) < 0.35 \
					and _arkadas.velocity.length() < 0.05:
				_mesafe0 = _mesafe()
				_en_yakin = _mesafe0
				_gecikme = -1.0
				_sure = 0.0
				_evre = "cagirdi"
				if not _oyun.sim.cagir():
					printerr("ÇALIŞTIRILAMADI: çağrı çıkmadı (soğuma?)"); quit(2); return true
			elif _sure > 60.0:
				printerr("ÇALIŞTIRILAMADI: %s yerleşemedi (%.2f m)" % [d["ad"], _mesafe()])
				quit(2); return true
		"cagirdi":
			_en_yakin = minf(_en_yakin, _mesafe())
			if _gecikme < 0.0 and _oyun.sim.cagri.yanit_veriyor_mu():
				_gecikme = _sure
			# Cevap penceresi + sessizlik penceresinin ikisini de geçecek kadar
			# bekle ki "gelmedi" kararı da kesinleşsin.
			if _sure >= Dv.CAGRI_YANIT_SN + Dv.cagri_sessizlik_sn() + 1.0:
				# İlk yazışımda doğrudan get_image() çağırıyordum ve ÜÇ KADRAJ
				# DA BAYT BAYT AYNI çıktı: _process çizimden ÖNCE koşuyor,
				# okunan doku bir önceki karenin dokusu oluyor ve sonda gerçek
				# zamandan çok daha hızlı aktığı için üçü de aynı kareye
				# denk geldi. Sayılar doğruydu, görüntü yalandı (§5.8).
				RenderingServer.force_draw()
				root.get_texture().get_image().save_png("res://.scratch/%s.png" % d["ad"])
				print("%-22s %-9.2f %-11s %-11.2f .scratch/%s.png" % [
					d["ad"], _mesafe0,
					"GELMEDİ" if _gecikme < 0.0 else "%.2f" % _gecikme,
					_en_yakin, d["ad"]])
				_i += 1
				_sure = 0.0
				_evre = "ariyor"
				if _i >= DURUMLAR.size():
					quit(0); return true
	return false
