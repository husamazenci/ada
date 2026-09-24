extends Node3D

# KÖPRÜ: saf simülasyon ile sahne arasındaki tek bağ.
#
# Simülasyon (betik/sim, betik/ai) sahneyi BİLMEZ; sahne de kural işletmez.
# Bütün geçiş buradan olur. Sebep (AGENTS.md §5.2): arkadaşın davranışı
# pencere açmadan ölçülebilmeli, ve ekranda gördüğümüz o ölçülen şeyin
# kendisi olmalı.

const D := preload("res://betik/sim/dunya.gd")
const K := preload("res://betik/sim/kayit.gd")
const A := preload("res://betik/veri/ayarlar.gd")

## Bir oyun günü kaç GERÇEK saniye sürer. 20 dk = 1200 sn (K-052).
@export_range(60.0, 3600.0, 10.0) var gun_suresi_sn: float = 1200.0
## Askıya alma kaç saniyede bir yazılır (K-006: tek yuvaya SÜREKLİ yazılır).
@export_range(1.0, 60.0, 1.0) var kayit_araligi_sn: float = 5.0
## Geliştirme sondası: hızlandırılmış zaman.
@export_range(1.0, 200.0, 1.0) var zaman_carpani: float = 1.0

var sim
var _bekleyen_eylem := "bekle"
var _kayit_sayaci := 0.0
var _arkadas: Node3D

func _ready() -> void:
	sim = D.new()
	_arkadas = get_node_or_null(^"Arkadas")
	# Kaldığı yerden devam (K-006). Kipi uymayan yuva atılır ve yeni oyun başlar.
	if K.yuva_var_mi() and K.oku(sim):
		print("[ada] askıya alınmış oyun yüklendi — gün %d" % sim.gun)
	else:
		print("[ada] yeni oyun")

func _process(delta: float) -> void:
	if sim.bitti:
		return
	var dt: float = (delta * zaman_carpani) / gun_suresi_sn
	sim.adim(dt, func(_d): return _eylemi_al())

	if _arkadas:
		_arkadas.guven = sim.guven.deger
		_arkadas.moral = sim.guven.moral

	_kayit_sayaci += delta
	if _kayit_sayaci >= kayit_araligi_sn:
		_kayit_sayaci = 0.0
		K.yaz(sim)

	if sim.bitti:
		_oyun_bitti()

func _eylemi_al() -> String:
	var e := _bekleyen_eylem
	_bekleyen_eylem = "bekle"
	return e

func _unhandled_input(_event: InputEvent) -> void:
	# E = KENDİNE · F = ONA. Oyunun bütün ahlaki seçimi bu iki tuş arasında.
	if Input.is_action_just_pressed("ver"):
		_bekleyen_eylem = "ver_su" if sim.arkadas.en_acil() == "su" else "ver_yiyecek"
	elif Input.is_action_just_pressed("etkiles"):
		if not sim.kap_dolu:
			_bekleyen_eylem = "doldur"
		elif sim.oyuncu.susuzluk >= A.ESIK_HISSEDILIR:
			_bekleyen_eylem = "ic"
		elif sim.oyuncu.aclik >= A.ESIK_HISSEDILIR and sim.yiyecek > 0:
			_bekleyen_eylem = "ye"
		else:
			_bekleyen_eylem = "topla"

func _oyun_bitti() -> void:
	# Ölüm kesinleştiği an yuva SİLİNİR ve oyun biter (K-006). Geri dönüş yok.
	if sim.oyuncu.oldu:
		K.sil()
	print("[ada] oyun bitti: %s · güven %.2f · moral %.2f" % [
		sim.bitis_sebebi, sim.guven.deger, sim.guven.moral])
