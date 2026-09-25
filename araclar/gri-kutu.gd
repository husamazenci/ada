extends SceneTree

# GRİ KUTU KAPISI — görsel yarısı.
#
# ÖLÇÜT UYARISI: kadrajlar arası piksel farkı KABA bir göstergedir, kanıt
# değildir. Oyuncu kilitli ama arkadaşın oyuncu ÇEVRESİNDEKİ açısal konumu
# kilitli değil — bandına yürürken nereden geldiğine göre ekranın farklı
# yerinde duruyor, ve fark sayısının bir kısmı oradan geliyor. Kanıt olan
# iki şey: (1) ölçülen MESAFELER, (2) üç izleyicinin kaydı izleyip seviyeyi
# adlandırması (kabul kriteri).
# Üç güven seviyesini sırayla zorlar, arkadaşın yerleşmesini bekler, her biri
# için PNG yazar ve gerçekleşen mesafeyi ölçer. --headless ile ÇALIŞMAZ.

const D := preload("res://betik/ai/davranis.gd")
const YERLESME_KARE := 420
const GOSTERIM_KARE := 400   # duruş değişiminin tamamlanması için

var _kare := 0
var _i := 0
var _yerlesti := false
var _arkadas: Node3D
var _oyuncu: Node3D
var _oyuncu_konum := Vector3.INF
var _oturdu_kare := -1
# Her durum İKİ AŞAMALI: önce "yerleşme" değerleriyle konumlanır, sonra
# "gösterim" değerleri uygulanır. Sebep: dip moralde arkadaş yerinden
# kalkamaz — moral düşmeden önce yakına yerleşmezse, uzakta oturan biri
# "düşük güven" diye okunur ve iki kanal görsel olarak karışır. Spektin
# uyardığı tuzak tam buydu.
const DURUMLAR := [
	{"ad": "guven-yuksek",       "yer_g": 0.80, "yer_m": 0.80, "g": 0.80, "m": 0.80},
	{"ad": "guven-orta",         "yer_g": 0.50, "yer_m": 0.80, "g": 0.50, "m": 0.80},
	{"ad": "guven-dusuk",        "yer_g": 0.10, "yer_m": 0.80, "g": 0.10, "m": 0.80},
	{"ad": "yuksek-guven-dip-moral", "yer_g": 0.80, "yer_m": 0.80, "g": 0.80, "m": 0.20},
	{"ad": "dusuk-guven-dip-moral",  "yer_g": 0.10, "yer_m": 0.80, "g": 0.10, "m": 0.20},
	# Çöküş kapının parçasıdır: oyuncunun müdahale etmesi gereken an EKRANDA
	# oturmaktan ayırt edilebilmeli. Ayırt edilemiyorsa o son ulaşılamaz.
	{"ad": "cokus",                  "yer_g": 0.80, "yer_m": 0.80, "g": 0.80, "m": 0.05},
	# ORTA MORAL: spektin 12°'lik omuz düşüşü. Aynı mesafe, aynı klip ("dur"),
	# tek fark omuz/baş eğimi — kapının en ince ayrımı bu.
	{"ad": "orta-moral",             "yer_g": 0.80, "yer_m": 0.80, "g": 0.80, "m": 0.50},
]

func _mesafe() -> float:
	return Vector2(_arkadas.global_position.x - _oyuncu.global_position.x,
		_arkadas.global_position.z - _oyuncu.global_position.z).length()

func _initialize() -> void:
	var sahne := load("res://sahne/dunya.tscn")
	if sahne == null:
		printerr("ÇALIŞTIRILAMADI: sahne yüklenemedi"); quit(2); return
	root.add_child(sahne.instantiate())

func _process(_d: float) -> bool:
	if _arkadas == null:
		_arkadas = root.find_child("Arkadas", true, false)
		_oyuncu = root.find_child("Oyuncu", true, false)
		if _arkadas == null or _oyuncu == null:
			printerr("ÇALIŞTIRILAMADI: Arkadas/Oyuncu bulunamadı"); quit(2); return true
		print("%-24s %-8s %-14s %s" % ["durum", "mesafe", "animasyon", "kadraj"])
	# KAMERAYI KİLİTLE. Kilitsizken kadrajlar arasında ufuk 68 piksel kaydı
	# (yerçekimiyle oturma + kamera salınımı), ve iki kadrajı piksel piksel
	# karşılaştırmak anlamsız hâle geldi: farkın çoğu arkadaştan değil zemin
	# ile gökyüzü sınırından geliyordu. Ölçüm aracı ölçtüğü şeyden başka
	# hiçbir şeyin değişmediğini garanti etmeli (§5.7).
	if _oyuncu_konum == Vector3.INF:
		if _kare > 120:
			_oyuncu_konum = _oyuncu.global_position
		_kare += 1
		return false
	_oyuncu.set("velocity", Vector3.ZERO)
	_oyuncu.global_position = _oyuncu_konum
	var kam := _oyuncu.get_node_or_null(^"Kamera")
	if kam:
		kam.position = Vector3(0.0, _oyuncu.get("goz_yuksekligi_m"), 0.0)

	var d: Dictionary = DURUMLAR[_i]
	_kare += 1
	# 1. aşama: HEDEFE VARANA KADAR yerleş (sabit kare sayısı yetmiyordu —
	# önceki durumdan kalan mesafeye göre gereken süre değişiyor).
	if not _yerlesti:
		_arkadas.set("guven_zorla", d["yer_g"])
		_arkadas.set("moral_zorla", d["yer_m"])
		var su_an := _mesafe()
		if absf(su_an - D.hedef_mesafe_m(d["yer_g"])) < 0.35:
			_yerlesti = true
			_kare = 0
		elif _kare > 3000:
			printerr("ÇALIŞTIRILAMADI: %s yerleşemedi (%.2f m)" % [d["ad"], su_an])
			quit(2); return true
		return false
	_arkadas.set("guven_zorla", d["g"])
	_arkadas.set("moral_zorla", d["m"])

	# 2. aşama: gösterim değerleri OTURANA KADAR bekle. Sabit kare sayısı
	# zamanlamaya duyarlıydı — iki koşu farklı sonuç verdi (bir seferinde
	# 6.00 m, ötekinde 8.28 m). Koşula bağlanınca belirlenimci oluyor.
	# Gösterim, ANİMASYON DURUMU oturana kadar bekler. Önce gövdenin y'sine
	# bakıyordu (kapsül dönemi), sonra o sayı sabit yazılıydı ve gerçek gövde
	# gelince sonda "gösterimde oturmadı" diye çöktü. Artık ölçtüğü şeyin
	# kendi adına bakıyor: hangi klip oynuyor.
	var beklenen := D.durus_animasyonu(d["m"], 0.0)
	# Durum adının doğru olması YETMEZ: tek seferlik klipler (çöküş, oturmaya
	# giriş) daha oynuyor olabilir. İlk koşuda çöküş kadrajı arkadaşı hâlâ
	# AYAKTA yakaladı — Death01 2.40 sn sürüyor ve sonda 0.2 sn'de bakıyordu.
	# "_gecis" boşsa tek seferlik klip bitmiş ve son karede donmuş demektir.
	var durum_tamam: bool = String(_arkadas.get("_durum")) == beklenen \
		and String(_arkadas.get("_gecis")).is_empty()
	var durdu: bool = _arkadas.velocity.length() < 0.02
	var mesafe_tamam: bool = absf(_mesafe() - D.hedef_mesafe_m(d["g"])) < 0.35 or D.oturuyor_mu(d["m"])
	if not (durum_tamam and durdu and mesafe_tamam):
		_oturdu_kare = -1
		if _kare > 3000:
			printerr("ÇALIŞTIRILAMADI: %s gösterimde oturmadı (durum '%s', beklenen '%s')" % [
				d["ad"], str(_arkadas.get("_durum")), beklenen])
			quit(2); return true
		return false

	# HARMANIN BİTMESİNİ DE BEKLE. Durum adı doğru olduğu ANDA koşullar
	# sağlanıyor ama beden hâlâ önceki klipten geçiş yapıyor: orta moral
	# kadrajında arkadaş YERDE YATIYORDU, çünkü bir önceki durum çöküştü ve
	# Death01'den Idle'a harman daha yeni başlamıştı. Klip adı "Idle"dı,
	# görüntü Death01'di — ölçtüğüm şey yine ölçmek istediğim şey değildi.
	if _oturdu_kare < 0:
		_oturdu_kare = _kare
	if _kare - _oturdu_kare < 90:
		return false

	var olculen := _mesafe()
	var durum := String(_arkadas.get("_durum"))
	RenderingServer.force_draw()
	root.get_texture().get_image().save_png("res://.scratch/gri-%s.png" % d["ad"])
	print("%-24s %-8.2f %-14s .scratch/gri-%s.png" % [d["ad"], olculen, durum, d["ad"]])

	_i += 1
	_kare = 0
	_oturdu_kare = -1
	_yerlesti = false
	if _i >= DURUMLAR.size():
		quit(0); return true
	return false
