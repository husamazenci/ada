class_name Davranis
extends RefCounted

# Arkadaşın EKRANDAKİ davranışı — saf. Çizim katmanı bunu yalnızca UYGULAR.
#
# İki eksen, iki KANAL (K-005, davranış tablosu):
#   GÜVEN → mesafe, yönelim, bakış   (kime doğru, ne kadar yakın)
#   MORAL → tempo, duruş, duraklama  (ne hızla, hangi bedenle)
#
# Karıştırılırlarsa "çağırınca gecikmeli gelir" (orta güven) ile "yavaşlar"
# (orta moral) ekranda aynı görünür ve kabul kriteri çöker.
#
# Sayılar animasyon spektinden (belge/ANIMASYON-SPEKTI.md §3) geliyor.
# Burada saf tutulmalarının sebebi: üç seviyenin ayırt edilebilirliği
# pencere açmadan, sayıyla sınanabilsin.

const A := preload("res://betik/veri/ayarlar.gd")

# --- GÜVEN KANALI ---

static func mesafe_bandi_m(guven: float) -> Vector2:
	# Spekt §3: yüksek 1,5–2,5 · orta 3,5–5,5 · düşük 7–10
	if guven >= A.GUVEN_YUKSEK_ALT:
		return Vector2(1.5, 2.5)
	if guven < A.GUVEN_DUSUK_UST:
		return Vector2(7.0, 10.0)
	return Vector2(3.5, 5.5)

static func hedef_mesafe_m(guven: float) -> float:
	var b := mesafe_bandi_m(guven)
	return (b.x + b.y) * 0.5

static func yonelim(guven: float) -> float:
	# +1 = gövdesi oyuncuya dönük · 0 = yan · −1 = sırtı dönük
	if guven >= A.GUVEN_YUKSEK_ALT:
		return 1.0
	if guven < A.GUVEN_DUSUK_UST:
		return -1.0
	return 0.0

static func goz_temasi_olasiligi(guven: float) -> float:
	# Düşük güvende göz temasından KAÇINIR (spekt §3).
	if guven >= A.GUVEN_YUKSEK_ALT:
		return 0.70
	if guven < A.GUVEN_DUSUK_UST:
		return 0.0
	return 0.25

static func cagriya_tepki_sn(guven: float) -> Vector2:
	# Spekt §5: yüksek 0,4–1,2 · orta 2–5 · düşükte gelme kararı ÇIKMAZ.
	if guven >= A.GUVEN_YUKSEK_ALT:
		return Vector2(0.4, 1.2)
	if guven < A.GUVEN_DUSUK_UST:
		return Vector2(-1.0, -1.0)     # gelmez
	return Vector2(2.0, 5.0)

static func cagriya_gelir_mi(guven: float) -> bool:
	return cagriya_tepki_sn(guven).x >= 0.0

static func cagri_hedef_mesafe_m(guven: float) -> float:
	# Cevap veren arkadaş KENDİ bandının YAKIN kenarına gelir — bandını
	# TERK ETMEZ. Sebep iki kanal kuralı: mesafe güveni okur. Çağrı herkesi
	# 1,5 m'ye getirseydi mesafe artık güveni değil "en son ne zaman
	# seslendin"i okurdu ve kabul kriteri çökerdi.
	return mesafe_bandi_m(guven).x

static func cagri_sessizlik_sn() -> float:
	# Cevapsızlık EN YAVAŞ cevaptan uzun sürmeli. Kısa olursa oyuncu orta
	# güvende de "gelmiyor" diye okur — oysa gelecektir, daha yoldadır.
	# Bağımsız sayı DEĞİL, türev; ayrı yazılsaydı er geç kayardı (K-060'ın
	# aynı dersi).
	return cagriya_tepki_sn((A.GUVEN_DUSUK_UST + A.GUVEN_YUKSEK_ALT) * 0.5).y + 1.0

## Cevabın ne kadar sürdüğü: bu süre boyunca yakın kenarda durur, sonra
## kendi bandına döner. Sonsuz olsaydı tek bir çağrı mesafeyi kalıcı
## değiştirir, mesafe güveni okumayı bırakırdı.
const CAGRI_YANIT_SN := 8.0
## İki çağrı arası en az bekleme. Oyuncuyu kısıtlamak için değil: arka arkaya
## basılan tuş sürekli mırıltıya dönüşüyor ve sahne komikleşiyor.
const CAGRI_BEKLEME_SN := 1.0

# --- MORAL KANALI ---

static func tempo_carpani(moral: float) -> float:
	# Spekt §3: yüksek ×1,00 · orta ×0,70 · dip ×0 (oturur)
	if moral < A.MORAL_ORTA_ALT:
		return 0.0
	if moral >= 0.66:
		return 1.00
	return 0.70

static func oturuyor_mu(moral: float) -> bool:
	return moral < A.MORAL_ORTA_ALT

static func cokuyor_mu(moral: float) -> bool:
	return moral < A.MORAL_COKUS_ESIGI

static func durus_animasyonu(moral: float, hiz_ms: float) -> String:
	# Hangi klip oynayacağı SAF bir karar. Sahnede değil burada olmasının
	# sebebi: "dip moralde çöküyor mu" sorusu pencere açmadan sınanabilmeli,
	# ve ekranda gördüğümüz o sınanan şeyin kendisi olmalı (§5.2).
	#
	# Moral kanalı BEDENİ seçer; hız yalnızca dur/yürü ayrımını yapar — ve hız
	# zaten tempo_carpani üzerinden yine moralden geliyor. Güven buraya hiç
	# karışmaz: güven MESAFEYİ belirler, mesafe de hızı dolaylı etkiler ama
	# hangi klibin oynadığını değil.
	if cokuyor_mu(moral):
		return "cokus"
	if oturuyor_mu(moral):
		return "otur"
	return "yuru" if hiz_ms > 0.05 else "dur"

static func duruş_egimi_derece(moral: float) -> float:
	# Omuz/baş düşmesi. Dip moralde spektin çöküş tablosuna devredilir.
	if moral >= 0.66:
		return 0.0
	if moral < A.MORAL_ORTA_ALT:
		return 30.0
	return 12.0

static func duraklama_sikligi_hz(moral: float) -> float:
	if moral >= 0.66:
		return 0.0
	if moral < A.MORAL_ORTA_ALT:
		return 0.0     # zaten oturuyor
	return 0.25        # ~4 saniyede bir durup bekler

# --- OKUNABİLİRLİK DENETİMİ ---

static func iki_kanal_ayrik_mi() -> bool:
	# Kabul kriterinin şartı: güven yalnızca mesafe/yönelim/bakışı, moral
	# yalnızca tempo/duruşu değiştirmeli. Biri ötekinin kanalına taşarsa
	# izleyici ikisini ayırt edemez.
	var moraller := [0.20, 0.50, 0.80]
	var ilk_mesafe := hedef_mesafe_m(0.80)
	for m in moraller:
		if not is_equal_approx(hedef_mesafe_m(0.80), ilk_mesafe):
			return false
	var guvenler := [0.10, 0.50, 0.80]
	var ilk_tempo := tempo_carpani(0.80)
	for g in guvenler:
		if not is_equal_approx(tempo_carpani(0.80), ilk_tempo):
			return false
	return true
