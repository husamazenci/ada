extends CharacterBody3D

# KÖPEĞİN GÖVDESİ. Karar vermez — `betik/sim/kopek.gd`'nin söylediğini uygular.
#
# Konumun kuralı tek cümle: **ışığın sınırında durur, çembere girmez.**
# Yarıçap `ATES_ISIK_YARICAPI_M` sabitinden geliyor, elle girilmiyor; elle
# girilseydi ekrandaki çember ile algının kullandığı çember ayrı ayrı kayar
# ve "ateşin içine girdi ama sim hâlâ dışarıda sanıyor" doğardı.
#
# His sayıları @export: Cursor ayarlar (AGENTS.md §6.2, pano kuyruğu).

const A := preload("res://betik/veri/ayarlar.gd")
const An := preload("res://betik/veri/animasyonlar.gd")
const Kp := preload("res://betik/sim/kopek.gd")

@export_group("Kime")
@export var ates_yolu: NodePath = ^"../Ates"
@export var arkadas_yolu: NodePath = ^"../Arkadas"

@export_group("His")
@export_range(0.2, 6.0, 0.1) var dolanma_hizi_ms: float = 1.1
@export_range(1.0, 14.0, 0.2) var atilma_hizi_ms: float = 6.5
@export_range(0.5, 12.0, 0.1) var donme_hizi_rad_s: float = 4.0
## Saldırırken arkadaşa bu kadar yaklaşır.
@export_range(0.3, 3.0, 0.1) var isirma_mesafesi_m: float = 1.0
## Çemberin çevresinde dakikada kaç tur (işaretli: yön).
@export_range(-0.6, 0.6, 0.02) var dolanma_hizi_tur_sn: float = 0.06

# Köprü yazar.
var durum: int = Kp.YOK

var _ates: Node3D
var _arkadas: Node3D
var _oynatici: AnimationPlayer
var _govde: Node3D
var _aci := 0.0              # çember üzerindeki konum
var _klip := ""

func _ready() -> void:
	_ates = get_node_or_null(ates_yolu)
	_arkadas = get_node_or_null(arkadas_yolu)
	_govde = get_node_or_null(^"Govde")
	if _govde:
		_oynatici = _govde.find_child("AnimationPlayer", true, false)
	if _oynatici == null:
		push_error("[ada] Kopek/Govde altında AnimationPlayer yok — hayvan donar")
	visible = false
	_aci = randf() * TAU

func _physics_process(delta: float) -> void:
	# ULUMA görünmez: uyarı UZAKTAN gelen bir sestir, yön anlaşılmaz
	# (tasarım §3. gün). Hayvan ilk kez ışığın sınırında GÖRÜNÜR.
	var gorunur := durum == Kp.KENARDA or durum == Kp.SALDIRIYOR
	if visible != gorunur:
		visible = gorunur
		if gorunur and _ates:
			# Çember üzerindeki açıyı BULUNDUĞU YERDEN al. Rastgele bir açıdan
			# başlasaydı hayvan hedefe DÜZ gider, yani çemberin İÇİNDEN
			# kestirirdi — ölçüldü: 6.00 m yerine 3.74 m'ye kadar giriyordu.
			# Tasarımın tek cümlesi "ışığın sınırında durur, yaklaşmaz".
			var b := global_position - _ates.global_position
			_aci = atan2(b.z, b.x)
	if not gorunur or _ates == null:
		velocity = Vector3.ZERO
		return

	var merkez := _ates.global_position
	var hedef_konum: Vector3
	var hiz: float

	if durum == Kp.SALDIRIYOR and _arkadas:
		# Atılma: çemberi TERK EDER. Tehdidin gerçek olduğu tek an bu.
		var yon := (_arkadas.global_position - global_position)
		yon.y = 0.0
		var uzaklik := yon.length()
		hedef_konum = _arkadas.global_position - yon.normalized() * isirma_mesafesi_m \
			if uzaklik > 0.01 else global_position
		hiz = atilma_hizi_ms
		_oynat("isir" if uzaklik <= isirma_mesafesi_m + 0.3 else "atil")
	else:
		# Kenarda: çemberin ÇEVRESİNDE dolanır, içine girmez.
		# Açı her kare GERÇEK KONUMDAN yeniden okunur, sonra bir adım eklenir.
		# Açıyı yalnızca biriktirseydim hedef hep önde kalır, hayvan da ona
		# düz gitmeye çalışıp yayı kesip içeri kayardı (ölçüldü: 6.00 yerine
		# 5.08 m). Hedefin yarıçapı her zaman tam r olduğu için yarıçap
		# hatası da kendiliğinden düzeliyor.
		var b := global_position - merkez
		b.y = 0.0
		if b.length() > 0.01:
			_aci = atan2(b.z, b.x)
		_aci += dolanma_hizi_tur_sn * TAU * delta
		var r := A.ATES_ISIK_YARICAPI_M
		hedef_konum = merkez + Vector3(cos(_aci) * r, 0.0, sin(_aci) * r)
		hiz = dolanma_hizi_ms
		_oynat("dolan" if velocity.length() > 0.15 else "bekle")

	var fark := hedef_konum - global_position
	fark.y = 0.0
	var istenen := Vector3.ZERO
	if fark.length() > 0.12:
		istenen = fark.normalized() * hiz
	velocity.x = move_toward(velocity.x, istenen.x, hiz * 6.0 * delta)
	velocity.z = move_toward(velocity.z, istenen.z, hiz * 6.0 * delta)
	if not is_on_floor():
		velocity.y -= 12.0 * delta
	else:
		velocity.y = 0.0
	move_and_slide()

	# Yüzü gittiği yöne. Saldırırken arkadaşa bakar.
	var bakis := istenen if istenen.length() > 0.05 else fark
	if bakis.length() > 0.01:
		var hedef_aci := atan2(bakis.x, bakis.z)
		rotation.y = rotate_toward(rotation.y, hedef_aci, donme_hizi_rad_s * delta)

func _oynat(oyun_durumu: String) -> void:
	if _oynatici == null or oyun_durumu == _klip:
		return
	var klip: String = An.KOPEK_KLIPLER.get(oyun_durumu, "")
	if klip.is_empty() or not _oynatici.has_animation(klip):
		push_error("[ada] köpek klibi yok: %s (%s)" % [oyun_durumu, klip])
		return
	_klip = oyun_durumu
	_oynatici.play(klip, 0.2)

## Işık çemberinin DIŞINDA mı? Tasarımın tek cümlesi burada sınanır.
func isigin_disinda_mi() -> bool:
	if _ates == null:
		return true
	var d := global_position - _ates.global_position
	d.y = 0.0
	return d.length() >= A.ATES_ISIK_YARICAPI_M - 0.5
