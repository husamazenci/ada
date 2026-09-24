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
var _soz: CanvasLayer

func _ready() -> void:
	sim = D.new()
	_arkadas = get_node_or_null(^"Arkadas")
	_soz = get_node_or_null(^"Soz")
	# Çağrı gecikmesi bandın İÇİNDE rastgele seçilir. Saf makine belirlenimci
	# başlar ki test aynı sayıyı görsün; tohumu OYUN atar, test atmaz.
	sim.cagri.rastgele.randomize()
	# Kaldığı yerden devam (K-006). Kipi uymayan yuva atılır ve yeni oyun başlar.
	if K.yuva_var_mi() and K.oku(sim):
		print("[ada] askıya alınmış oyun yüklendi — gün %d" % sim.gun)
	else:
		print("[ada] yeni oyun")

func _process(delta: float) -> void:
	if sim.bitti:
		return
	# Sahnedeki GERÇEK mesafe simülasyona geri yazılır. Yoksa algı yalan söyler:
	# arkadaş ekranda 8 m'de dururken sim onu 3 m'de sanıyordu, yani gece görüş
	# daralması, ateş ışığı istisnası ve çağrı menzili hiç bağlamıyordu.
	if _arkadas:
		sim.mesafe_m = _mesafe_m()

	var dt: float = (delta * zaman_carpani) / gun_suresi_sn
	sim.adim(dt, func(_d): return _eylemi_al())

	# Çağrı GERÇEK saniyeyle ilerler, gün kesriyle değil: bir sese dönme süresi
	# bedene ait, dünya saatine değil. Zaman çarpanı ×50 olduğunda arkadaşın
	# refleksi 50 kat hızlanmamalı — ölçtüğümüz şey ölçmek istediğimiz şey
	# olmalı (§5.8).
	sim.cagri_ilerle(delta)

	if _arkadas:
		_arkadas.guven = sim.guven.deger
		_arkadas.moral = sim.guven.moral
		_arkadas.cagriya_cevap_veriyor = sim.cagri.yanit_veriyor_mu()

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
		# F = ONA. Köpek saldırırken "ona" demek ARAYA GİRMEK demektir —
		# yeni bir tuş gerekmiyor ve gerekmemeli: oyunun ahlaki ekseni
		# "kendine mi, ona mı" ikiliğinde duruyor (tasarım §dört tuş).
		# Saldırı anında o eksen en keskin hâlini alıyor.
		if sim.kopek.saldiri_penceresi_acik_mi():
			_bekleyen_eylem = "araya_gir"
		else:
			_bekleyen_eylem = "ver_su" if sim.arkadas.en_acil() == "su" else "ver_yiyecek"
	elif Input.is_action_just_pressed("cagir"):
		# Q = SESLEN. Güvene DOKUNMAZ (K-068): ucuz jest yükseltmez, ve
		# güveni okumanın tek yolu güvene mal olsaydı oyuncu bakmaktan
		# cezalandırılırdı. Cevabı arkadaşın bedeni verir — ya da vermez.
		if sim.cagir() and _soz:
			_soz.soyle("soz.hey")
	elif Input.is_action_just_pressed("etkiles"):
		_bekleyen_eylem = _baglama_gore()

func _oyun_bitti() -> void:
	# Ölüm kesinleştiği an yuva SİLİNİR ve oyun biter (K-006). Geri dönüş yok.
	if sim.oyuncu.oldu:
		K.sil()
	print("[ada] oyun bitti: %s · güven %.2f · moral %.2f · %s" % [
		sim.bitis_sebebi, sim.guven.deger, sim.guven.moral, sim.cagri.ozet()])

func _mesafe_m() -> float:
	var o := get_node_or_null(^"Oyuncu")
	if o == null or _arkadas == null:
		return sim.mesafe_m
	var oy: Node3D = o
	var fark: Vector3 = _arkadas.global_position - oy.global_position
	fark.y = 0.0
	return fark.length()


func _baglama_gore() -> String:
	# E BAĞLAMA GÖRE davranır (tasarım §dört tuş). Bağlam ŞU AN simülasyon
	# durumundan çıkıyor; DOĞRU yeri baktığın nesne olacak — gri kutuda henüz
	# ateş, dere ve yığın yok. O nesneler girince bu merdiven silinir ve
	# yerini "neye bakıyorsun" alır (pano: açık borç). Sıralama keyfî değil,
	# ACİLİYETE göre:
	#
	#   gece + ateş sönmüş  → ateşi yak   (gecenin en acil işi)
	#   gece + yakıt azalmış → yakıt at
	#   gündüz              → odun, sonra su, sonra yiyecek
	if sim.gece_mi():
		if not sim.ates_yaniyor and sim.odun > 0 and sim.gun >= A.ATES_ILK_GUN:
			return "ates_yak"
		if sim.ates_yaniyor and sim.ates_yakit < A.ATES_YAKIT_ESIGI and sim.odun > 0:
			return "yakit_at"
	if not sim.ates_yaniyor and sim.odun > 0 and sim.gun >= A.ATES_ILK_GUN:
		return "ates_yak"
	if not sim.kap_dolu:
		return "doldur"
	if sim.oyuncu.susuzluk >= A.ESIK_HISSEDILIR:
		return "ic"
	if sim.oyuncu.aclik >= A.ESIK_HISSEDILIR and sim.yiyecek > 0:
		return "ye"
	if sim.odun < A.GUNLUK_ODUN_BULUNUR and not sim.gece_mi():
		return "odun_topla"
	return "topla"
