class_name Ayarlar
extends RefCounted

# Oyunun BÜTÜN ayarlanabilir sayıları burada. Tek kaynak olmasının sebebi:
# ikinci denemede aynı sabit üç dosyada ayrı ayrı duruyordu ve biri
# değişince öteki ikisi sessizce eski kaldı.
#
# Buradaki sayılar saf simülasyonun sayılarıdır. His sayıları (yürüme hızı,
# kamera salınımı, tepki gecikmesi) BURAYA GİRMEZ — onlar çizim katmanında
# @export olarak durur ve kullanıcı editörde oyun çalışırken ayarlar
# (AGENTS.md §6.2).

# --- Zaman ---
# Bir gün = 1.0 birim. 20 dakikanın içi: gündüz 13, alacakaranlık 2, gece 5.
const GUNDUZ_BITIS := 0.65
const ALACAKARANLIK_BITIS := 0.75
const TOPLAM_GUN := 6

# 1. gün TAM GÜN BATIMINDA başlar (K-063): uçak akşamüstü düşer. Oynanan kısım
# alacakaranlık + gece = ~7 dk. Toplam süre bu yüzden 107 dakikadır, 120 değil;
# kısa ve sert bir açılış kasıtlıdır.
const GUN1_BASLANGIC_T := 0.65
const GUVENLIK_TAVANI_GUN := 10   # hiç katılmayan oyuncuda dünya sonsuza akmasın

# --- İhtiyaçlar ---
# 0 = tok/kanmış, 1 = ölümcül. Gün başına dolma hızı.
const ACLIK_HIZI := 0.40          # ~2.5 günde dibe vurur
const SUSUZLUK_HIZI := 0.83       # ~1.2 günde — su daha sık, bu yüzden yakında
const YORGUNLUK_HIZI := 0.55
const UYKU_TOPARLAMA := 1.6       # gece uyurken yorgunluk bu hızla düşer

# Eşikler. "Aç" olmak duyum cümlesinin ve fırsatın eşiğidir.
const ESIK_HISSEDILIR := 0.50     # "açsın" / "susadın" — bir kez belirir
const ESIK_AGIR := 0.80           # beden okunur biçimde yavaşlar

# İHTİYAÇ BAKIŞI EŞİKLERİ (K-060). Arkadaşın ihtiyacı bakış yönünden okunur:
# aç olan yiyeceğe, susamış olan kaba/dereye bakar. Ekranda gösterge ve kelime
# olmadığı için oyuncu NEYİ vereceğini yalnızca buradan bilir.
#
# Bunlar bağımsız sayı DEĞİL, yukarıdaki eşiklerin TÜREVİ — ve bu kasıtlı.
# Animasyon spekti bakışı 0.55'te açıyordu, oysa fırsat 0.50'de doğuyor:
# [0.50, 0.55) aralığında fırsat var ama ekranda hiçbir işaret yok, oyuncu
# sebebini göremeden güven değişiyordu. İki sayı ayrı yazılırsa er geç
# kayarlar; türev olunca kayamazlar.
const BAKIS_ESIGI_ORTA := ESIK_HISSEDILIR   # fırsatla AYNI anda açılır
const BAKIS_ESIGI_ACIL := ESIK_AGIR

# Histerezis: eşik çevresinde sürekli davranış değişmesini önler (spekt §8).
const BAKIS_KAPANIS_ORTA := 0.45
const BAKIS_KAPANIS_ACIL := 0.70
const ESIK_OLUM := 1.00

# Kıtlık. İki kişi günde ~1.8 porsiyon tüketir (0.40 açlık/gün ÷ 0.45 doyum).
# Günde 2 bulunuyor: yeter ama ANCAK yeter. Fırsatı doğuran şey bu incelik —
# bolluk olsaydı kimse acıkmaz, fedakârlık diye bir şey olmazdı.
const GUNLUK_YIYECEK_BULUNUR := 2

# --- Ateş ve yakıt (K-070) ---
# Ateş YALNIZCA geceleyin yakıt tüketir. Gündüz kor hâlinde durur. Sebep
# oyunsal: ateşin bedeli geceye ait, ve gece yakıt beslemek "ışığın kenarına
# gitmek" demek (tasarım §dilim). Gündüz de yansaydı günlük odun tavanı
# yalnızca gündüzü karşılamaya yeter, gece hiç kurulamazdı.
const ATES_GECE_YAKIT_HIZI := 5.0   # gün başına; gece 0.25 gün → 1.25 yakıt ister
const ODUN_KATKISI := 0.5           # bir kütük ne kadar doldurur
const ATES_YAKIT_TAVANI := 1.0      # ocak bundan fazlasını almaz
const ATES_YAKIT_ESIGI := 0.35      # altında beslenmesi gerekir
const GUNLUK_ODUN_BULUNUR := 4      # gece 1.25 ister (3 kütük); 4 bulunur

# TAVAN KASITLI OLARAK GECENİN ALTINDA: dolu bir ocak (1.00) geceyi
# çıkarmaz (1.25 gerekir). Yani ateş EN AZ İKİ KEZ beslenmeli ve en az bir
# kez gecenin ortasında kalkmak gerekir. Oyunun bu mekanikten istediği şey
# tam olarak o kalkış.

# İlk gece ateşsiz geçer (K-063): ateş 2. günün hediyesi değil, bedeli.
const ATES_ILK_GUN := 2

# --- Yaban köpeği (K-071) ---
# Kurt DEĞİL, yabanileşmiş köpek (kullanıcı kararı): okyanus ortasındaki küçük
# bir adada kurdun varlığı ayrıca açıklama isterdi. Saldırının sebebi de açık:
# yiyecek.
const KOPEK_ILK_GUN := 3              # yazılmış sahne 3. gecede

# UYARISIZ SALDIRI YOK (tasarım §3. gün): uluma → arkadaşın tepkisi → ışığın
# sınırındaki siluet. Oyuncunun hazırlanmak için üç fırsatı var.
const KOPEK_ULUMA_SURESI := 0.015     # gün kesri; 20 dk'lık günde ~18 sn
const KOPEK_KENAR_SURESI := 0.020     # ışığın sınırında durur ve bakar
const KOPEK_SALDIRI_PENCERESI := 0.005  # araya girmek için kalan an (~6 sn)

# ATEŞ CAYDIRIR — ve bu sayı ATEŞ EŞİĞİNDEN TÜREV, bağımsız değil (K-060'ın
# dersi). Ateşe bakan oyuncu ocağı ATES_YAKIT_ESIGI'nin altına düşürmez;
# caydırma eşiği ondan belirgin biçimde AŞAĞIDA olmazsa, besleme ile denetim
# arasındaki o kısacık boşlukta saldırı tetiklenir ve ceza adaletsiz olur.
const KOPEK_CAYDIRAN_YAKIT := ATES_YAKIT_ESIGI * 0.5

# Araya girebilmek için bu kadar yakın olmak gerekir. Uzaktayken basmak
# "denedi ama yetişemedi"dir ve ihanet SAYILMAZ (K-064).
const KURTARMA_MESAFESI_M := 3.0

# Köpek yarası iki gün sürer (tasarım denetimi): 4. gün ağır, 5. gün hafifler.
# Sebep: 5. günün ağırlığı hastalıktan gelmeli, üst üste binen iki engelden değil.
const YARA_SURESI_GUN := 2.0

# --- "Bekle" sözü (K-072) ---
# Söz türü AÇILMADI (kullanıcı kararı): "bekle" yeni bir tür değil, ÇAĞRININ
# bir çeşidi. Q'ya basmak "gel", basılı tutmak "kal" demek. Böylece K-063'ün
# kapalı tür listesi (yalnızca çağrı ve soru) olduğu gibi duruyor — oyun
# oyuncunun tutumunu hâlâ söyleyemiyor.
const SOZ_BASILI_TUTMA_SN := 0.45     # bu kadar tutulursa "gel" değil "kal"

# Sözün ömrü. ADALET ŞARTI: tutmak İSTEYEN oyuncu tutabilmeli. 0.08 gün,
# 20 dakikalık günde ~96 saniye; 1.6 m/s ile ~150 m gidiş-dönüş demek.
# Kısa olsaydı ceza mesafeye değil saate bağlanırdı.
const SOZ_SURESI_GUN := 0.08

# Sözü tutmuş sayılmak için bu kadar yakına dönmek gerekir. Kurtarma
# mesafesiyle AYNI ve bu kasıtlı: "yanındayım" demenin tek bir ölçüsü olsun.
const SOZ_DONUS_MESAFESI_M := KURTARMA_MESAFESI_M

# Bir porsiyon ne kadar kapatır
const YIYECEK_DOYURUR := 0.45
const SU_KANDIRIR := 0.60

# --- Güven ---
const GUVEN_BASLANGIC := 0.35     # yabancı
const GUVEN_DUSUK_UST := 0.33
const GUVEN_YUKSEK_ALT := 0.66
const GUVEN_YUKSELIS := 0.06      # bedelli jest başına
const GUVEN_DUSUS := 0.12         # 2× — "hızlı düşer, yavaş yükselir" (K-057)
const GUVEN_GUNLUK_YUKSELIS_TAVANI := 2   # günde en çok 2 jest sayılır;
                                          # yoksa oyuncu jesti çiftlik yapar

# --- Moral ---
const MORAL_BASLANGIC := 0.70
const MORAL_ORTA_ALT := 0.34      # koşulların inebileceği EN DİP nokta
const MORAL_COKUS_ESIGI := 0.12
const COKUS_EN_AZ_GUN := 2.0      # ölümden önce en az bu kadar görünür çöküş
const OLUM_EN_ERKEN_GUN := 6      # K-055: en erken 6. günün şafağı

# --- İhmal (moral tabanını YALNIZCA bu indirir) ---
const IHMAL_GECE_YALNIZ_BIRAKMA := 0.25   # çökmüş/yaralıyken yanında olmamak
const IHMAL_VERMEME := 0.08               # elinde varken, o görüyorken, o muhtaçken
const IHMAL_TEHLIKEDE_BIRAKMA := 0.20
const IHMAL_ATESI_SONDURME := 0.10        # geceleyin
const IHMAL_SOZ_TUTMAMA := 0.15
const IHMAL_GUNLUK_GERILEME := 0.15       # bakım gösterilirse yavaşça geriler

# --- Algı ---
const GORUS_MESAFESI_M := 12.0    # arkadaş bunun ötesindekini değerlendirmez
const GECE_GORUS_CARPANI := 0.45  # karanlıkta daralır

# ATEŞ IŞIĞI İSTİSNASI (K-058, kullanıcı kararı). Gece görüşü 5.4 m'ye
# daralıyordu; düşük güvende arkadaş 7–10 m'de durduğu için gece yapılan
# hiçbir jest ona ULAŞMIYORDU — güveni en çok kazanman gereken anda kanal
# tamamen kapalıydı. Ateşin aydınlattığı çember içinde algı GÜNDÜZ gibi
# çalışır. Karanlıkta uzaktaki birine ulaşmak hâlâ yanına gitmeyi gerektirir;
# kasıtlı sertlik olan kısım budur.
const ATES_ISIK_YARICAPI_M := 6.0

# ÇAĞRI MENZİLİ (K-068). Bağırmak görmekten UZAĞA gider ve karanlık onu
# daraltmaz — gece seslenmek tam da bunun için vardır. Sayı keyfî değil:
# düşük güvende arkadaş 7–10 m'de durur, bu yüzden menzil o bandın çok
# üstünde olmak ZORUNDA. Aksi hâlde "gelmedi" ile "duymadı" ekranda aynı
# görünür ve oyunun en yüksek sesli işareti bir menzil hatasına dönüşür.
# testler/cagri.gd bu şartı her güven seviyesi için ayrı ayrı denetler.
const CAGRI_MENZILI_M := 25.0
