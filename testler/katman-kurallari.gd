extends SceneTree

# Katman kuralı (AGENTS.md §5.2).
#
# betik/sim, betik/ai ve betik/veri SAF kalır: görsel düğüm, girdi, ses çalar,
# render sunucusu içe aktaramaz. Sebep: arkadaşın davranışı pencere açmadan,
# saniyenin altında ve belirlenimci ölçülebilmeli. İkinci denemede bu kural
# vardı ve işe yaradı — 12 günlük koşu 1.1 saniyede dönüyordu.
#
# Çıkış kodu: 0 geçti · 1 başarısız · 2 ÇALIŞTIRILAMADI. "Atlandı" yok.

const SAF_KLASORLER: Array = ["res://betik/sim", "res://betik/ai", "res://betik/veri"]

const YASAK: Array = [
	"Node3D", "Node2D", "MeshInstance3D", "Camera3D", "CharacterBody3D",
	"AnimationPlayer", "AnimationTree", "AudioStreamPlayer", "CollisionShape",
	"get_viewport", "get_tree", "RenderingServer", "DisplayServer",
	"BaseMaterial3D", "ShaderMaterial", "Texture2D", "Input.", "Viewport",
]

func _initialize() -> void:
	var dosyalar: Array = []
	for klasor in SAF_KLASORLER:
		if not DirAccess.dir_exists_absolute(klasor):
			printerr("ÇALIŞTIRILAMADI: saf katman klasörü yok: %s" % klasor)
			quit(2)
			return
		_topla(klasor, dosyalar)

	var ihlaller: Array = []
	for yol in dosyalar:
		var f := FileAccess.open(yol, FileAccess.READ)
		if f == null:
			printerr("ÇALIŞTIRILAMADI: okunamadı: %s" % yol)
			quit(2)
			return
		var satirNo := 0
		while not f.eof_reached():
			satirNo += 1
			var satir := f.get_line()
			var kod := satir.split("#")[0]        # yorumlar taranmaz
			if kod.strip_edges().is_empty():
				continue
			for desen in YASAK:
				if kod.contains(desen):
					ihlaller.append("%s:%d  → %s" % [yol, satirNo, desen])
		f.close()

	# K-003 dersi: sıfır dosya tarayan test "geçti" demez, "ölçemedim" der.
	if dosyalar.is_empty():
		printerr("ÇALIŞTIRILAMADI: saf katmanlarda hiç .gd yok — test bir şey ölçmedi.")
		quit(2)
		return

	print("Taranan dosya: %d" % dosyalar.size())
	if ihlaller.is_empty():
		print("GEÇTİ — saf katmanlar temiz.")
		quit(0)
		return
	printerr("BAŞARISIZ — %d ihlal:" % ihlaller.size())
	for i in ihlaller:
		printerr("  " + i)
	quit(1)

func _topla(klasor: String, birikim: Array) -> void:
	var d := DirAccess.open(klasor)
	if d == null:
		return
	d.list_dir_begin()
	var ad := d.get_next()
	while ad != "":
		var tam := klasor.path_join(ad)
		if d.current_is_dir():
			_topla(tam, birikim)
		elif ad.ends_with(".gd"):
			birikim.append(tam)
		ad = d.get_next()
	d.list_dir_end()
