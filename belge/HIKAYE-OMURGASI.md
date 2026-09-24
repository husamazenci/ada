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

<!-- ZINCIR:BASLA — bu tablo betik/veri/sahneler.gd'den ÜRETİLİR.
     Elle değiştirme; testler/zincir.gd eşitliği denetler. -->
| Sahne | En erken gün | Önkoşul (koşulsuz) | Bıraktığı koşulsuz iz | Koşullu izler | Cutscene |
|---|---|---|---|---|---|
| uyanis | 1 | — | `oyun-basladi` | `ilk-gece-yalniz` | **evet** |
| ates | 2 | `oyun-basladi` | `ates-sahnesi-gecti` | `ates-yakildi` · `defter-alindi` · `balik-paylasildi` | — |
| barinak | 3 | `ates-sahnesi-gecti` | `barinak-kuruldu` | `barinak-kim-tuttu` | — |
| kopek | 3 | `barinak-kuruldu` | `kopek-gecti` | `yara-kimde` · `araya-girdi` · `denedi-yetisemedi` | — |
| kim-gidecek | 4 | `kopek-gecti` | `ayrilik-gecti` | `uzaga-giden` · `malzeme-getirildi` · `soz-tutuldu` · `nobet-kimde` | — |
| firtina | 4 | `ayrilik-gecti` | `firtina-gecti` | `barinak-hasarli` · `firtinada-birlikte` | **evet** |
| kriz | 5 | `firtina-gecti` | `kriz-gecti` | `kriz-siddeti` · `su-verildi` · `yiyecek-verildi` · `gece-yaninda-kalindi` | — |
| sal | 5 | `firtina-gecti` | `sal-dunyada` | `sal-cekildi` | — |
| son-gece | 5 | `sal-dunyada` | `son-gece-gecti` | `yanindaydi` · `yalniz-gecti` | — |
| ayrilik | 6 | `son-gece-gecti` | `oyun-bitti` | `kim-gitti` | **evet** |
<!-- ZINCIR:BITIR -->

**On sahne, üç tam cutscene** (kontrolün alındığı): uyanış · fırtınanın
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
  Seni görünce parçayı **sana uzatır.** *(İşaret etmez — K-063: jest bütün
  oyunda bir kezdir, o da 1. gündeki çağrıdır. Zaten kapının önünde ve parçayı
  uzatıyor; eylem işaretten güçlü.)*
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
  - **Gövdenin ilerisi çökmüştür; bugün geçilemez.** *(Karar: **4. günde
    açılır** ve orada barınağın çatısını kapatacak malzeme vardır — yani
    fırtınadan önceki son fırsat. "Kim gidecek" sorusunun sebebi budur.)*
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
  *(Karar: bu an **bedenle** kurulur — yüz animasyonu yok. Yarım saniyelik
  duraklama, omuz düşmesi, başın yana eğilmesi. Beden yüzden daha okunamaz
  kalır, yani belirsizlik bedenle DAHA iyi çalışır.)*
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

**Gün 3 · Barınak ve köpek.** *(yazılmış metin — 2026-09-24)*

- **Sabah:** ateşin altında yalnız köz kalmıştır. Gece rüzgâr birkaç kez yön
  değiştirmiş; ikiniz de ateşe yakın durmanıza rağmen doğru dürüst
  uyuyamamışsınızdır.
- **[SAHNE 3 · Barınak]** Arkadaş açıklığın arkasındaki **büyük kayayı**
  inceler; rüzgâr orada daha az vurur. Kıyıya sürüklenmiş dallar ve uçaktan
  sökülen **hafif bir panel** taşınır.
  - Sen paneli kayaya dayarken **o altına taş dizer.** Sert bir rüzgâr paneli
    elinden alacak gibi olur; **iki eliyle yakalar ve sen bağlayana kadar
    tutar.** *Koşullu iz:* `barinak-kim-tuttu`.
  - Altında oturulacak kadar yer açılır. **Üstü hâlâ açıktır.** Yağmurda
    dayanıp dayanmayacağı belli değildir.
  - *Koşulsuz iz:* `barinak-kuruldu`.
  - **Deftere:** o gece, barınağın altında, kurduğunuz şeyi çizersin.
  > **Bu eksiklik KASITLIDIR** (kullanıcı kararı). 4. günün fırtınası böylece
  > gökten inen yeni bir felaket değil, **3. günde fark edilen bir zayıflığın
  > sınanması** olur. Sebep–sonuç hiçbir şey anlatmadan kurulur.
- **Öğleden sonra:** kayalık kıyının daha uzak kısmına gidilir; gelgit
  havuzlarında **iki balık**. Dönüşte yük paylaşılır — sen kabı ve balıkları,
  o barınak için bulduğu son dalları taşır.
- **Güneş alçalırken: uyarı.** Uzaktan bir **uluma.** Arkadaş elindeki dalı
  bırakır. Kayalar arasında yankılandığı için yön anlaşılmaz. Bir süre hiçbir
  şey olmaz. Sonra **aynı ses, daha yakın.** Arkadaş balıklara bakar, onları
  ateşe yaklaştırır. Sen köze odun koyarsın.
  *Saldırı uyarısız gelmez: uluma → arkadaşın tepkisi → ışığın sınırındaki
  siluet. Oyuncunun hazırlanmak için üç fırsatı var.*
- **[SAHNE 4 · Köpek]** Gece ateş küçüldüğünde kayalar arasında hareket.
  **Yabanileşmiş bir köpek** ışığın sınırında durur; kaburgaları seçilir.
  Yaklaşmaz — **burnunu kaldırıp yiyeceğin kokusunu alır.**
  *(Kurt değil: okyanus ortasındaki küçük bir adada kurdun varlığı ayrıca
  açıklama gerektirir. Saldırının sebebi de açık — yiyecek.)*
  - **Arkadaş balıkları almak için eğildiğinde köpek ileri atılır.** Geri
    çekilmeye çalışır ama **ayağı taşların arasına takılır.**

  | | **Araya girersen** | **Girmezsen** |
  |---|---|---|
  | Olan | Aranıza geçersin, dişleri koluna geçer. Köpek sıçrayınca **arkadaş yanan bir dal çekip önüne tutar.** Hayvan bir kez daha yaklaşır, sonra çekilir | Köpek **bacağına** saldırır. Kurtulmaya çalışırken **bir balık düşer**; köpek kapıp kaçar |
  | Bedeli | **Kolun kanar.** Ertesi gün o kolla yük taşımak ve koşmak zor | **Sen sağlamsın**, ama arkadaş yaralı ve **yiyecek eksildi** |
  | Sonrası | Önce yarana, sonra yüzüne bakar. Seni barınağın altına oturtur, **gece boyunca ateşle kendisi ilgilenir** | Önce bacağına, sonra sana bakar. Bir şey söylemez. Barınağın altına oturur, **ateşe odun atmak için bir daha kalkmaz.** Nöbet sana kalır |

  > **Araya girmek otomatik "doğru seçim" DEĞİLDİR** (kullanıcı kararı):
  > bir yolda sen sakat kalırsın, öbüründe o yaralanır ve yiyecek gider.
  - *Koşulsuz iz:* `kopek-gecti` — ne olursa olsun düşer, biri her hâlükârda
    yaralanır (zincir bu yüzden kırılmaz).
    *Koşullu:* `yara-kimde`, `araya-girdi`, `denedi-yetisemedi`.
  - **Deftere:** *"Gece bir şey geldi. Ateşin dışında durdu."*
- **Sonrası:** ada yeniden sessizleşir. Barınağın gevşek paneli rüzgârda arada
  bir kayaya vurur. **Biriniz uyurken diğeriniz ateşi besler ve ışığın bittiği
  yeri izler.**

**Gün 4 · Kim gidecek ve fırtına.** *(yazılmış metin — 2026-09-24)*

> **YARA SÜRESİ (denetimde bulundu):** köpek yarası **iki gün** sürer —
> 4. gün ağır, 5. gün belirgin biçimde hafifler, 6. günde iz kalır ama engel
> olmaz. Sebep: 5. günün ağırlığı hastalıktan gelmeli, üst üste binen iki
> engelden değil. Yaralı olan SEN isen 5. günün su taşıma döngüsü zaten
> yeterince zordur.

- **Sabah yara görünür.** Köpek seni ısırdıysa kolunu kullanırken duraksarsın,
  yükü öteki ele alırsın. O yaralandıysa barınaktan kalkması uzun sürer,
  ağırlığını sağlam bacağına verir. **Hanginiz yaralıysa bugün yavaştır ve
  koşamaz.** Günün tamamı bu yaraya göre değişir.
- **KOŞULLU AYRINTI (K-067, adalet için):** günlerdir biriken **ağır ihmal**
  varsa arkadaşın yavaş vazgeçişi **fırtınadan ÖNCE de bedeniyle görülmelidir**
  — nefesi seyrekleşir, başı düşer, uzattığın şeye uzanan eli yarıda kalır.
  Sebep: altıncı gün uyanmaması yalnızca beşinci günkü hastalığa bağlanmasın.
  *İhmal yoksa bu ayrıntı hiç görünmez; gün normal geçer.*
- **Fırtına sessizce haber verir:** rüzgâr panelin gevşek kenarını kaldırır,
  deniz dünkünden koyu görünür, kıyıda beslenen kuşlar adanın içine çekilir.
  **İkiniz de görürsünüz. Kimse fırtınanın geleceğini söylemez.**
  *(Kritik bilgi sesle değil GÖRÜNTÜYLE taşınıyor — erişilebilirlik kuralı.)*
- **[SAHNE 5 · Kim gidecek]** Yiyecek kalmamıştır. Enkazın ilerisindeki kayalık
  kıyıda avlanılabilir; yolun üzerinde, **dün geçilemeyen iç bölümde** çatıyı
  kapatacak **branda ve kayışlar** vardır. Gidiş-dönüş sağlam biri için bile
  günün büyük kısmını alır. Balığı, brandayı ve paneli birlikte taşımak zordur.
  - **Kimin gideceği KONUŞMAYLA kararlaştırılmaz.** Sen hazırlanıp ayrılırsan
    o kalır. Sen kalırsan, bir süre sonra **boş yiyecek kabını alıp kendisi
    yola çıkar** — yaralıysa kabı kaldırırken bile zorlandığını görürsün.
    Durdurup yolculuğu üstlenebilir ya da gitmesine izin verebilirsin.
  - *Sen gidersen:* çökmüş paneli yeniden zorlarsın. Branda ve kayışlar
    oradadır; yiyecek için kıyının ilerisinde vakit geçirmen gerekir.
    Yaralıysan ikisini birden taşımak ya da alacakaranlıktan önce dönmek
    zorlaşır — **neyi önce alacağına sen karar verirsin.** Döndüğünde
    **ateş canlı, barınağın açık tarafına taş yığılmıştır.** Malzemeyi alırken
    yaralı yerine bakar; yardım edebildiği işi sessizce üstlenir.
  - *O giderse:* dönüşünü sesle değil, **açıklığa çıkan patikada görürsün.**
    Sağlamsa yiyeceğin yanında çatı malzemesi de getirir. Yaralıysa daha geç
    gelir ve taşıdığı azdır — **gecikmesi, bir sonraki sefer onu göndermenin
    bedelini görünür kılar.**
  - *Hiçbir şey yapmazsan:* gün yine ilerler. **Fırtına seni beklemez.**
  - *Koşulsuz iz:* `ayrilik-gecti`. *Koşullu:* `uzaga-giden`,
    `malzeme-getirildi`, `soz-tutuldu`.
- **Alacakaranlık:** barınağı yetiştirebildiğiniz kadar kapatırsınız. Malzeme
  geldiyse açıklığın bir kısmı örtülür; gelmediyse rüzgâr hâlâ girer.
  **Her iki durumda da kaya ile panelin arası tamamen kapanmaz.**
  Nöbet düzeni sürer: biriniz uyurken diğeri ateşe bakar. *Yaralı olanın
  uyuması kolay bir seçim gibi görünür — ama bunu siz belirlersiniz.*
  *Koşullu iz:* `nobet-kimde`.
- **[SAHNE 6 · Fırtına]** *(cutscene 2 — KOŞULLU)* Gece deniz artık karanlık
  bir çizgi değildir; **beyaz köpükler kıyıdan seçilir.** Rüzgâr paneli
  kaldırır, yağmur ateşin çevresine düşer.
  - **Uyuyorsan:** panelin kayaya çarptığı anda uyanırsın. İlk **15–20 saniye**
    kontrol alınır — su barınağa girer, ateş söner — sonra hareket edebilirsin.
  - **Nöbetteysen bu uyanma anı HİÇ YAŞANMAZ:** yaklaşan fırtınayı görerek
    hareket edersin.
  > **KARAR:** cutscene 2 koşulludur. Nöbet tutan oyuncu onu hiç görmez.
  > Sayı hâlâ üçte kilitli (D2); değişen, birinin **kazanılabilir** olması.
  > Uyanıklığın karşılığı gösteri değil **eylem** oluyor.
  - Barınak, malzeme gelmiş olsa da korumaz. **Kayanın birkaç adım ötedeki
    ters yüzüne** geçmek gerekir. Yol kısa tutulmuştur; yaralı biri de
    koşmadan güçlükle ulaşabilir.
  - **Arkadaş dört günün sonucunu bedeninden gösterir:**

  | Güven | Davranış | Yaralıysa |
  |---|---|---|
  | **Yüksek** | Yanına gelir, sağlam kolundan ya da giysinden tutar, sen geçene kadar yakınında kalır | Seni çekmeye çalışır ama aksar — **bu kez sen onun hızına uymak zorundasın** |
  | **Orta** | Önce korunaklı tarafa geçer. Sınırda durur, omzunun üzerinden bakar, bekler. Yaklaşınca yeniden yürür | — |
  | **Düşük** | Tek başına gider | Aksayarak gider; **dönüp bakmaz** |

  - *Koşulsuz iz:* `firtina-gecti`.
    *Koşullu:* `barinak-hasarli`, `firtinada-birlikte`.
  - **Deftere:** *"Fırtına geceyi böldü."*
- **Sabaha karşı** rüzgâr diner. Ateşin yerinde ıslak kül vardır. Barınağın
  üstü açılmış, kıyıdan gelen yosunlar açıklığa kadar sürüklenmiştir.
  > **Bunlar, o gece nerede olduğunuzdan ve ne yaptığınızdan BAĞIMSIZ olarak
  > oradadır: fırtına adadan geçmiştir.** *(A1'in metinle kurulmuş hâli —
  > koşulsuz iz burada dünyanın kendisi oluyor.)*
- Branda geldiyse hasarlı çatı yeniden kurulabilir; gelmediyse barınak da
  içeride bıraktıklarınız da sırılsıklamdır. Arkadaş kayanın yanında durur.
  **Aranızdaki mesafe, fırtına sırasında ne yaptığınızı sözcüksüz anlatır.**

### Perde III — Seçim

**Gün 5 · Çöküş ve sal.** *(yazılmış metin — 2026-09-24)*

> **İki şey aynı güne KASITLI olarak düşer:** gitme imkânı tam o kalkamazken
> belirir. Günün sorusu budur — kalan zamanı ona mı harcıyorsun, gitmeye mi
> hazırlanıyorsun?

- **Sabah:** ateşin yerinde ıslak kül, açıklığın kenarına kadar gelmiş yosun.
  Arkadaş barınağın altında ya da kayanın dibinde. Yanına geldiğinde kalkmayı
  dener: ağırlığını kollarına verir, bir an doğrulur, sonra yeniden oturur.
- **[SAHNE 7 · Kriz]** **Çöküş HER OYUNDA olur; şiddeti fırtına gecesindeki
  davranışa bağlıdır.**

  | Fırtınada | Bugün |
  |---|---|
  | Birlikte korunaklı yere geçtiniz | Oturabilir. Omuzları düşük ama uzattığın suyu alır; ilerleyen saatlerde kısa süre ayakta kalabilir |
  | Ayrı sığındınız / geç yardım ettin | Ancak dirseğine dayanarak doğrulur. Su kabına eli gider, **bir an havada kalır**; kabı yaklaştırman gerekir. Bugün yürüyemez |
  | Onu geride bıraktın | Başı aşağıdadır. Doğrulmayı denerken **kolu yarı yolda çözülür.** İlk uzattığın yiyeceğe elini götürmez. *Yine de nefes alır; **bugün ölmeyecektir.*** |

  - Nöbet düzeni bozulur: **artık ateşe odun koyamaz.** Ateşi kurmak, yiyecek
    bulmak ve su taşımak sana kalır. Dün avdan yiyecek getirdiysen kullanırsın;
    getirmediysen kıyıda aramak için ayrıca zaman harcarsın.
  - **TEK KAP DÖNGÜSÜ.** Dere uzak değildir ama kap tektir ve bir dolum bir
    kişiye yeter. Doldurup dönersin, ona verirsin — *sonra kendinin de
    susadığını fark edersin.* Yeniden gitmen gerekir. **Her gidişte onu
    yalnız bırakırsın;** her dönüşte aynı yerde olup olmadığına, nefesinin
    hızına ve başını ne kadar kaldırabildiğine bakarsın.
  - **Uyarı, oyuncunun yanlış okumasını önler:** *"Su içince kısa süreliğine
    doğrulması, iyileştiği anlamına gelmez."* Yiyecek de gerekir. İkisini
    sağlasan bile **geceyi yanında geçirmedikçe toparlanma sürmez.**
  - *Koşulsuz iz:* `kriz-gecti`. *Koşullu:* `kriz-siddeti`, `su-verildi`,
    `yiyecek-verildi`, `gece-yaninda-kalindi`.
- **[SAHNE 8 · Sal]** Öğleden sonra falez tarafındaki kaya sahanlığında
  **turuncu bir şekil.** Gelgit, uçağınızdan kopmuş küçük can salını oraya
  bırakmıştır; kopuk bağlantı kayışı hâlâ üstündedir.
  - **Sınır SEZDİRİLİR, yazılmaz:** boyunun bir yetişkine ancak yettiğini,
    tutunmak için tek yer bulunduğunu görürsün. **Kenarına bastığında bordası
    hemen suya yaklaşır; ağırlığını çekince yeniden yükselir.** *Üzerinde
    kapasitesini anlatan bir yazı yoktur.*
  - Kampa çekebilirsin (zaman alır, **onu yine yalnız bırakır**), olduğu yerde
    bırakabilirsin, hiç yaklaşmayabilirsin. **Hiç yaklaşmazsan da sal
    sahanlıkta kalır; gelgit onu dünyadan silmez.**
  - **Kamptaki açıklıktan kıyının o bölümü dar bir aralıkla görünür.** Arkadaş
    başını kaldırabilecek durumdaysa turuncu şekli görebilir — **fakat
    göstermez ve bakışını orada tutmaz.**
  - *Koşulsuz iz:* `sal-dunyada`. *Koşullu:* `sal-cekildi`.
  - **Deftere:** *"Kıyıda bir sal var. Tek kişilik."* — ve çizime kayalık
    sahanlık eklenir.
- **Akşam:** ateş ancak sen odun getirdiysen yanar. Kabın dolu olması da senin
  döndüğün anlamına gelir. Yiyecek ile su verdiysen bedeni biraz gevşer;
  yalnızca birini verdiysen bu değişim kısa sürer.
- **Gece — günün asıl kararı.** Yanında kalırsan ateşe sen bakarsın; mesafe
  küçülse de onun nöbeti devralmasını beklemezsin. **Ayrılıp salın yanında ya
  da başka bir yerde uyursan sabah farkı görürsün:** nefesi daha sığdır,
  başını daha az kaldırır, uzanan eli yine yarıda kalır. **Gün içinde
  verdiğin bakımın bir kısmı kaybolmuştur.**
- **[SAHNE 9 · Son gece]** *(BEŞİNCİ gecededir — kullanıcı düzeltmesi)*
  Arkadaş hâlâ kamptaysa ikiniz de ateşin yanında uyanıksınızdır. Konuşmazsınız.
  **Bazen nefes alırken omuzlarının yükseldiğini görürsün; bazen bunu görmek
  için daha uzun süre bakman gerekir.** Ateş azalır; odun koyarsın ya da
  koymazsın. Ekranda yalnızca bir satır belirebilir: *"O hâlâ orada."*
  - **Beşinci gün ayrıldıysa iki kişilik ateş sahnesi yaşanmaz — onun
    YOKLUĞU sahnenin karşılığı olur.** Sahne yine geçer, izi yine düşer.
  - *Koşulsuz iz:* `son-gece-gecti`. *Koşullu:* `yanindaydi`, `yalniz-gecti`.
- **Gün biter. Sal kıyıdadır.**

**Gün 6 · Seçim.** *(yazılmış metin — 2026-09-24)*

> **Zaman çizgisi düzeltmesi (kullanıcı):** son gece ateş sahnesi BEŞİNCİ
> gecededir; seçim altıncı gün yaşanır; sal altıncı günün BATIMINDA gider.
> Aksi hâlde "altıncı günün akşamı, sonra sabah, yine aynı günün batımı"
> oyunu yedi güne taşıyordu.

**Şafakta üç açılıştan biri:**

| | Koşulu | Ekranda |
|---|---|---|
| **Uyanır** | Dün yiyecek + su verdin ve geceyi yanında geçirdin | Seslendiğinde başını kaldırır. Nefesi düzenlidir; hâlâ zayıf, ayağa kalkmak için zamana ihtiyacı var |
| **Uyanır ama daha güçsüz** | Eksik bakım, ama günlerdir süren ağır ihmal YOK | **Tek bir eksik jest onu bir gecede öldürmez** |
| **Uyanmaz** | Günlerdir biriken ağır ihmal | Aynı duruşla yatıyordur; **bu kez omuzları nefesle yükselmez** |
| **Orada değildir** | 5. gün yürüyebilecek durumdayken ayrıldı | Gece oturduğu yerde kimse yoktur |

> **Ölüm sürpriz değildir:** *"Dördüncü günden beri giderek daha az hareket
> ettiğini, dün uzatılan yiyeceğe elinin yetişmediğini, gece nefesinin
> seyrekleştiğini görmüşsündür. Su taşımak, yiyecek getirmek ve yanında kalmak
> için zaman vardı."*

- **Gelgit gün boyu yükselir.** Sabah suyun altında olmayan **koyu kaya
  çizgisi öğlene doğru kaybolur.** Sal sahanlıktan yavaş yavaş kalkar; kenarı
  her saat biraz daha serbestçe hareket eder. **Bunu bildiren yazı ya da sesli
  uyarı yoktur.** Sala gitmesen de su yükselir; akşam onu alacaktır.
- **Gün boyunca hiçbir şey seni zorlamaz.** Yanında oturabilir, ateşi
  besleyebilir, ona son kez su taşıyabilirsin. Sala gidebilir, kıyı boyunca
  daha yakına çekebilir, hiç dokunmayabilirsin. **Ağır, su dolmuş salı
  kayalıktan yukarı çıkaramazsın; bırakılabildiği her yer akşamki gelgit
  çizgisinin altındadır.**
- **[SAHNE 10 · Ayrılık]** *(cutscene 3 — seçimden SONRA)*

  **Arkadaş yürüyebilecek durumdaysa salın yanındaki davranışı tanıdıktır:**

  | Güven | Davranış |
  |---|---|
  | **Yüksek** | Sana yakın durur. Su salı kaldırmaya başladığında kenarından tutup **onu sana doğru iter**, sonra geri çekilir. Sen salı ona yaklaştırıp kıyıda kalırsan **önce yeniden sana bırakır.** Kararında ısrar ettiğini davranışından anlarsa bir süre sonra sala geçebilir |
  | **Orta** | Birkaç adım uzakta bekler. **Eli sala gitmez.** Kararını senin hareketinden sonra verir |
  | **Düşük** | Sal serbest kalır kalmaz ona doğru gider; sen binmediysen **senden önce yerleşir, arkasına dönmez.** *Ayağa kalkamayacak kadar güçsüzse bunu yapamaz — **güvensizlik ona kaybettiği gücü geri vermez.*** |

  **Batım yaklaşırken dört sonuçtan biri:**

  | Sonuç | Ne olur |
  |---|---|
  | **Sen binersin** | Salı suya bırakırsın. Arkadaş hayattaysa **kamera onunla kıyıda kalır**; bedeni, suya açılan sala karşı duruşundan okunur. Ölmüş ya da ayrılmışsa kamera yine kıyıdadır |
  | **Salı ona verirsin** | Binebileceği yere getirip kenara çekilirsin. **Erken yaptıysan oyun sürer:** ateşin yanına dönebilir, yakınında bekleyebilir, kıyıda tek başına yürüyebilirsin. Gelgit yükseldiğinde sal onu götürür. **Kamera seninle kıyıda kalır** |
  | **İkiniz de binmezsiniz** | Su salı kayadan ayırır. Önce birkaç adım ötede kalır, sonra akıntıyla uzaklaşır. **Altı günün mesafesi kapanışta da değişmez** |
  | **O senden önce davranır** | Düşük güvenle ve yürüyebilecek güçteyse önce o biner. **Bakışını geri çevirmeden uzaklaşır** |

  - **Uyanmamışsa** sala yaklaşırken önünde bir paylaşma kararı yoktur.
    Binebilir ya da kıyıda kalabilirsin. Boş bırakırsan gelgit onu yine götürür.
  - *Koşulsuz iz:* `oyun-bitti`. *Koşullu:* `kim-gitti`.
- **Güneş battığında kamera kıyıdadır. Kurtuluş görüntüsü, kararların özeti ya
  da doğru seçimi açıklayan bir cümle GELMEZ. Ada birkaç saniye daha görünür.
  Oyun biter.**

## 3.1 Defter — altı güne dağılımı

Defter 2. gün bulunur ve **her sahnenin koşulsuz izi düştüğünde** karakter ona
bir satır ekler. Oyuncu bu yazma anını görür (kontrol kendisindedir) ama
okumak zorunda değildir.

| Gün | Girdi |
|---|---|
| 2 | *"Uyandım. Bir kişi daha var."* (geriye dönük) · *"Çakmaktaşını bana uzattı."* · derenin ve kayalık kıyının çizimi |
| 3 | Barınağın çizimi · *"Gece bir şey geldi. Ateşin dışında durdu."* |
| 4 | *"Yakındaki her şeyi topladık."* · *"Fırtına geceyi böldü."* |
| 5 | *"Sabah kalkmadı."* · *"Kıyıda bir sal var. Tek kişilik."* |
| 6 | — **hiçbir şey yazılmaz.** Son gün defter açılmaz |

> **Altıncı günün boşluğu kasıtlıdır:** o günü yazacak kimse kalmayabilir, ve
> yazılsaydı oyun kendi sonunu yorumlamış olurdu. Defterin sustuğu tek gün,
> oyunun en çok şey söylediği gündür.

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
