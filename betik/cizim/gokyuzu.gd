extends Node3D

# GÜNÜN IŞIĞINI UYGULAR. Karar vermez: eğri `betik/veri/isik.gd`'de,
# zamanı köprü söyler. Burası yalnızca düğümlere yazar.
#
# Ayrı bir düğüm olmasının sebebi: güneş, ortam ışığı ve gök rengi TEK
# ELDEN sürülmeli. Üçü ayrı yerlerden ayarlansaydı biri gece kalır öteki
# gündüz olurdu — ve "ekran gece mi" sorusunun tek bir cevabı olmazdı.

const I := preload("res://betik/veri/isik.gd")

## Yumuşatma: ani sıçrama olmasın (kayıttan yüklenirken t zıplayabilir).
@export_range(0.0, 10.0, 0.1) var gecis_hizi: float = 3.0

var t := 0.0

var _gunes: DirectionalLight3D
var _ortam: WorldEnvironment
var _suanki := -1.0

func _ready() -> void:
	_gunes = get_node_or_null(^"../Isik")
	_ortam = get_node_or_null(^"../Ortam")
	if _gunes == null or _ortam == null:
		push_error("[ada] Gokyuzu: Isik ya da Ortam bulunamadı — gece hiç gelmez")

func _process(delta: float) -> void:
	if _suanki < 0.0:
		_suanki = t
	else:
		# Gün dönümünde t 1.0'dan 0.0'a atlıyor; kısa yoldan takip et.
		var fark := t - _suanki
		if fark > 0.5:
			_suanki += 1.0
		elif fark < -0.5:
			_suanki -= 1.0
		_suanki = fposmod(move_toward(_suanki, t, gecis_hizi * delta), 1.0)

	var o := _suanki
	if _gunes:
		_gunes.light_energy = I.gunes_enerjisi(o)
		_gunes.light_color = I.gunes_rengi(o)
		_gunes.visible = _gunes.light_energy > 0.005
		# Godot'da yönlü ışığın yönü −Z SÜTUNUdur; rotation_degrees ile
		# kurmak satır/sütun karışıklığını tamamen önlüyor (K-045).
		_gunes.rotation_degrees = Vector3(I.gunes_egimi_derece(o), 35.0, 0.0)
	if _ortam and _ortam.environment:
		var e := _ortam.environment
		e.ambient_light_energy = I.ortam_enerjisi(o)
		e.ambient_light_color = I.gok_rengi(o).lerp(Color(1, 1, 1), 0.35)
		e.background_color = I.gok_rengi(o)
