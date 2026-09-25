extends SkeletonModifier3D

# ANİMASYONUN ÜSTÜNE EKLER, yerine geçmez.
#
# İki iş yapıyor ve ikisi de daha önce yapılamamıştı:
#
# 1) MORAL EĞİMİ. Spekt omuz/baş düşmesini 0° / 12° / 30° diye yazmıştı
#    (`Davranis.duruş_egimi_derece`) ve sayı baştan beri duruyordu, ama hiç
#    kullanılamıyordu: `set_bone_pose_rotation` pozu DEĞİŞTİRİR, üstüne
#    eklemez — animasyon gelince ikisi çakışırdı. `SkeletonModifier3D`
#    animasyondan SONRA koşuyor ve mevcut pozu okuyup üstüne ekliyor.
#
# 2) NEFES. `Death01`ın son karesinde arkadaş yüzüstü yatıyor ve HİÇ
#    kıpırdamıyor — yani çöküş ile ölüm ekranda AYNI görünüyordu. Tasarım
#    çöküşün günlerce sürmesini ve oyuncunun defalarca müdahale şansı
#    olmasını istiyor (K-049); ayırt edilemiyorsa o pencere yok demektir.
#    Canlı beden kıpırdar, ölü beden kıpırdamaz. Ölçüsü bu kadar basit.

const D := preload("res://betik/ai/davranis.gd")

## Yatan bedenin nefesi — küçük ve YAVAŞ olmalı. Büyük olsaydı "uyuyor"
## gibi rahat okunurdu; hızlı olsaydı "iyi" görünürdü.
@export_range(0.0, 6.0, 0.1) var nefes_genligi_derece: float = 1.6
@export_range(0.05, 1.0, 0.01) var nefes_hizi_hz: float = 0.22
@export_range(0.5, 12.0, 0.1) var egim_hizi_rad_s: float = 2.0

# Arkadaşın gövdesi yazar.
var moral := 0.7
var canli := true

var _omurga: Array[int] = []
var _arandi := false
var _faz := 0.0
var _egim := 0.0

func _process_modification_with_delta(delta: float) -> void:
	var sk := get_skeleton()
	if sk == null:
		return
	if not _arandi:
		_arandi = true
		for ad in ["spine_01", "spine_02", "spine_03"]:
			var i := sk.find_bone(ad)
			if i >= 0:
				_omurga.append(i)
		if _omurga.is_empty():
			push_error("[ada] BedenEklentisi: omurga kemikleri bulunamadı")
	if _omurga.is_empty():
		return

	# 1) EĞİM — moralden. Kemik başına pay; tek kemiğe verilince bel kırılıyor gibi duruyor.
	var hedef := deg_to_rad(D.duruş_egimi_derece(moral)) / float(_omurga.size())
	_egim = move_toward(_egim, hedef, egim_hizi_rad_s * delta)

	# 2) NEFES — yalnızca ÇÖKMÜŞ ve CANLI bedende. Ayakta duran biri zaten
	#    animasyonuyla kıpırdıyor; nefesi orada da eklemek gürültü olurdu.
	var nefes := 0.0
	if canli and D.cokuyor_mu(moral):
		_faz += delta * nefes_hizi_hz * TAU
		nefes = deg_to_rad(nefes_genligi_derece) * sin(_faz) / float(_omurga.size())

	var aci := _egim + nefes
	if is_zero_approx(aci):
		return
	var ek := Quaternion(Vector3.RIGHT, aci)
	for i in _omurga:
		# ÜSTÜNE EKLE: mevcut poz animasyonun yazdığı şey.
		sk.set_bone_pose_rotation(i, sk.get_bone_pose_rotation(i) * ek)
