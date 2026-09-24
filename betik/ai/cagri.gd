class_name Cagri
extends RefCounted

# ÇAĞIRMA — oyuncunun güveni OKUMA yolu (K-068).
#
# Ekranda ilişki barı yoktur (AGENTS.md §2); güven yalnızca davranıştan
# okunur. Oyuncunun elindeki tek SORU budur: seslen, ne olduğuna bak.
#
#   yüksek → hemen döner ve gelir            (0,4–1,2 sn)
#   orta   → gecikir, gelir, mesafesini korur (2–5 sn)
#   düşük  → GELMEZ. Cevapsızlık oyunun en yüksek sesli işaretidir.
#
# Dört şey burada YAPIYLA sağlanıyor, sonradan denetlenerek değil:
#
# 1) Çağırmak güveni YÜKSELTMEZ. Konuşmak bedelsizdir; "ucuz jestler tek
#    başına yükseltmez" (§2). DÜŞÜRMEZ de — güveni okumanın tek yolu güvene
#    mal olsaydı oyuncu bakmaktan cezalandırılırdı ve bir daha bakmazdı.
#
# 2) Karar ÇAĞRI ANINDA bir kez verilir, her karede yeniden değil. Beklerken
#    güven değişirse cevap değişmemeli; yoksa gecikme hiçbir şey anlatmaz.
#
# 3) Bekleyen çağrı varken yeni çağrı sayacı SIFIRLAMAZ. Aksi hâlde tuşa
#    basmayı sürdüren oyuncuya arkadaş hiç ulaşamaz, oyuncu bunu "düşük
#    güven" diye okur — oyunun en önemli işaretini bir tuş takırtısı taklit
#    eder.
#
# 4) Cevapsızlık, EN YAVAŞ cevaptan uzun sürer (Davranis.cagri_sessizlik_sn).
#    Kısa olsaydı orta güvendeki gecikme de "gelmiyor" diye okunurdu.
#
# BİRİM UYARISI: buradaki bütün süreler GERÇEK SANİYEdir, gün kesri değil.
# Sebep: bir çağrıya dönme süresi bedene ait, dünya saatine değil. Dünya
# saati hızlandırıldığında (sonda, ×50) tepki gecikmesi hızlanmamalı —
# yoksa ölçtüğümüz şey ölçmek istediğimiz şey olmaz (§5.8).

const D := preload("res://betik/ai/davranis.gd")
const A := preload("res://betik/veri/ayarlar.gd")

enum { YOK, BEKLIYOR, GELIYOR, GELMEDI }

var durum: int = YOK
var _kalan_sn := 0.0        # BEKLIYOR: gecikme · GELIYOR/GELMEDI: pencere
var _soguma_sn := 0.0       # iki çağrı arası en az bekleme
var _karar_guven := 0.0     # çağrı anındaki güven — sonra DEĞİŞSE de geçerli

# Gecikme bandın İÇİNDE rastgele seçilir; makine belirlenimci başlar ki test
# aynı sayıyı görsün. Oyun kendi tohumunu atar (betik/cizim/oyun.gd).
var rastgele := RandomNumberGenerator.new()

# --- ölçüm (§5.8: ne olduğunu saymadan tez doğrulanamaz) ---
var cagri_sayisi := 0
var yanitlanan := 0
var yanitsiz := 0
var duyulmayan := 0

func _init() -> void:
	rastgele.seed = 20260924

func mesgul_mu() -> bool:
	return durum != YOK

func yanit_veriyor_mu() -> bool:
	return durum == GELIYOR

func bekliyor_mu() -> bool:
	return durum == BEKLIYOR

## Oyuncu seslendi. Dönüş: ses AĞZINDAN ÇIKTI mı (cevap geldi mi DEĞİL).
## `duyar_mi` menzil/gidiş/ölüm kararıdır ve dünyaya aittir — burada değil.
func cagir(guven: float, duyar_mi: bool) -> bool:
	if _soguma_sn > 0.0 or mesgul_mu():
		return false
	cagri_sayisi += 1
	_soguma_sn = D.CAGRI_BEKLEME_SN
	_karar_guven = guven

	if not duyar_mi:
		# Ses boşluğa gitti. Bu bir REDDETME DEĞİL; ayrı sayılır, çünkü
		# ekranda ikisi aynı görünür ve karıştırılırsa menzil hatası
		# "arkadaş küsmüş" diye okunur.
		duyulmayan += 1
		return true

	var band := D.cagriya_tepki_sn(guven)
	if band.x < 0.0:
		durum = GELMEDI
		_kalan_sn = D.cagri_sessizlik_sn()
		yanitsiz += 1
		return true

	durum = BEKLIYOR
	_kalan_sn = rastgele.randf_range(band.x, band.y)
	return true

## dt GERÇEK saniyedir (yukarıdaki birim uyarısı).
## `gelebiliyor_mu`: moral kanalı. Karar güvenle verilir, ama çökmüş bir
## beden kalkamaz — "gelmeye karar etti, kalkamadı" oyunun en acı anıdır ve
## kanal karışması DEĞİLdir: güven nereye gideceğini, moral gidebilip
## gidemeyeceğini söyler.
func ilerle(dt_sn: float, gelebiliyor_mu: bool = true) -> void:
	if _soguma_sn > 0.0:
		_soguma_sn = maxf(_soguma_sn - dt_sn, 0.0)
	if durum == YOK:
		return
	_kalan_sn -= dt_sn
	if _kalan_sn > 0.0:
		return
	match durum:
		BEKLIYOR:
			if gelebiliyor_mu:
				durum = GELIYOR
				_kalan_sn = D.CAGRI_YANIT_SN
				yanitlanan += 1
			else:
				# Kalkamadı. Sessizlik penceresi kadar öyle kalır; oyuncu
				# bekler ve gelmediğini görür.
				durum = GELMEDI
				_kalan_sn = D.cagri_sessizlik_sn()
				yanitsiz += 1
		GELIYOR, GELMEDI:
			durum = YOK
			_kalan_sn = 0.0

func kes() -> void:
	# Sahne/cutscene devraldığında ya da arkadaş gidip öldüğünde.
	durum = YOK
	_kalan_sn = 0.0

func ozet() -> String:
	return "çağrı %d · yanıtlanan %d · yanıtsız %d · duyulmayan %d" % [
		cagri_sayisi, yanitlanan, yanitsiz, duyulmayan]
