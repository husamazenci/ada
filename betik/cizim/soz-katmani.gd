extends CanvasLayer

# OYUNCUNUN SÖZÜ EKRANDA (K-063, kullanıcı kararı).
#
# "Kelime duyulmasın, ekranda yazı olarak görünsün ama diyaloğa girilmesin."
# Duyulan şey karakterin boğuk mırıltısıdır; buradaki satır o mırıltının
# YAKLAŞIK karşılığıdır — altyazı değil, yaklaşık karşılık.
#
# Bu yüzden: kutu yok, isim yok, seçenek yok, devam tuşu yok. Satır belirir,
# söner, gider. Arkadaş cevap vermez — cevabı BEDENİYLE verir (bkz. çağrı).
#
# HUD DEĞİLDİR (§2: "oyun öğretmez, anlatır"): oyuncuya ne yapacağını değil,
# o anda ne yaptığını söyler. Bu yüzden yayımlanan oyunda da görünür.

## Satır ne kadar tam görünür durur.
@export_range(0.5, 6.0, 0.1) var kalis_sn: float = 1.6
## Sonra ne kadar sürede söner.
@export_range(0.2, 4.0, 0.1) var sonus_sn: float = 1.2

var _yazi: Label
var _kalan := 0.0

func _ready() -> void:
	layer = 50
	_yazi = Label.new()
	_yazi.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_yazi.anchor_left = 0.0
	_yazi.anchor_right = 1.0
	_yazi.anchor_top = 0.72
	_yazi.anchor_bottom = 0.72
	_yazi.add_theme_font_size_override("font_size", 20)
	# Kasvetli tona yakın kırık beyaz; saf beyaz oyundan kopuyor.
	_yazi.add_theme_color_override("font_color", Color(0.92, 0.90, 0.86))
	_yazi.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.7))
	_yazi.add_theme_constant_override("outline_size", 4)
	_yazi.modulate.a = 0.0
	add_child(_yazi)

func soyle(anahtar: String) -> void:
	# Metin KODA yazılmaz; anahtardan gelir (K-010). Karşılığı yoksa
	# Godot ham anahtarı basar — testler/dil.gd bunu önceden yakalar.
	_yazi.text = tr(anahtar)
	_kalan = kalis_sn + sonus_sn
	_yazi.modulate.a = 1.0

func _process(delta: float) -> void:
	if _kalan <= 0.0:
		return
	_kalan -= delta
	if _kalan <= sonus_sn:
		_yazi.modulate.a = clampf(_kalan / sonus_sn, 0.0, 1.0)
	if _kalan <= 0.0:
		_yazi.modulate.a = 0.0
