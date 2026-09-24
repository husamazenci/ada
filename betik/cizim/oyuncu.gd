extends CharacterBody3D

# Birinci şahıs gövde. Hız, ivme, bakış ve salınım @export: bunlar oyun
# hissidir, kullanıcı editörde oyun çalışırken kaydırır (AGENTS.md §6.2).
# Değerler _ready'de saklanmaz; her kare okunur. Saklansaydı kaydırıcı
# bir sonraki açılışa kadar etkisiz kalırdı.

@export_group("Hareket")
@export_range(0.2, 8.0, 0.05) var yurume_hiz_ms: float = 2.0
@export_range(0.2, 12.0, 0.05) var kosu_hiz_ms: float = 3.4
# İvme, hızın bir karede hedefe kilitlenmemesi için. Kilitlenirse adım
# salınımı da aynı karede tam genliğe çıkar.
@export_range(0.5, 40.0, 0.1) var ivme_ms2: float = 12.0
@export_range(1.0, 30.0, 0.1) var yercekimi_ms2: float = 12.0

@export_group("Bakış")
# Radyan / piksel. Düşük durur; fare bir savuruşta tam tur atmasın.
@export_range(0.0002, 0.012, 0.0001) var fare_hassasiyeti_rad_px: float = 0.002
@export_range(60.0, 89.0, 1.0) var bakis_tavan_derece: float = 85.0

@export_group("Kamera")
# Ayak tabanından. Kapsülün merkezinden değil: kaydırıcı göz yüksekliği desin.
@export_range(1.2, 2.05, 0.01) var goz_yuksekligi_m: float = 1.70
@export_range(0.0, 0.12, 0.001) var kamera_salinim_m: float = 0.035
# Yürüme hızındayken saniyedeki salınım. Koşunca tempo hız / yürüme oranıyla artar.
@export_range(0.4, 4.0, 0.05) var kamera_salinim_hz: float = 2.0

var _kamera: Camera3D
var _bas_egimi_rad: float = 0.0
var _salinim_faz_rad: float = 0.0
var _salinim_gucu: float = 0.0
var _bakis_kapali: bool = false


func _ready() -> void:
	_kamera = get_node_or_null("Kamera") as Camera3D
	if _kamera == null:
		_bakis_kapali = true
		_bakisi_boz()
		return
	# Headless ölçümde yakalamak anlamsız; pencere yokken sürücü hata basabiliyor.
	if DisplayServer.get_name() != "headless":
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_kamerayi_yerlestir()


func _unhandled_input(event: InputEvent) -> void:
	# Esc imleci geri verir. Fare yakalı kalırsa oyun da pencere de bırakılamaz.
	if event is InputEventKey:
		var tus := event as InputEventKey
		if tus.pressed and not tus.echo and tus.physical_keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			return
	if event is InputEventMouseButton:
		var tik := event as InputEventMouseButton
		if tik.pressed and tik.button_index == MOUSE_BUTTON_LEFT:
			if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED and DisplayServer.get_name() != "headless":
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if _bakis_kapali or not (event is InputEventMouseMotion):
		return
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	var hareket := event as InputEventMouseMotion
	# Yaw gövdede, pitch kamerada. Pitch gövdeye binse bakış yukarıdayken
	# yürüyüş yerden kopar.
	rotate_y(-hareket.relative.x * fare_hassasiyeti_rad_px)
	var tavan := deg_to_rad(bakis_tavan_derece)
	_bas_egimi_rad = clampf(
		_bas_egimi_rad - hareket.relative.y * fare_hassasiyeti_rad_px,
		-tavan,
		tavan
	)
	_kamerayi_yerlestir()


func _physics_process(delta: float) -> void:
	var yon := Input.get_vector("sol", "sag", "ileri", "geri")
	var hiz := kosu_hiz_ms if Input.is_action_pressed("kos") else yurume_hiz_ms
	var hedef := global_basis * Vector3(yon.x, 0.0, yon.y) * hiz
	var yatay := Vector3(velocity.x, 0.0, velocity.z)
	var fark := hedef - yatay
	var adim := maxf(ivme_ms2, 0.0) * delta
	if fark.length() > adim:
		yatay += fark.normalized() * adim
	else:
		yatay = hedef
	velocity.x = yatay.x
	velocity.z = yatay.z
	if not is_on_floor():
		velocity.y -= yercekimi_ms2 * delta
	move_and_slide()
	if _bakis_kapali:
		return
	_salinimi_ilerlet(delta, Vector2(velocity.x, velocity.z).length())
	_kamerayi_yerlestir()


func _salinimi_ilerlet(delta: float, yatay_hiz_ms: float) -> void:
	var esik := 0.15
	var hedef_guc := 1.0 if yatay_hiz_ms > esik else 0.0
	_salinim_gucu = move_toward(_salinim_gucu, hedef_guc, delta * 4.0)
	if yatay_hiz_ms > esik:
		var tempo := yatay_hiz_ms / maxf(yurume_hiz_ms, 0.05)
		_salinim_faz_rad += delta * kamera_salinim_hz * TAU * tempo
	elif _salinim_gucu <= 0.001:
		# Durunca faz sıfırlanır; sonraki adım salınımın tepesinden başlamasın.
		_salinim_faz_rad = 0.0


func _kamerayi_yerlestir() -> void:
	if _kamera == null:
		return
	var dikey := sin(_salinim_faz_rad) * kamera_salinim_m * _salinim_gucu
	_kamera.position = Vector3(0.0, goz_yuksekligi_m + dikey, 0.0)
	_kamera.rotation = Vector3(_bas_egimi_rad, 0.0, 0.0)


func _bakisi_boz() -> void:
	# Metin yok: ekranda görünen cümle çeviri dosyasından gelecek. Kırmızı
	# gövde, mantık ölünce dünyanın hâlâ çizildiğini gözle ayırır (AGENTS.md §5.4).
	push_error("Oyuncu: Kamera yok, bakış kapalı.")
	var govde := get_node_or_null("Govde") as MeshInstance3D
	if govde == null:
		return
	var malzeme := StandardMaterial3D.new()
	malzeme.albedo_color = Color(0.75, 0.12, 0.1)
	malzeme.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	govde.material_override = malzeme
