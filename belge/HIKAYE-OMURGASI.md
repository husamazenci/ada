# Hikâye omurgası — 6 gün

> 2026-09-24 · K-055 ile 12 günden 6 güne indirildi (120 dakika).
> Model 2 (yazılmış omurga + yaşayan et) ve kalıcı ölüm kullanıcı kararıdır
> (K-049). Zincir K-055'te düzeltildi: artık kırılamaz.

---

## 0. Model 2 ne demek

**Yazılmış olan:** ne zaman, nerede, hangi olay. Fırtına 4. gecedir; sal 5.
gün falezin dibine vurur; arkadaş 5. gün çöker. Bunlar her oyunda olur.

**Yaşayan olan:** o olay NASIL geçer. Aynı fırtına gecesi, güven yüksekken
"seni barınağa çeken biri", düşükken "barınağa tek başına giden biri"dir.
Sahne aynı, sahnedeki insan farklı.

**Bozulmaması gereken:** arkadaş sahnede de kendi kararını verir (tasarım
pusulası). Sahne ona ne yapacağını söylemez; sahne ona bir DURUM verir.

---

## 1. İzin iki türü *(A1 düzeltmesi, K-055)*

Bu ayrım olmadan zincir kırılıyordu: fırtınanın izi `barinak-hasari` idi ve
kriz + sal buna bağlıydı, ama barınak zorunlu değildi. Barınak yoksa oyun
kapanışa hiç ulaşamıyordu.

| Tür | Ne zaman düşer | Ne besler |
|---|---|---|
| **Koşulsuz iz** | Sahne olduysa **her hâlükârda** — oyuncu orada olmasa bile | **Zinciri** |
| **Koşullu iz** | O sahnede ne yapıldıysa ona göre | **Varyantları** |

**Değişmez:** zincirin önkoşulu YALNIZCA koşulsuz iz olabilir. Koşullu iz
önkoşul olarak kullanılırsa oyun hiç yüklenmez (inşa değişmezi, K-052'nin
eksik yarısı).

Sonuç: oyuncu hiçbir şey yapmasa bile oyun sonuna varır — ama bambaşka bir
oyun olur.

### Zincir

| Sahne | En erken gün | Önkoşul (koşulsuz) | Bıraktığı koşulsuz iz | Koşullu izler |
|---|---|---|---|---|
| uyanış | 1 | — | `oyun-basladi` | — |
| ateş | 2 | `oyun-basladi` | `ates-sahnesi-gecti` | `ates-yakildi` · `ilk-gece-yalniz` |
| kim gidecek | 3 | `ates-sahnesi-gecti` | `ayrilik-gecti` | `uzaga-giden` · `soz-tutuldu` |
| köpek | 3 (gece) | `ayrilik-gecti` | `kopek-gecti` | `yara-kimde` · `korudu-mu` |
| fırtına | 4 (gece) | `kopek-gecti` | `firtina-gecti` | `barinak-hasarli` · `firtinada-birlikte` |
| kriz | 5 | `firtina-gecti` | `kriz-gecti` | `kriz-siddeti` |
| sal | 5 | `firtina-gecti` | `sal-dunyada` | — |
| son gece | 6 | `sal-dunyada` | `son-gece-gecti` | — |
| ayrılık | 6 | `son-gece-gecti` | `oyun-bitti` | `kim-gitti` |

**Dokuz sahne, üç tam cutscene** (kontrolün alındığı): uyanış · fırtınanın
uyanma anı · kapanış (ayrılık sahnesinin sonunda, seçimden SONRA).
Cutscene sayısı **kilitlidir** (K-055/D2): dördüncüsü bu sürümde eklenmez.

### Sahne sözleşmesi

| Alan | Ne |
|---|---|
| **Tetik** | Önkoşul (koşulsuz iz) + en erken gün + saat + yer |
| **Kontrol** | Varsayılan: OYUNCUDA. Alınıyorsa süre yazılır |
| **Süre** | Hedef 20–90 sn; tam cutscene 60 sn'yi geçmez |
| **Varyant** | Güven yüksek / orta / düşük — en az iki |
| **Koşulsuz iz** | Ne olursa olsun dünyada kalan |
| **Koşullu izler** | Oyuncunun/arkadaşın davranışına göre kalan |
| **Çağrı** | Koşullar sağlanınca sahne ÇAĞIRIR: arkadaş oraya gider ve bekler, iş yarım durur. Ekranda ok, işaret, yazı YOK |
| **Sensiz** | Oyuncu bir gün içinde gelmezse sahne sensiz olur; koşulsuz izi yine düşer |

---

## 2. Üç perde

| Perde | Günler | Soru | Basınç |
|---|---|---|---|
| **I · Tanışma** | 1–2 | "Bu kim ve ne yapacağız?" | Ateş, su, yiyecek; ilk gece |
| **II · Sınav** | 3–4 | "Ona güvenebilir miyim, o bana?" | Kıtlık · köpek · yara · fırtına |
| **III · Seçim** | 5–6 | "Kim gidecek?" | Çöküş, sal, ve geriye kalan zaman |

---

## 3. Gün gün

Her gün ~20 dk: gündüz ~13, alacakaranlık ~2, gece ~5.
**Kalın** = yazılmış sahne. Ötekiler dünyanın kendi akışı.

### Perde I — Tanışma

**Gün 1 · Uyanış.**
- **[SAHNE 1 · Uyanış]** *(cutscene 1)* Kumsalda yüzükoyun. Kontrol ALINIR:
  nefes, dalga, uzakta enkaz. 30–40 sn, sonra kontrol sende.
- Enkaz: içine girilir. İlk eşyalar — ve **tek kap** (susuzluk buradan başlar).
  Arkadaş enkazın öbür ucunda oturuyor, sana bakıyor, konuşmuyor. Yanına
  gitmek zorunda değilsin.
- Gece: ateş YOK. İlk gece üşüyerek, karanlıkta, yan yana ya da ayrı geçer.
  *Koşullu iz:* `ilk-gece-yalniz`.

**Gün 2 · Ateş ve yer.**
- **[SAHNE 2 · Ateş]** Arkadaş çakmaktaşını çıkarır, dener, olmaz; sana uzatır.
  Yönlendirme sözle değil ELLE: o yapar, durur, bakar.
  *Varyant:* güven yoksa kendi ateşini kendine kurar, seninkini kurmaz.
  *Koşulsuz iz:* `ates-sahnesi-gecti` — ateş yanmasa bile düşer.
- Açıklık bulunur: **dere + ağaç + düz zemin**. Ev olacak yer seçilir.
  Dere açıklığın içindedir: evde su bedava, yolda değil.
- Barınak iskeleti kurulabilir — iki kişilik iş; tek başına iki kat uzun sürer.
  *İlk "bedeli olan yakınlık".* Zorunlu değildir (zincir buna bağlı değil).

### Perde II — Sınav

**Gün 3 · Ayrılık ve köpek.**
- Yakın kaynaklar biter. Birinin uzağa gitmesi gerekir — gidiş-dönüş günün
  yarısı, ve yolda su yok: kap dolu gitmelidir. **Tek kap, iki insan.**
- **[SAHNE 3 · Kim gidecek]** Arkadaş kenarda bekler: gitmeye hazır ama senin
  ne yapacağına bakıyor. Gidersen: dönüşte seni bekliyor mu? Göndersen:
  yaralı/boş döner mi? *Varyant:* düşük güvende hiç gitmez.
- **[SAHNE 4 · Köpek]** Gece, ateş zayıfken köpek ışığın kenarına gelir.
  Üç sonuç: sen onu korursun · o seni korur · kimse kimseyi korumaz.
  **Ölüm YOK** (değişmez kural). *Koşullu iz:* `yara-kimde` (hiç kimse de
  olabilir), `korudu-mu`.

**Gün 4 · Yaralı gün ve fırtına.**
- Yaralı olan yavaşlar ve koşamaz; diğeri iki kişilik çalışır: su, ateş,
  yiyecek. *Yara yoksa* gün yorgunluk ve azalan kaynak üzerinden geçer —
  gün her hâlükârda ağırdır.
- *Varyant:* yaralı sensen, o seni besler mi? Güvenin ilk büyük testi.
- **[SAHNE 5 · Fırtına]** *(cutscene 2)* Gece yarısı. Kontrol YALNIZCA uyanma
  anında alınır (15–20 sn: çatı gıcırdar, ateş söner, dışarıda rüzgâr), sonra
  bırakılır — kaçış oyuncunun elinde geçer, arkadaşın varyantı ekranda okunur.
  Barınak yetmez; kaya çıkıntısına gitmek gerek.
  *Varyantlar:* yüksek güven → seni kolundan çeker, birlikte koşarsınız ·
  orta → gider, arkasına bakar, bekler · düşük → tek başına gider.
  *Koşulsuz iz:* `firtina-gecti`. *Koşullu:* `barinak-hasarli` (barınak varsa),
  `firtinada-birlikte`.

### Perde III — Seçim

**Gün 5 · Çöküş ve sal.**
- **[SAHNE 6 · Kriz]** Her oyunda olur; ŞİDDETİ fırtına gecesindeki davranışa
  göre değişir. Fırtınadan sonra hastalanır. Kalkmaz.
  Bütün gün bakım: **su getirmek**, ateş, yiyecek, yanında kalmak. Suyun
  ikinci büyük anı burasıdır — o kalkamaz, dere uzaktır, kap tektir.
  *Varyant:* güven yüksekse toparlar; düşükse toparlamaz ve çöküş birikir.
- **[SAHNE 7 · Sal]** Falezin dibindeki kaya sahanlığında, tek kişilik şişme
  sal. İkiniz de görürsünüz. Kimse bir şey söylemez.
  *Koşulsuz iz:* `sal-dunyada` — her gün ona bakılır.

**Gün 6 · Seçim.**
- **[SAHNE 8 · Son gece]** Ateş başında, ikisi de uyanık. Ekranda tek satır
  belirebilir — duyum/durum cümlesi ("o hâlâ orada"), oyuncunun iç sesi değil.
- **[SAHNE 9 · Ayrılık]** Gelgit sabahı. Sal bugün gider — biriyle ya da boş.
  Seçenekler: sen binersin · ona verirsin · ikiniz de binmezsiniz · o senden
  önce davranır (düşük güvende). **[cutscene 3: kapanış, seçimden SONRA]**
  Kamera **kıyıda kalanla** kalır. Kurtuluş gösterilmez. Gün batımında biter.

---

## 4. Ölüm ve başarısızlık

- **Oyuncu ölürse** oyun biter, yuva silinir. Ölümden önce her zaman bir uyarı
  vardır (ilk yara).
- **Arkadaş ölürse** oyun devam eder ve hikâye değişir: kalan gün yalnız
  geçer, sal geldiğinde soru "kim gidecek"ten "gidebilir miyim"e döner.
  Ölüm ani değildir: çöküş 4. günden itibaren görünür, en erken **6. günün
  şafağında** gelir, iki tam gün müdahale penceresi vardır. Ve yalnızca
  **senin ihmalin** varsa gelir (K-055; moral tabanı).
  Biçimi: yavaş vazgeçiş — yemez, kalkmaz, ateşe bakmaz, bir sabah uyanmaz.
- **Arkadaş çekilirse** en erken **5. gün** gider (K-055). Geri kazanma yoktur;
  gidişi salın yanında ikinci bir sondur.
