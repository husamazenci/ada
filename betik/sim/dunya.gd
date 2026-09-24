class_name Dunya
extends RefCounted

# Dünyanın kuralları. SAF: pencere açmadan, belirlenimci, saniyenin altında koşar.
# Buradaki asıl iş FIRSAT SAYMAK: oyunun tezi "sen açken vermek"e dayanıyor ve
# 120 dakikada o durumun kaç kez doğduğu ölçülmeden tez doğrulanamaz (K-056).

const A := preload("res://betik/veri/ayarlar.gd")
const Ih := preload("res://betik/sim/ihtiyaclar.gd")
const Gv := preload("res://betik/ai/guven.gd")

var gun := 1
var t := 0.0                    # gün içinde 0..1
var oyuncu: Ih = Ih.new()
var arkadas: Ih = Ih.new()
var guven: Gv = Gv.new()

func _init() -> void:
	# Arkadaşın ihtiyaçtan ölme yolu KAPALIDIR (K-062). Ölümü yalnızca
	# Guven.olebilir_mi() üzerinden gelir: görünür çöküş + müdahale penceresi
	# + en erken 6. gün. Oyuncuda bu yol açıktır.
	arkadas.ihtiyactan_olebilir = false
	# 1. gün gün batımında başlar (K-063).
	t = A.GUN1_BASLANGIC_T

var yiyecek := 2                # oyuncunun taşıdığı porsiyon
var kap_dolu := true            # TEK kap — bir dolum bir kişilik (K-056)
var mesafe_m := 3.0
var ates_yaniyor := false
var oyuncu_atesin_isiginda := false
var arkadas_atesin_isiginda := false
var arkadas_gitti := false
var arkadas_oldu := false
var bitti := false
var bitis_sebebi := ""

# --- ölçüm ---
var firsat_sayisi := 0
var alinan_firsat := 0
var ihanet_sayisi := 0
var _firsat_acik := false
var _bugun_toplandi := 0
var arkadas_zorla_aldi := 0
var gunluk: Array = []
var duyumlar: Array = []

func gece_mi() -> bool:
	return t >= A.ALACAKARANLIK_BITIS

func goruyor_mu() -> bool:
	# Algı dürüstlüğü: arkadaş yalnızca gördüğünü değerlendirir.
	var menzil := A.GORUS_MESAFESI_M
	if gece_mi() and not _ates_isiginda_mi():
		menzil *= A.GECE_GORUS_CARPANI
	return mesafe_m <= menzil and not arkadas_gitti and not arkadas.oldu

func _ates_isiginda_mi() -> bool:
	# İKİSİ de ateşin çemberinde olmalı (K-058). Ateş başında geçen normal
	# kamp gecesi gündüz gibi okunur; ama düşük güvende arkadaş çemberin
	# DIŞINDA durur — o zaman yine yanına gitmek gerekir.
	return ates_yaniyor and oyuncu_atesin_isiginda and arkadas_atesin_isiginda

func firsat_var_mi() -> bool:
	# Bedelli fırsat: İKİSİ de muhtaç · elde kaynak var · arkadaş GÖRÜYOR.
	# Üçü birden olmadan verilen şey "ucuz jest"tir ve güveni yükseltmez.
	if arkadas_gitti or arkadas.oldu or not goruyor_mu():
		return false
	if not arkadas.muhtac_mi() or not oyuncu.muhtac_mi():
		return false
	var ne := arkadas.en_acil()
	if ne == "yiyecek":
		return yiyecek > 0 and oyuncu.aclik >= A.ESIK_HISSEDILIR
	if ne == "su":
		return kap_dolu and oyuncu.susuzluk >= A.ESIK_HISSEDILIR
	return false

func adim(dt: float, politika: Callable) -> void:
	# Politika, ihtiyaçlar İLERLEDİKTEN ve fırsat mandalı güncellendikten SONRA
	# sorulur. Önce sorulursa oyuncu bir önceki karenin dünyasına karar verir:
	# fırsat olmadığını sanıp yemek yer, oysa o an fırsat doğmuştur ve jest
	# ihanete dönüşür. İlk koşuda tam olarak bu oldu — fedakâr politika 6 kez
	# ihanet etti.
	if bitti:
		return

	var uyuyor := gece_mi()
	for d in oyuncu.ilerle(dt, false):
		duyumlar.append("gün %d: %s" % [gun, "açsın" if d == "aclik" else "susadın"])
	arkadas.ilerle(dt, uyuyor)

	# Fırsat mandalı: bir epizot bir kez sayılır, her karede değil.
	var simdi := firsat_var_mi()
	if simdi and not _firsat_acik:
		_firsat_acik = true
		firsat_sayisi += 1
	elif not simdi:
		_firsat_acik = false

	_eylemi_uygula(politika.call(self))
	_arkadasin_kendi_isi(dt)

	guven.ilerle(arkadas.baski(), dt)

	# Gidiş: güven dibe vursa bile 5. günden önce OLMAZ (K-055).
	if not arkadas_gitti and guven.deger <= 0.05 and gun >= 5:
		arkadas_gitti = true
	if not arkadas_oldu and guven.olebilir_mi(gun) and t < 0.1:
		arkadas_oldu = true
		arkadas.oldu = true

	t += dt
	if t >= 1.0:
		_gun_bitti()

func _eylemi_uygula(eylem: String) -> void:
	var firsatti := firsat_var_mi()
	match eylem:
		"ver_yiyecek":
			if yiyecek > 0:
				yiyecek -= 1
				arkadas.ye()
				if firsatti and goruyor_mu():
					if guven.bedelli_jest():
						alinan_firsat += 1
		"ver_su":
			if kap_dolu:
				kap_dolu = false
				arkadas.ic()
				if firsatti and goruyor_mu():
					if guven.bedelli_jest():
						alinan_firsat += 1
		"ye":
			if yiyecek > 0:
				yiyecek -= 1
				oyuncu.ye()
				# Onun gözünün önünde, o muhtaçken yemek: düşüş tablosu (K-055)
				if firsatti and goruyor_mu():
					guven.ihanet()
					guven.ihmal_ekle(A.IHMAL_VERMEME)
					ihanet_sayisi += 1
		"ic":
			if kap_dolu:
				kap_dolu = false
				oyuncu.ic()
				if firsatti and goruyor_mu():
					guven.ihanet()
					guven.ihmal_ekle(A.IHMAL_VERMEME)
					ihanet_sayisi += 1
		"topla":
			# Gündüz ve günlük sınır içinde. Kıtlık burada gerçek oluyor.
			if not gece_mi() and _bugun_toplandi < A.GUNLUK_YIYECEK_BULUNUR:
				yiyecek += 1
				_bugun_toplandi += 1
		"doldur":
			kap_dolu = true
		"uzaklas":
			mesafe_m = 40.0
		"yaklas":
			mesafe_m = 3.0
		_:
			pass

func _arkadasin_kendi_isi(dt: float) -> void:
	# İNSAN HİSSİ, 1. madde (K-056): sen olmasan da bir şey yapar.
	#
	# KITLIK DÜZELTMESİ (K-062). Önceden arkadaş açlığını BEDAVA azaltıyordu:
	# havuza hiç baskı binmiyordu, günlük toplama tavanı hiç bağlamıyordu
	# (ölçüldü: 0 adım) ve bir toplama gününü kaçırmanın etkisi tam sıfırdı.
	# Kıtlık kâğıtta vardı, oyunda yoktu. Artık arkadaş da HAVUZDAN yer.
	if arkadas_gitti or arkadas.oldu:
		return
	if guven.cokuyor_mu():
		return          # çökmüşken kendi işini yapamaz — bakıma muhtaç

	# Su dere kampta olduğu için ikisi için de bedava (K-056).
	if arkadas.susuzluk >= A.ESIK_HISSEDILIR:
		arkadas.susuzluk = maxf(arkadas.susuzluk - dt * 2.0, 0.0)

	# Yiyecek: havuzdan yer. Çok açsa ve güven dipteyse SORMADAN alır (K-026).
	if arkadas.aclik >= A.ESIK_AGIR and yiyecek > 0:
		yiyecek -= 1
		arkadas.ye()
		if guven.deger <= A.GUVEN_DUSUK_UST:
			arkadas_zorla_aldi += 1

func _arkadasin_katkisi() -> void:
	# Güvenin MADDİ karşılığı: güvendiği biri için toplar, güvenmediği için
	# kendine saklar. Böylece güven yalnızca davranışta değil, kilerde de
	# okunur — ve düşük güven hayatta kalmayı gerçekten zorlaştırır.
	if arkadas_gitti or arkadas.oldu or guven.cokuyor_mu():
		return
	if guven.deger >= A.GUVEN_YUKSEK_ALT:
		yiyecek += 1
	elif guven.deger > A.GUVEN_DUSUK_UST and gun % 2 == 0:
		yiyecek += 1

func _gun_bitti() -> void:
	gunluk.append({
		"gun": gun, "guven": guven.deger, "moral": guven.moral,
		"ihmal": guven.ihmal, "seviye": guven.seviye(),
		"firsat": firsat_sayisi, "alinan": alinan_firsat,
	})
	guven.gun_dondu()
	_bugun_toplandi = 0
	_arkadasin_katkisi()
	t = 0.0
	gun += 1
	if oyuncu.oldu:
		bitti = true; bitis_sebebi = "oyuncu öldü"
	elif gun > A.TOPLAM_GUN:
		bitti = true; bitis_sebebi = "hikâye bitti"
	elif gun > A.GUVENLIK_TAVANI_GUN:
		bitti = true; bitis_sebebi = "güvenlik tavanı"
