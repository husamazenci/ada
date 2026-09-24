class_name Kopek
extends RefCounted

# YABAN KÖPEĞİ — dilimin tek tehdidi (K-071).
#
# Değişmez kural (K-049, kullanıcı kararı): **arkadaş tehditten ÖLMEZ, senin
# yüzünden ölür.** Hayvan onu yaralar, yıpratır, korkutur — öldürmez. O yüzden
# bu modül kimseyi öldürmez; yalnızca NE OLDUĞUNU söyler, sonucu `Dunya`
# uygular. Ölüm yolu tek: birikmiş ihmal (Guven.olebilir_mi).
#
# UYARISIZ SALDIRI YOK (tasarım §3. gün): uluma → ışığın sınırında siluet →
# saldırı. Oyuncunun hazırlanmak için üç fırsatı var. Bu sıra kasıtlı: bir
# tehdit ancak GÖRÜLEBİLİYORSA hazırlık anlamlı olur, ve hazırlığın anlamı
# yoksa "kötü şans ölümü" doğar — oyunun reddettiği şey tam olarak o.
#
# ATEŞ CAYDIRIR. Yakıt sistemiyle (K-070) doğrudan bağlı: ateşi besleyen
# oyuncu kenarda duran bir siluet görür ve köpek çekilir; ateşi söndüren
# oyuncu saldırıya uğrar. Ateşin oyundaki karşılığı burada somutlaşıyor.

const A := preload("res://betik/veri/ayarlar.gd")

enum { YOK, ULUMA, KENARDA, SALDIRIYOR }

var durum: int = YOK
var _kalan := 0.0
var _bu_gece_geldi := false

# --- ölçüm ---
var gorunme_sayisi := 0
var saldiri_sayisi := 0
var caydirma_sayisi := 0

func sifirla_gece() -> void:
	# Bir gecede bir epizot. Gün dönüşünde çağrılır.
	_bu_gece_geldi = false
	durum = YOK
	_kalan = 0.0

func cezbediyor_mu(gece: bool, gun: int, yiyecek: int, ates_yakit: float) -> bool:
	# Neden gelir: yiyecek kokusu, ya da ateşin zayıflaması. İkisi de yoksa
	# adanın öteki tarafında kalır.
	if not gece or gun < A.KOPEK_ILK_GUN:
		return false
	return yiyecek > 0 or ates_yakit < A.KOPEK_CAYDIRAN_YAKIT

func caydirildi_mi(ates_yaniyor: bool, ates_yakit: float) -> bool:
	return ates_yaniyor and ates_yakit >= A.KOPEK_CAYDIRAN_YAKIT

## dt gün kesridir (dünya saatine ait: gecenin uzunluğuyla ölçeklenmeli).
## Dönüş: bu adımda doğan OLAY — "" · "uluma" · "kenarda" · "saldiri" · "cekildi"
func ilerle(dt: float, gece: bool, gun: int, yiyecek: int,
		ates_yaniyor: bool, ates_yakit: float) -> String:
	if not gece:
		if durum != YOK:
			durum = YOK
			_kalan = 0.0
		return ""

	match durum:
		YOK:
			if _bu_gece_geldi:
				return ""
			if not cezbediyor_mu(gece, gun, yiyecek, ates_yakit):
				return ""
			_bu_gece_geldi = true
			durum = ULUMA
			_kalan = A.KOPEK_ULUMA_SURESI
			gorunme_sayisi += 1
			return "uluma"
		ULUMA:
			_kalan -= dt
			if _kalan > 0.0:
				return ""
			durum = KENARDA
			_kalan = A.KOPEK_KENAR_SURESI
			return "kenarda"
		KENARDA:
			_kalan -= dt
			if _kalan > 0.0:
				return ""
			# KARAR ANI. Ateş güçlüyse çemberin dışında kalır ve çekilir.
			# Bu, ateşi beslemenin TEK somut karşılığı: hazırlık işe yarıyor.
			if caydirildi_mi(ates_yaniyor, ates_yakit):
				durum = YOK
				caydirma_sayisi += 1
				return "cekildi"
			durum = SALDIRIYOR
			_kalan = A.KOPEK_SALDIRI_PENCERESI
			return "saldiri"
		SALDIRIYOR:
			_kalan -= dt
			if _kalan > 0.0:
				return ""
			durum = YOK
			_kalan = 0.0
			saldiri_sayisi += 1
			return "cozuldu"
	return ""

func saldiri_penceresi_acik_mi() -> bool:
	return durum == SALDIRIYOR

func ozet() -> String:
	return "köpek: görünme %d · saldırı %d · caydırma %d" % [
		gorunme_sayisi, saldiri_sayisi, caydirma_sayisi]
