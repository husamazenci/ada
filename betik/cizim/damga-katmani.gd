extends CanvasLayer

# Damga ve HATA katmanı (AGENTS.md §5.4, §5.5).
#
# §5.4: hata konsola DEĞİL EKRANA DA basılır. Mantık ölse bile dünya çizilmeye
#       devam eder ve ikisi gözle ayırt edilebilir.
# §5.5: yapı damgası ilk günden görünür.
#
# İkisi de YALNIZCA hata ayıklama yapısında görünür — yayımlanan oyunda HUD yok.

const S := preload("res://betik/veri/surum.gd")

var _damga: Label
var _hata: Label
var _hatalar: Array[String] = []

func _ready() -> void:
	layer = 100
	visible = OS.is_debug_build()
	_damga = Label.new()
	_damga.text = S.tam_damga()
	_damga.position = Vector2(8, 4)
	_damga.add_theme_color_override("font_color", Color(1, 1, 1, 0.45))
	_damga.add_theme_font_size_override("font_size", 12)
	add_child(_damga)

	_hata = Label.new()
	_hata.position = Vector2(8, 24)
	_hata.add_theme_color_override("font_color", Color(1, 0.35, 0.25))
	_hata.add_theme_font_size_override("font_size", 13)
	add_child(_hata)

func hata_bildir(metin: String) -> void:
	# Aynı hata imzası tekrar basılmaz; imza DEĞİŞİNCE yeniden bildirilir.
	if metin in _hatalar:
		return
	_hatalar.append(metin)
	push_error(metin)
	_hata.text = "\n".join(_hatalar)
