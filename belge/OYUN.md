# Ada

> Bu belge oyunun **tek okumalık** anlatımıdır: ne olduğunu, nasıl oynandığını
> ve neyi hedeflediğini baştan sona anlatır. Yeni bir kişi ya da yeni bir ajan
> önce bunu okur. Tasarımın gerekçeleri `OYUN-TASARIMI.md`'de, kararların
> nasıl alındığı `KARAR-GUNLUGU.md`'de.
>
> Buradaki sayılar `betik/veri/ayarlar.gd`'den gelir; çelişirse **kod
> doğrudur** ve bu belge güncellenir.
>
> Durum: 2026-09-24 · Godot 4.7 · yapım aşamasında

---

## Tek cümle

**Issız bir adada hayatta kal — ve yanındakini kaybetme.**

Uçak düştü. Sen kurtuldun. Bir kişi daha kurtuldu.

Oyunun bütün ağırlığı o ikinci kişidedir. Hayatta kalma sistemleri — açlık,
susuzluk, ateş, gece — kendi başlarına amaç değildir; onu ortaya çıkaran
**basınçtır**. Aç olmasaydın, yiyeceğini vermek bir şey ifade etmezdi.

Birinci şahıs, 3B, tek oyunculu. **120 dakika, altı gün.** Elle kayıt yok,
kalıcı ölüm. Bir kez oynanır.

---

## Ne oynuyorsun

Kumsalda yüzükoyun uyanıyorsun. Uzakta bir enkaz var. Enkazın öbür ucunda
biri oturuyor, sana bakıyor, konuşmuyor.

Sonraki iki saat boyunca yiyecek arıyor, su taşıyor, ateş besliyor, gece
gelen bir şeyden korunuyorsun. Ama oyunun gerçekte ölçtüğü şey bunlar değil.
Ölçtüğü şey şu: **elinde tek bir parça yiyecek varken, ikiniz de açken, onu
ne yapıyorsun.**

Ekranda hiçbir gösterge yok. Açlık çubuğu yok, güven yüzdesi yok, görev oku
yok. Ne durumda olduğunu bedeninden, onun ne durumda olduğunu **onun**
bedeninden anlıyorsun.

### Günün ritmi

Bir gün 20 dakika sürer ve üçe ayrılır:

| | Süre | Ne olur |
|---|---|---|
| **Gündüz** | ~13 dk | Yiyecek, yakıt, su, barınak, yolculuk. Fedakârlık fırsatları burada doğar |
| **Alacakaranlık** | ~2 dk | Dönüş baskısı: karanlık basmadan kampta olmak |
| **Gece** | ~5 dk | Ateş başında. Az eylem, çok dikkat — **arkadaşı burada okursun** |

Gecenin sakinliği kusur değil, tasarımın kendisi. Davranışın görünür olduğu
tek yer orasıdır.

Gündüz döngüsü dört basınçtan doğar — yiyecek biter, yakıt biter, kap boşalır,
karanlık gelir — ve dördü de aynı yöne bakar: **ışığın kenarına gitmek.**

---

## Dört tuş

Oyunun bütün ahlaki seçimi tek tuş aralığına iner.

| Tuş | Ne yapar |
|---|---|
| **E** | Bağlama göre etkileş. Elinde bir şey varsa **kendine kullan** (ye, iç). Dünyada: al, kabı doldur, ateşe yakıt at, barınağı kur, salı it |
| **F** | Elindekini **ona ver** |
| **Q** | Çağır |
| **Shift** | Koş |

Aynı nesne, aynı an, iki tuş: **E kendine, F ona.** Menü yok, çark yok,
envanter ekranı yok.

### Q: oyuncunun elindeki tek soru *(K-068)*

Ekranda ilişki barı olmadığı için oyuncunun güveni okuyacağı aktif bir kanal
gerekiyordu. Q ona seslenir — karakterin boğuk mırıltısı duyulur, yaklaşık
karşılığı bir satır olarak belirir ve söner. **Arkadaş cevap vermez; cevabı
bedeniyle verir:**

| Güven | Ne olur | Sahnede ölçüldü |
|---|---|---|
| yüksek | hemen döner ve gelir | 1,05 sn sonra 2,20 m → 1,72 m |
| orta | gecikir, gelir, mesafesini korur | 4,85 sn sonra 4,28 m → 3,72 m |
| düşük | **gelmez** | hiç · 8,28 m'de kıpırdamaz |

Düşük güvendeki sessizlik oyunun en yüksek sesli işaretidir. Çağırmak güveni
ne yükseltir ne düşürür: yükseltseydi ucuz jest olurdu, düşürseydi oyuncu
bakmaktan cezalandırılırdı. Cevap veren arkadaş kendi mesafe bandının yakın
kenarına gelir — bandını terk etmez, yoksa mesafe güveni okumayı bırakırdı.

Yüksek güven + dip moral özel bir an: gelmeye karar eder, çöken beden
kalkamaz.

### İki ihtiyaç, birbirinin tersi

**Yiyecek uzakta ve az.** Günde iki porsiyon bulunur; iki kişi ~1,8 porsiyon
tüketir. Yeter ama ancak yeter. Fırsatı doğuran şey bu incelik — bolluk
olsaydı kimse acıkmaz, fedakârlık diye bir şey olmazdı.

**Su yakında ama taşınmak zorunda.** Dere açıklığın içindedir; evde su
bedavadır. Ama enkazdan çıkan **tek bir kap** vardır ve bir dolum bir
kişiliktir. Susuzluk yalnızca iki yerde ısırır: uzak yiyecek yolculuğunda ve
arkadaş kalkamaz haldeyken. İkisi de oyunun zaten basınç istediği anlardır.

Açlık ve susuzluk bedende farklı okunur: açlık ağırlaşma ve derin nefes,
susuzluk görüşün kenarında kuruluk ve yutkunma. Eşik geçilince ekranda bir kez
kısa bir satır belirir — *"açsın"*, *"susadın"*. Ne yapacağını söylemez, ne
yaşadığını söyler.

---

## Arkadaş — oyunun kalbi

Adı söylenmez. Nereden geldiği söylenmez. Kim olduğu hiç anlatılmaz — ve
**çelişen bir ipucu da yoktur; hiç ipucu yoktur.** Ama ne olduğunu
davranışından öğrenirsin: neyi paylaşır, neye kızar, ne zaman yanında durur.

Bağlanma bilgiden değil, birlikte yaşanandan doğar. Kopmayı zorlaştıran da
odur.

### Gerçek bir insan gibi hissetmeli

Bu bir üslup tercihi değil, kabul kriteridir. Dil modeli kullanılmaz; insanlık
tamamen davranıştan gelir:

- **Kendi gündemi vardır.** Sen olmasan da bir şey yapar: su içmeye gider,
  ateşe odun atar, oturup dinlenir. *Tepki veren şey evcil hayvandır; kendi
  işi olan şey insandır.*
- **Gecikir ve tereddüt eder.** Çağırınca hemen dönmez. Bazen başlar, durur,
  yarım kalan işine bakar ve ona döner.
- **Her şeyi görmez.** Arkası dönükken olanı bilmez. Sen bakmıyorken yaptığın
  fedakârlığı bilmez — ve sen bakmıyorken yediğini de bilmez.
- **Seçici hatırlar.** İlk geceyi yalnız mı geçirdin, yaralıyken yanında
  mıydın — bunlar aklında kalır.
- **Tutarsızdır ve beceriksizdir.** Aynı durumda hep aynı şeyi yapmaz. Bazen
  ateşi tutturamaz. *Kusursuz olan şey insan değildir.*
- **Kişiliği geçmişten değil alışkanlıktan gelir.** Hep ateşin aynı tarafına
  oturur; yakıtı atmadan önce yoklar; yürürken bir kez geriye bakar.

### Güven ve moral: iki ayrı eksen

Hiçbir sayı gösterilmez. İkisi ekranda **farklı kanallardan** okunur, yoksa
birbirine karışırlar.

**GÜVEN → mesafe, yönelim, bakış.** Onu sen belirlersin.

| Seviye | Ekranda | Mesafe |
|---|---|---|
| **Yüksek** | Yakında yürür, göz teması kurar, sen söylemeden iş yapar, paylaşır, tehlikeye seninle girer | 1,5–2,5 m |
| **Orta** | Mesafe açar, çağırınca gecikerek gelir, kendi işini yapmayı tercih eder | 3,5–5,5 m |
| **Düşük** | Uzakta durur, göz teması kurmaz, çağırınca gelmez, takibi bırakır | 7–10 m |

**MORAL → tempo, duruş, çevreye dikkat.** Koşullar iter, ihmalin dibi açar.

| Seviye | Ekranda |
|---|---|
| **Yüksek** | Normal tempo, çevreye tepki verir |
| **Orta** | Yavaşlar, sık sık durup bekler |
| **Dip** | Oturur ve kalkmak istemez, tehlikeyi umursamaz, seni uyarmaz |

Yüksek güvenli ama morali dibe vurmuş bir arkadaş mümkündür ve **en acı durum
odur**: sana bakar, ama kalkmaz.

### Güven nasıl yükselir

Tek ilke: **o an senin ihtiyacın olan bir şeyden vazgeçmek.** Her yolun bir
"ucuz ikizi" vardır ve o yükseltmez.

| Yol | Senin bedelin | Ucuz ikizi |
|---|---|---|
| Açken yiyeceğini/suyunu vermek | Açlık, susuzluk | Tokken ya da bolken vermek |
| Onu tehlikeden çıkarmak | Güvenliğin | Tehlike yokken yanına gitmek |
| Riskli işi onun yerine üstlenmek | Güvenliğin | Aydınlıkta, tehlikesiz iş |
| Yaralıyken ona bakmak | Zamanın, yiyeceğin | Yaralı değilken ilgi |
| Salı ona vermek | Adadan çıkış | — |

Yükseliş yavaştır: günde en çok iki jest sayılır, yüksek güvene çıkmak beş-altı
bedelli jest ister. **Düşüş iki kat hızlıdır** — bir ihanet iki fedakârlığı
siler. Ve her düşüş, **onun ihtiyacı olan** bir şeyi almak ya da vermemektir:
gözünün önünde yiyip vermemek, yaralıyken geceyi yalnız bırakmak, tehlikede
bırakıp kaçmak, "bekle" deyip dönmemek.

**Arkadaş yalnızca gördüğünü değerlendirir.** Yokluk da algıdır: yanında
olmadığını fark eder.

Gece görüşü daralır — ama **ateşin aydınlattığı çemberde algı gündüz gibi
çalışır.** Ateş başında geçen gece okunur; ateş sönerse okunmaz. Uzaktaki
birine karanlıkta ulaşmak hâlâ yanına gitmeyi gerektirir.

---

## Defter

Enkazda boş bir defter bulursun. Karakterin onu kendi eliyle doldurur; üç şey
yazar: **olan biten** (geçmiş zaman), **adanın çizimi**, ve **sayılı birkaç
çekirdek iş** — ateş, su, barınak, sal.

Defter ekran üstü bir gösterge değildir: dünyada bir nesnedir, açmak senin
seçimindir, yazarken kontrol sende kalır.

**Ve defter arkadaş hakkında hiçbir iş yazmaz.** İlişkiye dair hiçbir
yönlendirme vermez — o alan tamamen senindir. Dünya işlerini defter
üstlendiği için arkadaş yalnızca **ilişkinin** kanalı olarak kalır.

---

## Altı gün

Omurga yazılıdır, eti ilişkiden gelir. Ne zaman ve nerede olacağı sabittir;
**nasıl** geçeceği sana bağlıdır. Aynı fırtına gecesi, güven yüksekken "seni
kolundan çeken biri", düşükken "tek başına giden biri"dir. Sahne aynı,
sahnedeki insan farklı.

| Gün | Kimliği | Ne olur |
|---|---|---|
| **1** | Uyanış *(~7 dk)* | Gün batımında kendine gelirsin. Enkazın kapısı sıkışmış, açamazsın. Arkandan biri gelir — konuşmaz, tuhaf biçimde sakindir. Eliyle çağırır, odun toplar, yakmayı dener; yakacak bir şey yoktur. Soğukta uyuyakalırsın |
| **2** | Ateş ve ilk paylaşım | Kapıyı birlikte açarsınız. İçeride ateş başlatıcısı, bir kap, boş bir defter. Dere ve açıklık bulunur; akşam ilk ateş yanar. Bir balık yakalarsınız — büyük parçayı ona verdiğinde kendi payından bir lokma ayırıp önüne bırakır |
| **3** | Barınak ve köpek | Kayanın arkasına barınak kurulur ama **üstü açık kalır.** Gece yiyeceğin kokusuna bir köpek gelir. Araya girersen sen yaralanırsın; girmezsen o yaralanır ve yiyecek gider |
| **4** | Kim gidecek | Yaralı olan yavaştır. Enkazın çöken bölümü açılır; çatı malzemesi oradadır ve yol uzundur. Biriniz gitmeli. Gece fırtına, dün açık bırakılan çatıyı sınar |
| **5** | Çöküş ve sal | Fırtınadan sonra kalkamaz. Tek kapla su taşırsın; her gidiş onu yalnız bırakır. Aynı gün kıyıya tek kişilik bir sal vurur. Gece ateş başında son kez yan yanasınız |
| **6** | Seçim | Şafakta ya uyanır, ya uyanmaz, ya da orada değildir. Gelgit gün boyu yükselir. Batımda sal gider — biriyle ya da boş |

Oyuncu bir sahneye gelmezse sahne **sensiz** olur; izi yine dünyada kalır ve
hikâye ilerler. Hiçbir şey yapmayan bir oyuncuda bile oyun sonuna varır — ama
bambaşka bir oyun olur.

Kontrolün tamamen alındığı **yalnızca üç an** vardır: uyanış, fırtınanın
uyanma anı, ve kapanış. Gerisinde kontrol sende kalır.

---

## Tehdit ve ölüm

Fantastik yaratık yok, kötü adam yok. Tehdit hayvan ve doğadır: yaban köpeği,
deniz, fırtına, soğuk.

**Yaralanma az ve keskindir:** sağlam ya da yaralı. Yaralı olan yavaş yürür,
koşamaz, zamanla iyileşir. Yaralıyken ikinci ciddi saldırı öldürebilir —
yani ölümden önce her zaman bir uyarı vardır.

**Arkadaş tehditten ölmez.** Hayvan ve doğa onu yaralar, yıpratır, korkutur —
öldürmez. Ölümü ancak **senin birikmiş ihmalinin** sonucudur ve ani değildir:
çöküş dördüncü günden itibaren görünür hale gelir, iki tam gün müdahale
penceresi vardır, ve en erken altıncı günün şafağında gelir.

Biçimi yavaş bir vazgeçiştir. Nefesi seyrekleşir, başı düşer, uzatılan
yiyeceğe uzanmaz, ateşe dönüp bakmayı bırakır. Bir sabah uyanmaz.

Geri döndürülebilir — ama tek bir jestle değil: yiyecek **ve** su **ve**
geceyi yanında geçirmek gerekir. Gece ayrılırsan kaybettiğin de ekranda
görünür.

Arkadaş ayrıca **çekip gidebilir**. Güven dibe vursa bile beşinci günden önce
gitmez: uzaklaşır, konuşmaz, ateşin karşı tarafında uyur — ama oradadır.
Gidince geri kazanılmaz.

Çaresizlikte sana karşı güç de kullanabilir: yiyeceği zorla alır, araya
girersen seni iter. Bu bir tehdit türü değil, ilişkinin sonucudur.

---

## Sonlar

Uçaktan kopmuş küçük bir şişme can salı kıyıya vurur. **Bir yetişkini taşır.**
İki kişi binince su alır ve battığı gözle görülür — bunu deneyerek öğrenirsin,
hiçbir yazı söylemez.

Salı kim alır? Sen binebilirsin. Ona verebilirsin — oyunun en büyük bedelli
jesti. O da kendi kararını verir: salı sana doğru iter, kalmayı seçer, ya da
bir gece salla birlikte kaybolur.

Sal kıyıdan açılınca **kamera kıyıda kalanla kalır.** Kurtuluş gösterilmez.

- **Arkadaş öldüyse:** sal yine gelir. Soru "kim gidecek"ten **"gidebilir
  miyim"e** döner.
- **Arkadaş çekildiyse:** salı senden önce o bulabilir. Kıyıda salı yerinde
  bulmamak da bir sondur.

Sen ölürsen kamera yere iner ve bakış toprak hizasında kalır. Dünya on saniye
daha akar: ateş yanar, köpek çekilir, arkadaş güvenine göre davranır. Son
gördüğün şey ilişkinin son hâlidir.

---

## Bu oyun ne DEĞİL

Bunlar tercih değil, değişmez kurallar:

- **İlişki barı yok.** Hiçbir sayı, çubuk, yüzde gösterilmez.
- **Dil modeli yok.** Arkadaş ihtiyaç tabanlı utility AI ile yapılır.
- **Öğretici yok, HUD yok, işaret ve ok yok.**
- **Kelime neredeyse yok.** Arkadaş konuşmaz — nefes, iç çekme, uyarı, acı
  sesi. Bütün oyunda en fazla üç-beş anda bir-iki kelime.
- **Elle kayıt ve yükleme yok.** Tek yuvaya sürekli yazılır; ölüm kesinleştiği
  an yuva silinir.
- **Multiplayer yok. Tekrar oynanabilirlik hedeflenmez.** Ada elle tasarlanır,
  prosedürel üretilmez — tek ada, her tepesi kasıtlı.

---

## Görünüm ve ses

Doğal, kasvetli ve **tutarlı stilize.** Gerçekçilik kovalanmaz; gerilim
ışıktan, karanlıktan, sesten, bedenin zamanlamasından ve **gösterilmeyenden**
kurulur — doku çözünürlüğünden değil.

Stil birliği tek tek varlıkların kalitesinden önemlidir: farklı ellerden
çıkmış ama aynı dilde konuşan bir dünya, tutarsız bir gerçekçilikten iyidir.

Ses en güçlü koz: dal kırılması, uzaktan hırıltı, arkadaşın nefesinin ritmi.
Gecenin korkusu poligonla değil, **ateşin ışık yarıçapıyla** kurulur — tehdit
o sınırın dışında durur.

Oyun iki dillidir: Türkçe ve İngilizce.

---

## Teknik

Godot 4.7, GDScript, masaüstü (macOS). Hedef makine fansız bir MacBook Air
M2 — performans bütçesi ona göre geçerlidir: ortalama kare süresi ≤ 16,7 ms.
**Görsel hedefle bütçe çakışırsa bütçe kazanır.** Stilize bir HEDEFTİR;
60 fps bir SINIRDIR.

Bütün varlıklar CC0 (ücretsiz, kamu malı); bütçe sıfırdır.

Oyunun kuralları, arkadaşın kararları ve hikâye zinciri **görsel katmandan
tamamen ayrıdır** — pencere açmadan, saniyenin altında, belirlenimci olarak
koşar ve ölçülür. Arkadaşın davranışı ekranda görülmeden önce sayıyla
doğrulanır.

---

## Şu anki durum (2026-09-24)

Çalışan: saf simülasyon katmanı (ihtiyaçlar, güven, moral, ihmal, fırsat
sayacı), altı günlük hikâye zinciri, defterin veri modeli, gri kutu sahnesi ve
birinci şahıs kontrol, çalıştırılabilir bir macOS yapısı.

Altı günlük koşu üç oyuncu tipini ayrıştırıyor:

| | Fırsat | Alınan | Güven | Son |
|---|---:|---:|---|---|
| fedakâr | 11 | 11 | **yüksek** | — |
| dengeli | 9 | 6 | **orta** | — |
| bencil | 4 | 0 | **düşük** | arkadaş gitti |

Sıradaki: kayıt/yükleme, iki dil, ve arkadaşın gövdesinin sahneye bağlanması.
Asıl kilometre taşı ondan sonra: **kodu bilmeyen birinin üç dakikalık bir
kaydı izleyip arkadaşın güven seviyesini söyleyebilmesi.** O gün oyunun kalbi
ilk kez ekranda görünmüş olacak.
