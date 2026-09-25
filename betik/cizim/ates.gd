extends Node3D

# OCAK — ve ışığının GERÇEK çemberi.
#
# Bu düğüm bir süs değil, bir KURALIN ekrandaki karşılığı. K-058 (kullanıcı
# kararı) şöyle diyor: gece görüşü 5.4 m'ye daralıyor, düşük güvende arkadaş
# 7–10 m'de duruyor, yani gece yapılan hiçbir jest ona ULAŞMIYORDU — güveni
# en çok kazanman gereken anda kanal tamamen kapalıydı. İstisna şu: ateşin
# aydınlattığı çember içinde algı GÜNDÜZ gibi çalışır.
#
# O istisna bugüne kadar YALNIZCA SAYIDA vardı: `Dunya.oyuncu_atesin_isiginda`
# ve `arkadas_atesin_isiginda` alanlarını köprü hiç yazmıyordu, ikisi de hep
# false kalıyordu ve istisna oyunda ÖLÜYDÜ. Bu düğüm onları dolduruyor.
#
# Karar vermez: yanıp yanmadığını ve yakıtını köprü söyler (betik/cizim/oyun.gd).

const A := preload("res://betik/veri/ayarlar.gd")

@export_group("His")
## Alev boyunun yakıtla ne kadar oynadığı.
@export_range(0.0, 1.0, 0.05) var yakit_boy_etkisi: float = 0.45
## Titreme genliği — ışık enerjisinin yüzdesi.
@export_range(0.0, 0.5, 0.01) var titreme: float = 0.12
@export_range(0.5, 12.0, 0.1) var titreme_hizi: float = 5.5
## Sönerken/yanarken geçiş hızı.
@export_range(0.5, 20.0, 0.5) var gecis_hizi: float = 4.0

var yaniyor := false
var yakit := 0.0

var _isik: OmniLight3D
var _alev: Node3D
var _faz := 0.0
var _suanki := 0.0        # 0..1 arası yumuşatılmış "ne kadar canlı"

func _ready() -> void:
	_isik = get_node_or_null(^"Isik")
	_alev = get_node_or_null(^"Alev")
	if _isik:
		# Işık yarıçapı SABİTTEN gelir, elle girilmez. Elle girilseydi
		# ekrandaki çember ile algının kullandığı çember ayrı ayrı kayardı
		# ve "ateşin yanındaydım ama görmedi" doğardı.
		_isik.omni_range = A.ATES_ISIK_YARICAPI_M

## Bir dünya konumu ateşin ışık çemberinin İÇİNDE mi?
## Algının kullandığı çember ile ekrandakinin aynı olmasının tek yolu bu.
func isiginda_mi(konum: Vector3) -> bool:
	if not yaniyor:
		return false
	var d := konum - global_position
	d.y = 0.0
	return d.length() <= A.ATES_ISIK_YARICAPI_M

func _process(delta: float) -> void:
	var hedef := 0.0
	if yaniyor:
		# Yakıt azaldıkça küçülür ama SÖNMEZ: sönme kararı simülasyonun.
		# Görsel tamamen sıfıra inseydi oyuncu yanan ateşi sönmüş sanardı.
		hedef = 1.0 - yakit_boy_etkisi * (1.0 - clampf(yakit / A.ATES_YAKIT_TAVANI, 0.0, 1.0))
	_suanki = move_toward(_suanki, hedef, gecis_hizi * delta)

	_faz += delta * titreme_hizi
	var kipirti := 1.0 + titreme * (sin(_faz) * 0.6 + sin(_faz * 2.3) * 0.4)

	if _isik:
		_isik.light_energy = _suanki * 2.4 * kipirti
		_isik.visible = _suanki > 0.01
	if _alev:
		_alev.visible = _suanki > 0.01
		var s := maxf(_suanki, 0.001)
		_alev.scale = Vector3(s, s * kipirti, s)
