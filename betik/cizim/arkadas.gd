extends CharacterBody3D

# Arkadaşın gövdesi. Bu betik KARAR VERMEZ — `betik/ai/davranis.gd`'nin
# söylediğini uygular. Sebep: davranışın ayırt edilebilirliği pencere açmadan
# sınanabilmeli (testler/davranis.gd), ekranda gördüğümüz o sınanan şeyin
# kendisi olmalı.
#
# His sayıları @export: kullanıcı oyun çalışırken ayarlar (AGENTS.md §6.2).

const D := preload("res://betik/ai/davranis.gd")
const An := preload("res://betik/veri/animasyonlar.gd")

@export_group("Kime")
@export var oyuncu_yolu: NodePath = ^"../Oyuncu"

@export_group("His")
@export_range(0.2, 4.0, 0.05) var taban_hiz_ms: float = 1.6
@export_range(0.5, 20.0, 0.1) var ivme_ms2: float = 6.0
@export_range(0.5, 12.0, 0.1) var donme_hizi_rad_s: float = 3.0
@export_range(0.05, 1.5, 0.05) var mesafe_olu_bant_m: float = 0.4
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
# "Bekle" sözü açık. Sözün EKRANDAKİ tek karşılığı bu: yerinden kıpırdamaz,
# seni takip etmez, ama döner ve bakar. Görünmeyen bir söz, tutulup
# tutulmadığı anlaşılmayan bir sözdür.
var bekliyor := false
## Köprü yazar. Ölü beden KIPIRDAMAZ — çöküşü ölümden ayıran tek şey bu.
var oldu := false

var _oyuncu: Node3D
var _govde: Node3D
var _iskelet: Skeleton3D
var _oynatici: AnimationPlayer
var _eklenti: SkeletonModifier3D
var _durum := ""            # oynayan OYUN durumu (klip adı değil)
var _gecis := ""            # bitmesini beklediğimiz tek seferlik klip

func _ready() -> void:
	_oyuncu = get_node_or_null(oyuncu_yolu)
	_govde = get_node_or_null(^"Govde")
	if _govde:
		_iskelet = _govde.find_child("Skeleton3D", true, false)
	if _govde:
		_oynatici = _govde.get_node_or_null(^"Animasyon")
	if _oynatici:
		_oynatici.animation_finished.connect(_klip_bitti)
	if _iskelet:
		# Eklenti İSKELETİN ÇOCUĞU olmak zorunda; Godot modifier'ları yalnızca
		# orada çalıştırıyor. Kodla eklemek sahnede unutulmasını imkânsız
		# kılıyor — model değişse bile yerini bulur.
		_eklenti = preload("res://betik/cizim/beden-eklentisi.gd").new()
		_eklenti.name = "BedenEklentisi"
		_iskelet.add_child(_eklenti)
	else:
		push_error("[ada] Arkadas/Govde/Animasyon yok — arkadaş T-pozunda kalır")

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
	if bekliyor:
		tempo = 0.0          # söz verildi: olduğu yerde kalır
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

	# MORAL KANALI: duruş artık ANİMASYONDAN geliyor.
	# Elle omurga bükme ve gövdeyi alçaltma kaldırıldı: ikisi de kapsül
	# döneminin yer tutucularıydı ve klip gelince onunla çakışırlardı
	# (set_bone_pose_rotation pozu DEĞİŞTİRİR, üstüne eklemez).
	if _govde:
		_govde.rotation.y = deg_to_rad(model_yon_duzeltme_derece)
	if _eklenti:
		_eklenti.moral = moral
		_eklenti.canli = not oldu
	_animasyonu_surdur(Vector2(velocity.x, velocity.z).length())

func _animasyonu_surdur(hiz_ms: float) -> void:
	if _oynatici == null:
		return
	# Hangi klip oynayacağına SAF katman karar verir (Davranis), burası
	# yalnızca uygular — ve geçişleri yönetir.
	var istenen := D.durus_animasyonu(moral, hiz_ms)
	if not _gecis.is_empty():
		return                      # tek seferlik klip bitene kadar karışma
	if istenen == _durum:
		# Yürüyüş temposu moralden gelir: orta moralde ×0.70 hızla yürür.
		# Klibi yavaşlatmak ŞART — yoksa ayaklar yerde kayar.
		if _durum == "yuru":
			_oynatici.speed_scale = maxf(D.tempo_carpani(moral), 0.1)
		return

	# Oturmaya GİRİŞ ve ÇIKIŞ ayrı kliplerdir. Doğrudan oturma döngüsüne
	# atlansaydı arkadaş ayakta dururken bir karede yere ışınlanırdı.
	if istenen == "otur" and _durum != "otur_giris":
		_oynat("otur_giris", 0.15)
		return
	# Oturmaktan ÇÖKMEYE giderken ayağa KALKMAZ. İlk yazışımda kalkıyordu:
	# moral 0.20'den 0.05'e düşen arkadaş önce doğruluyor, sonra yığılıyordu.
	# Çöküş zaten bir düşüştür; öncesine bir toparlanma koymak onu komik
	# yapıyor ve oyunun en ağır anını bozuyor.
	if _durum in ["otur", "otur_giris"] and istenen not in ["otur", "cokus"]:
		_oynat("otur_cikis", 0.15)
		return
	_oynat(istenen, 0.25)

func _oynat(oyun_durumu: String, harman_sn: float) -> void:
	var klip: String = An.KLIPLER.get(oyun_durumu, "")
	if klip.is_empty() or not _oynatici.has_animation(klip):
		push_error("[ada] klip yok: %s (%s)" % [oyun_durumu, klip])
		return
	_durum = oyun_durumu
	_oynatici.speed_scale = 1.0
	_oynatici.play(klip, harman_sn)
	if oyun_durumu not in An.DONGULU:
		_gecis = oyun_durumu

func _klip_bitti(_ad: StringName) -> void:
	# Tek seferlik klip bitti. Çöküş YERİNDE KALIR — son karede donar.
	# Döngüye alınsaydı arkadaş sonsuza kadar yığılıp yığılıp dururdu; asıl
	# sebep ise şu: çöküş bir olay, bir hareket değil.
	var biten := _gecis
	_gecis = ""
	if biten == "otur_giris":
		_oynat("otur", 0.1)
	elif biten == "otur_cikis":
		_animasyonu_surdur(Vector2(velocity.x, velocity.z).length())
