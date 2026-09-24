extends CharacterBody3D

# Arkadaşın gövdesi. Bu betik KARAR VERMEZ — `betik/ai/davranis.gd`'nin
# söylediğini uygular. Sebep: davranışın ayırt edilebilirliği pencere açmadan
# sınanabilmeli (testler/davranis.gd), ekranda gördüğümüz o sınanan şeyin
# kendisi olmalı.
#
# His sayıları @export: kullanıcı oyun çalışırken ayarlar (AGENTS.md §6.2).

const D := preload("res://betik/ai/davranis.gd")

@export_group("Kime")
@export var oyuncu_yolu: NodePath = ^"../Oyuncu"

@export_group("His")
@export_range(0.2, 4.0, 0.05) var taban_hiz_ms: float = 1.6
@export_range(0.5, 20.0, 0.1) var ivme_ms2: float = 6.0
@export_range(0.5, 12.0, 0.1) var donme_hizi_rad_s: float = 3.0
@export_range(0.05, 1.5, 0.05) var mesafe_olu_bant_m: float = 0.4
## 0 = alçalma yok. Kapsül döneminde 0.55'ti: kapsülün duruşu olmadığı için
## "oturmak" ancak alçalmakla gösterilebiliyordu. Gerçek gövdede ÖLÇÜLDÜ ve
## kötüydü — bacaklar zemine gömülüyor, "oturan" değil "batan" biri okunuyordu.
## Dip moral artık omurga eğimiyle (30°) ve durmakla okunuyor; gerçek oturma
## pozu animasyon kütüphanesiyle gelecek.
@export_range(0.0, 1.2, 0.01) var oturma_dusumu_m: float = 0.0
@export_range(0.5, 8.0, 0.1) var oturma_hizi_ms: float = 2.0
@export_range(0.5, 12.0, 0.1) var egim_hizi_rad_s: float = 2.5
## Modelin baktığı yön Godot'nun −Z'sinden sapıyorsa buradan düzeltilir.
@export_range(-180.0, 180.0, 1.0) var model_yon_duzeltme_derece: float = 0.0

@export_group("Gri kutu sondası (yalnızca geliştirme)")
## −1 = simülasyondan al. 0..1 = zorla. Üç seviyeyi kadrajlamak için.
@export_range(-1.0, 1.0, 0.01) var guven_zorla: float = -1.0
@export_range(-1.0, 1.0, 0.01) var moral_zorla: float = -1.0

var guven: float = 0.35
var moral: float = 0.70

# Köprü yazar (betik/cizim/oyun.gd), burası yalnızca uygular. Karar saf
# katmandadır (betik/ai/cagri.gd): "cevap veriyor mu" sorusunu sahne sormaz.
var cagriya_cevap_veriyor := false

var _oyuncu: Node3D
var _govde: Node3D
var _govde_y0: float = 0.0
var _iskelet: Skeleton3D
var _omurga: Array[int] = []
var _egim_su_an := 0.0

func _ready() -> void:
	_oyuncu = get_node_or_null(oyuncu_yolu)
	_govde = get_node_or_null(^"Govde")
	if _govde:
		_govde_y0 = _govde.position.y
		_iskelet = _govde.find_child("Skeleton3D", true, false)
	if _iskelet:
		for ad in ["spine_01", "spine_02", "spine_03"]:
			var i := _iskelet.find_bone(ad)
			if i >= 0:
				_omurga.append(i)

func _physics_process(delta: float) -> void:
	if guven_zorla >= 0.0:
		guven = guven_zorla
	if moral_zorla >= 0.0:
		moral = moral_zorla
	if _oyuncu == null:
		return

	var bana := global_position - _oyuncu.global_position
	bana.y = 0.0
	var uzaklik := bana.length()
	if uzaklik < 0.01:
		bana = Vector3.FORWARD
		uzaklik = 0.01

	# GÜVEN KANALI: hedef mesafe. Çağrıya cevap verirken kendi bandının YAKIN
	# kenarına gelir — bandını terk etmez, yoksa mesafe güveni okumayı bırakır.
	var hedef := D.cagri_hedef_mesafe_m(guven) if cagriya_cevap_veriyor else D.hedef_mesafe_m(guven)
	var fark := uzaklik - hedef
	var yon := bana.normalized()

	# MORAL KANALI: tempo. Dip moralde hiç yürümez (oturur).
	var tempo := D.tempo_carpani(moral)
	var istenen := Vector3.ZERO
	if tempo > 0.0 and absf(fark) > mesafe_olu_bant_m:
		istenen = -yon * signf(fark) * taban_hiz_ms * tempo

	velocity.x = move_toward(velocity.x, istenen.x, ivme_ms2 * delta)
	velocity.z = move_toward(velocity.z, istenen.z, ivme_ms2 * delta)
	if not is_on_floor():
		velocity.y -= 12.0 * delta
	else:
		velocity.y = 0.0
	move_and_slide()

	# GÜVEN KANALI: yönelim. +1 oyuncuya dönük · 0 yan · −1 sırtı dönük.
	# Cevap verirken oyuncuya döner. Bu bir jest DEĞİL, fizik: sana doğru
	# yürüyen biri sana bakar. Düşük güven zaten cevap vermediği için o
	# seviyede bu dal hiç açılmaz — üç seviye ekranda ayrık kalır.
	var y := 1.0 if cagriya_cevap_veriyor else D.yonelim(guven)
	var bakis := -yon if y > 0.5 else (yon if y < -0.5 else yon.cross(Vector3.UP))
	var hedef_aci := atan2(bakis.x, bakis.z)
	rotation.y = rotate_toward(rotation.y, hedef_aci, donme_hizi_rad_s * delta)

	# MORAL KANALI: duruş — İKİ parça.
	if _govde:
		_govde.rotation.y = deg_to_rad(model_yon_duzeltme_derece)

		# 2) ALÇALMA (dip moralde oturma). Animasyon kütüphanesi gelene kadar
		#    yer tutucu. TEK BAŞINA "yere gömülmüş" diye okunuyordu; 30°'lik
		#    eğimle birlikte "çökmüş" diye okunuyor. Gerçek çözüm Quaternius
		#    Universal Animation Library'deki oturma klibi (pano: açık borç).
		var hedef_y := _govde_y0 - (oturma_dusumu_m if D.oturuyor_mu(moral) else 0.0)
		_govde.position.y = move_toward(_govde.position.y, hedef_y, oturma_hizi_ms * delta)

	# 1) ÖNE EĞİM (0° / 12° / 30°) — OMURGA KEMİĞİNDEN, gövde kökünden değil.
	#    Önce kökü döndürdüm: pivot AYAKLARDA kaldığı için "öne düşen ağaç"
	#    gibi göründü, üstelik alçalmayla birlikte bacaklar zemine gömüldü.
	#    Ölçüldü: omurga kemiği yerel X'te dönünce baş aşağı ve öne gidiyor —
	#    yani doğru pivot bel. Açı üç omurga kemiğine PAYLAŞTIRILIR; tek
	#    kemiğe verilince bel kırılıyor gibi duruyor.
	#
	#    UYARI: set_bone_pose_rotation pozu DEĞİŞTİRİR, üstüne eklemez.
	#    AnimationTree geldiğinde bu bir SkeletonModifier3D'ye taşınmalı,
	#    yoksa animasyonla çakışır (pano: açık borç).
	if _iskelet and not _omurga.is_empty():
		var pay := deg_to_rad(D.duruş_egimi_derece(moral)) / float(_omurga.size())
		_egim_su_an = move_toward(_egim_su_an, pay, egim_hizi_rad_s * delta)
		for i in _omurga:
			_iskelet.set_bone_pose_rotation(i, Quaternion(Vector3.RIGHT, _egim_su_an))
