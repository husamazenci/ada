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

**Gün 1 · Uyanış.** *(yazılmış metin — 2026-09-24)*

**Gün batımında başlar: oynanan kısım ~7 dakika** (alacakaranlık + gece).
Kısa ve sert bir açılış; oyun 2. günde normal uzunluğuna kavuşur.

- **Önce:** okyanusun ortasında uçak arızalanır ve küçük bir kara parçasına
  düşer. Baygınsın.
- **[SAHNE 1 · Uyanış]** *(cutscene 1)* Tam gün batımı. Enkazdan **biraz
  uzakta** kendine gelirsin; enkazı görürsün. Nerede olduğunu bilmiyorsun.
  Çevreye gergin ve stresli bir hava hâkim. 30–40 sn, sonra kontrol sende.
- **Enkaz:** uçak ortadan ikiye ayrılmış, her yeri kırık. İçeri geçişi olan
  bir kapı var ama **çarpışmadan sıkışmış**; içerisi görünmüyor. Elinle
  zorlarsın, açılmaz. *Bugün girilemez — ateş başlatıcısı o kapının ardındadır
  ve bu gecenin ateşsiz olmasının SEBEBİ budur.*
- **Arkadaşın gelişi.** Sen kapıyla boğuşurken **arkandan biri gelir.** Hiç
  konuşmaz ama **tuhaf biçimde sakindir** — çevredeki gerginliğin tam tersi.
  İletişim kurmaz, yalnızca sana bakar. Yanına gider, konuşmayı denersin;
  cevap vermez.
  *Karakterini kuran şey bu sakinlik: herkesin panikleyeceği anda o
  paniklemiyor. Kim olduğu değil, NE olduğu buradan okunmaya başlar.*
- **Öncülük.** Bir anda döner, yürümeye başlar ve **eliyle gelmeni işaret
  eder.** Peşinden gidersin. Odun toplamaya başlar; bu sana ne yapılacağını
  gösterir ve yardım edersin.
  *K-041'in çekirdeği burada: yönlendirme ekrandan değil ondan geliyor.*
- **Başarısız ateş.** Odunları kamp ateşi biçiminde dizer ve yakmaya çalışır.
  **Yakacak hiçbir şey yoktur.** Deneme boşa gider.
- **Gece:** soğukta uyuyakalırsın. *Koşullu iz:* `ilk-gece-yalniz`
  (ateşin/odun yığınının yanında mı, ayrı mı uyuduğun).
- *Koşulsuz iz:* `oyun-basladi`.

**Gün 2 · Ateş, yer ve ilk paylaşım.** *(yazılmış metin — 2026-09-24, düzeltilmiş)*

- Sabah **metalin metale sürtünme sesiyle** uyanırsın. Arkadaş enkaz kapısının
  önündedir: gövdeden kopmuş dar bir parçayı kapının altına sokmaya çalışır.
  Seni görünce parçayı **sana uzatır**; dün gece açamadığınız yere işaret eder.
  > **AÇIK ÇATIŞMA (karar bekliyor):** işaret etme. K-063 ile jestin **bir
  > kez** (1. gün çağırma) olması kararlaştırıldı; bu ikincisi olur. Öneri:
  > işaret kalksın — zaten kapının önünde, parçayı uzatması iletişimin kendisi.
  > Eylem işaretten güçlüdür ve kural bozulmaz.
- **[SAHNE 2 · Ateş]** Sen parçaya yüklenirken o kapının eğilmiş kenarını
  çeker. **İlk denemede yalnızca gürültü çıkar.** İkincisinde kapı bir karış
  açılır. **İkiniz de durup içeriden bir ses beklersiniz**, sonra birlikte
  yeniden zorlarsınız.
- **İçeride:** koltuklar ve çantalar birbirine girmiştir. **İçeride kimse
  seslenmez.**
  - Acil durum kutusunda **ateş başlatıcısı**. **Arkadaş onu alır**; sen
    **boş metal kap**, **kuru kalmış koltuk dolgusu** ve **küçük bir defter**
    çıkarırsın. *(Dolgu artık çakmak otunun kaynağı — ateşin tutuşması bir
    buluşa bağlanıyor, şansa değil.)*
  - **Gövdenin ilerisi çökmüştür; bugün geçilemez.** *(Açık dünya kancası —
    hangi gün açılacağı KARAR BEKLİYOR.)*
- Enkazdan uzaklaşırken **ağaçların arasından akan suyu** duyarsınız. Derenin
  yakınındaki açıklığa dün geceki odunları taşırsınız.
- **Ateş.** Arkadaş başlatıcıyı dener; kıvılcım düşer, nemli yapraklar
  tutuşmaz. **Yerini değiştirip bir daha dener** — sonra aleti sana uzatır.
  Sen kuru lifleri odunların altına koyarsın. Kıvılcım liflerde kaldığında
  **o hemen eğilip rüzgârı keser.** Birlikte üflersiniz. Alev birkaç kez
  sönmeye yaklaşır, sonra oduna geçer.
  *Varyant:* güven yoksa aleti sana uzatmaz; kendi ateşini kendine kurar.
- **Öğleden sonra · balık.** Kıyı boyunca yürürsünüz. Kayalar arasında sığ bir
  havuzda küçük bir balık kalmıştır. Sen çıkışını taşla kapatmaya çalışırken
  **o iki eliyle yakalanacağı yerde bekler** — sözsüz iş bölümü. **Balık ilk
  seferinde ikinizin arasından kaçar.** Yüzünde çok kısa bir ifade belirir;
  gülümseme mi, yorgunluk mu, anlayamazsın. İkinci denemede yakalarsınız.
  > **UYGULAMA NOTU:** yüz animasyonu YOK (stilize, yüz ayrıntısı yok).
  > Bu an **bedenle** kurulmalı: yarım saniyelik duraklama, omuz düşmesi,
  > başın yana eğilmesi. Okunamazlığı korunur, yüz gerekmez.
- **İLK BEDELLİ PAYLAŞIM.** Balık iki kişiye yetecek kadar büyük görünmez.
  Pişince bölersin. **Büyük parçayı arkadaşına uzattığında hemen almaz.
  Senin elindeki küçük parçaya bakar, sonra kendisininkinden bir lokma ayırıp
  önüne bırakır.** Ne teşekkür eder ne de gözlerini uzun süre üzerinde tutar.
  Biraz sonra, **sen istemeden ateşe bir dal daha ekler.**
  *Günün ilişki sorusu: paylaşıyor muyuz? Ve cevabı tek taraflı değil —
  karşılık geliyor. Bu, arkadaşın MADDİ katkısının (K-062) anlatıdaki ilk
  görünümüdür.*
- **Gece bu kez aydınlıktır.** Açlığınız geçmemiştir, ama ateş yanar.
  **Arkadaş ilk gecedekinden biraz daha yakına oturur.** *(Mesafe = güven
  kanalı, §4 davranış tablosu — ilk kez ekranda.)*
- **Deftere derenin yerini ve balığı bulduğun kayalık kıyıyı çizersin.**
- *Koşulsuz iz:* `ates-sahnesi-gecti` — ateş yanmasa bile düşer.
  *Koşullu:* `ates-yakildi`, `defter-alindi`, `balik-paylasildi`.

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
