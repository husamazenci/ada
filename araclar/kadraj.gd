extends SceneTree
# Kadraj alıcı: sahneyi GERÇEK pencerede çizer, birkaç kare bekler, PNG yazar.
# --headless ile ÇALIŞMAZ: o kipte sahte çizici var, görüntü boş çıkar.
var _kare := 0
var _yol := "res://.scratch/kadraj.png"

func _initialize() -> void:
	var s := load("res://sahne/dunya.tscn")
	if s == null:
		printerr("ÇALIŞTIRILAMADI: sahne yüklenemedi"); quit(2); return
	root.add_child(s.instantiate())

func _process(_d: float) -> bool:
	_kare += 1
	if _kare < 30:
		return false
	var g := root.get_texture().get_image()
	if g == null or g.is_empty():
		printerr("ÇALIŞTIRILAMADI: görüntü boş — çizici gerçek mi?"); quit(2); return true
	g.save_png(_yol)
	print("kadraj: %dx%d → %s" % [g.get_width(), g.get_height(), _yol])
	quit(0)
	return true
