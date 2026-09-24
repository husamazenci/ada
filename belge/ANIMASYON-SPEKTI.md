# Arkadaş NPC animasyon durum makinesi

> Yazan: **ChatGPT (Sol-6)**, 2026-09-24 · pano §5 maddesi.
> İnceleyen: **Claude** — bağlantılar doğrulandı, iki eksik ve bir sonuç
> uyarısı belgenin sonuna eklendi. Bu bir SPEKTİR, karar değildir: eksikler
> kapanmadan ve kullanıcı onaylamadan gövde koda bağlanmaz.

**Hedef:** Arkadaşın güveni oyuncuya göre **mesafe, yönelim ve bakışından**;
morali ise **tempo, duruş ve çevreye verdiği tepkiden** okunur. Ekranda sayı,
ilişki göstergesi veya diyalog bulunmaz. Nefes, iç çekme ve acı sesi
kullanılabilir; sözcük kullanılmaz.

## 1. AnimationTree mimarisi

**İç içe yapı:** AnimationTree'nin kökünde bir BlendTree, içinde tam beden için
bir StateMachine. StateMachine'in hareket durumu, sekiz yönlü yürüyüş için
BlendSpace2D içerir. Jog ve sprint ayrı hareket durumlarıdır. Baş ve üst gövdeye
uygulanan küçük bakış, nefes ve duruş değişimleri tam beden durumunun üzerine
sınırlı bir katman olarak eklenir.

Utility AI **ne yapacağını** seçer; AnimationTree **nasıl görüneceğini** üretir.
Güven ve moral için dokuz ayrı animasyon durumu kurulmaz. Güven; takip
mesafesini, gövdenin oyuncuya dönme eğilimini, bakışı ve seçilen işleri
etkiler. Moral; gerçek hareket hızını, duruşu, duraklama sıklığını ve çevreye
dikkati etkiler. Böylece orta güvenin çağrı gecikmesi, orta moralin yavaş
yürüyüşüne dönüşmez.

**Root motion kullanılmaz.** NPC'nin konumunu çarpışma ve yol bulma yönetir;
animasyonlar yerinde oynar ve oynatma hızı gerçekleşen harekete uydurulur.
Sebep: oyuncunun yanında değişken mesafeyle yürürken animasyon ile gerçek
konum ayrışır. Oturma ve itme gibi temas hareketlerinde NPC önce uygun noktaya
hizalanır.

**Kaynak sınırı:** Quaternius kütüphanesi 120+ animasyon içerir; ücretsiz
indirme paketin bir bölümüdür. Listelenmeyen bir hareket, hazır klip varmış
gibi kabul edilmez; nötr poz, baş/üst gövde dönüşü ya da mevcut kliplerin
güvenli geçişleriyle üretilir.

**Performans bütçesi (başlangıç):** aynı anda en çok iki tam beden klibi
harmanlanır. Utility seçimi ~4 Hz, bakış ve algı ~10 Hz. Yol yalnızca hedef
değişince, engel oluşunca veya anlamlı sapma olunca yeniden hesaplanır.
Son değerler gerçek sahnede ölçülür (K-047: bütçe görselden önce gelir).

## 2. Durumlar

| Durum | Animasyon kaynağı | Döngü | Kullanım |
|---|---|---|---|
| **Boşta** | Nötr ayakta poz; emote parçaları; hafif nefes | Evet | Her boşluğu aynı emote ile doldurmaz. Ara sıra ağırlık değiştirir, bazen hiçbir şey yapmaz. |
| **Yürü** | Sekiz yönlü yürüyüş, BlendSpace2D | Evet | Hız gerçek yer değiştirmeye eşlenir. Moral adım temposunu etkiler. |
| **Jog** | Jog klibi | Evet | Yetişme veya acele. Her çağrıda otomatik kullanılmaz. |
| **Sprint** | Sprint klibi | Evet | Yakın ve anlaşılmış tehlikede kısa süreli. Düşük moralde gönüllü tetiklenmez. |
| **Durakla** | Yürüyüşten nötr poza geçiş | Süreli | Karar, nefeslenme, yol arama, dikkat kayması. Süre sabit değildir. |
| **Yönel / tara** | Nötr poz; baş ve sınırlı üst gövde dönüşü | Süreli | Oyuncuya veya gerçekten algılanmış olaya bakma. Yüz animasyonu gerekmez. |
| **İşe başla** | Nötr pozdan ilgili hareketin ilk fazına | Hayır | Kısa hazırlık; her işe aynı törensel jest eklenmez. |
| **İt** | Push klibi | Faz döner | Nesneyle temas gerektirir; temas kesilirse hareket kesilir. |
| **Sürün** | Crawl klibi | Evet | Alçak geçit veya zorunlu siper. |
| **Yüz** | Swim klibi | Evet | Karaya çıkış gerçek konumla eşleşir. |
| **Oturmaya geç** | Sitting giriş fazı | Hayır | Oturma noktası seçilip hizalandıktan sonra. |
| **Oturmuş** | Sitting oturmuş pozu; nefes | Poz korunur | Moral dipte temel durum. Kendi isteğiyle hemen kalkmaz. |
| **Kalk** | Sitting güvenli çıkış fazı | Hayır | Oturmuştan yürüyüşe doğrudan sıçrama yapılmaz. |
| **İrkil / acı** | Kısa, sınırlı gövde tepkisi; acı sesi | Hayır | Yalnızca hissedilen temas veya hasar. |
| **Ölüm** | Death klibi | Hayır; son poz korunur | Geri dönüşsüz son durum. |

## 3. Güven × moral matrisi

Mesafeler NPC **ayaktayken ulaşmaya çalıştığı** aralıklardır. Tempo çarpanı
aynı hareket türünün normal hızına göredir.

| Güven | Moral | Mesafe | Yönelim | Tempo | Duruş | Bakış |
|---|---|---:|---|---:|---|---|
| Yüksek | Yüksek | 1,5–2,5 m | Gövdesi sık sık oyuncuya açılır; işini bitirince yakına döner | ×1,00 | Dik, hareketli | Kısa göz teması; çevredeki yeni olayı da izler |
| Yüksek | Orta | 1,5–2,5 m | Yakında kalmayı seçer; durduğunda gövdesi oyuncuya dönük | ×0,70 | Omuzlar düşük; sık nefes ve duraklama | Bakar, sonra başını indirir; çevreye tepkisi seyrek |
| Yüksek | Dip | Otururken 1,5–2,5 m | Yakında oturur; kalkmadan üst gövdesini çevirir | ×0 | Oturmuş, çökmüş | Yakındaysa başını kaldırıp kısa göz teması; çevreyi taramaz |
| Orta | Yüksek | 3,5–5,5 m | Yana dönük çalışır; çağrıyı duyunca gecikerek yönelir | ×1,00 | Dik, kendi işiyle meşgul | Kısa yan bakış; çevreyi izler |
| Orta | Orta | 3,5–5,5 m | Kendi işine dönük; çağrıdan sonra gecikerek yönelir | ×0,70 | Hafif çökmüş; sık durur | Önce işine/yere, sonra kısa yan bakış |
| Orta | Dip | Otururken 3,5–5,5 m | Yarım döner ama kalkmaz | ×0 | Oturmuş, çökmüş | Bir süre sonra başını hafif çevirir; tam göz teması yok |
| Düşük | Yüksek | 7–10 m | Uzağa yönelir; kendi güvenli hattını seçer | ×1,00 | Dik, çevreye hazır | Çevreyi izler; göz temasından kaçınır |
| Düşük | Orta | 7–10 m | Sırtı veya yanı oyuncuya dönük | ×0,70 | Düşük omuzlar; durup bekler | Yere ve çevreye seyrek bakar; oyuncuya bakmaz |
| Düşük | Dip | Uzak oturma noktası, 7–10 m | Sırtı dönük oturur; çağrıya yönelmez | ×0 | Oturmuş, çökmüş | Başını kaldırmaz; tehlike uyarısı vermez |

Güven yüksekken paylaşma ve tehlikeye birlikte girme olasılığı artar; bunlar
**eylem seçimidir**. Moral dipte aynı kişi bu niyeti bakışla belli edebilir ama
kalkıp gerçekleştirmeyebilir. Güven düşükken yüksek moral, NPC'yi canlı ve
hızlı gösterir; oyuncuya yakın göstermez.

## 4. Geçiş ve harmanlama

| Geçiş | Süre | Gerekçe |
|---|---:|---|
| Boşta ↔ yürü | 0,20–0,35 sn | Ayakların bir anda kaymaya başlamasını önler |
| Yürü ↔ jog ↔ sprint | 0,15–0,25 sn | Adım fazı eşlenir; gövde sıçramaz |
| Hareket → durakla / yönel | 0,25–0,45 sn | Önce durur sonra bakar; her algılamada aniden dönmez |
| Yürü → işe başla → it | 0,35–0,60 sn | Önce hizalanır ve temas kurar; itme boşa oynanmaz |
| Ayakta → oturmaya geç | 0,55–0,90 sn | Oturma noktasına ulaşıldıktan sonra |
| Oturmuş → kalk → yürü | 0,70–1,20 sn | Ağırlık hissedilmeli. Moral dipte sıradan çağrı tetiklemez |
| Hareket ↔ sürün / yüz | 0,30–0,60 sn | Yalnızca uygun zemin/su sınırında |
| Her durum → irkil / acı | 0,05–0,12 sn | Temas gecikmeden okunmalı |
| Her durum → ölüm | 0–0,08 sn | Aciliyet korunur; son pozdan dönülmez |
| Güven hedefi değişimi | 4–8 sn | Konum atlamaz, tek karede yüz çevirmez |
| Moral hedefi değişimi | Tempo 0,8–1,5 sn; duruş 1–2 sn | Yorgunluk bedende kademeli görünür |

**Ani geçiş yalnızca gerçek temas, hasar ve ölüm içindir.** Algılama, karar,
güven ve moral değişimleri yumuşaktır.

## 5. Gecikme, tereddüt ve alışkanlık

**Çağrıyı fark etme süresi GÜVENE bağlıdır:** yüksek güvende 0,4–1,2 sn; orta
güvende 2–5 sn; düşük güvende gelme kararı çıkmaz. **Moral bu ilk gecikmeyi
belirlemez** — yanıt verdikten sonraki yürüme hızını ve duraklamayı belirler.
Bu yüzden yüksek güvenli, morali dipte bir arkadaş oyuncuya bakabilir ama
oturduğu yerden kalkmaz.

**"Başlar–durur–geri döner"** yalnızca orta güvende, yarım kalmış işi ile
çağrının önceliği yakınsa tetiklenir: bir adım atar, 0,8–2 sn durur, yarım
işine bakar ve ona döner. Arka arkaya tekrarlanmaz.

NPC'nin **kendi gündemi** vardır: su aramak, gölge seçmek, nesne düzeltmek,
dinlenmek. İşi oyuncunun hareketiyle her seferinde iptal edilmez. Gördüğünü ve
duyduğunu hatırlar; görüş dışındakini bilmez. Bıraktığı işi yoklaması, sık
geçtiği yolu tercih etmesi ve yorulunca aynı yere oturması **geçmişini
anlatmadan alışkanlıkla kişilik kurar**.

## 6. İllüzyonu kıranlar ve karşı önlem

| İllüzyonu kıran | Karşı önlem |
|---|---|
| Anında tepki | Algılama, yönelme ve güvene bağlı gecikme tamamlanmadan eylem başlamaz |
| Kusursuz yol bulma | Yol gerektiğinde hesaplanır; küçük engelde bir an durup alternatif yoklar |
| Aynı animasyonun tekrarı | Başlangıç fazı, bekleme uzunluğu, adım hızı bağlama göre değişir |
| Görmediği şeye tepki | Görüş açısı, engel ve işitme menzili kontrol edilmeden bilgi karar sistemine girmez |
| Hiç boşta kalmamak | Boştada 5–15 sn süren, karar vermediği doğal aralıklar var |
| Sürekli oyuncuya bakmak | Bakış kısa ve güvene bağlı; başın varsayılan hedefi kendi işi veya çevre |
| Hiçbir şeyi başlatmamak | Komut olmadan ihtiyaçlarından iş seçip fiziksel olarak başlar |
| Her zaman müsait olmak | Süren iş, yorgunluk ve oturma yanıtı sınırlar |
| Hiç yanılmamak | Ara sıra yanlış yöne başlayıp gördüğü işaretle rotasını düzeltir |
| Kusursuz jestle anlatmak | Tek anlamlı tekrar eden "mesaj jestleri" yok; ihtiyaç duruş, tempo, bakış ve yarım kalan eylemlerin birleşiminden anlaşılır |

## 7. Üç dakikalık kör kayıt testi

Her kayıt aynı sahnede: oyuncu bir kez uzaklaşır, bir kez çağırır, yakınına
kaynak bırakır, ikisinin de algılayabileceği bir tehlikeye yaklaşır. Gösterge
veya açıklama yok. Önce **moral yüksek tutularak** güven okunurluğu sınanır;
sonra aynı düzen orta ve dip moral için tekrarlanır.

| Gizli güven | İzleyenin üç gözlenebilir işareti |
|---|---|
| **Yüksek** | Uzaklaşınca yeniden yakına gelir; çağrıyı kısa sürede kabul eder; paylaşmayı veya tehlikede yanına geçmeyi kendi başlatır |
| **Orta** | Birkaç metre açıklığı korur ve işine döner; çağrıya belirgin gecikmeyle yönelir; yaklaşmaya başlayıp yarım işi için durabilir |
| **Düşük** | Uzak konum seçer, takip hattını bırakır; göz teması kurmaz; çağrıdan sonra hareket başlatmaz |

**Kritik uyarı (belgenin kendi katkısı):** dip moralin oturması ya da orta
moralin yavaşlığı izleyiciyi sistematik olarak "düşük güven" yanıtına
götürüyorsa, animasyon kanalları yeterince ayrışmamış demektir.

## 8. İhtiyaç bakışı

Bakışın üç hedefi vardır: **oyuncu**, **algılanmış çevre** ve **ihtiyaç
nesnesi**. İhtiyaç nesnesi, açlıkta oyuncunun elindeki veya görülen yiyecek;
susuzlukta su kabı veya görülen deredir. NPC görüşü kapalı bir nesneye bakmaz.
Sahne düzeni, ihtiyaç duyulan nesnenin ikisinin de görebileceği bir konuma
gelebilmesini sağlamalıdır; aksi halde bakış ipucu oyuncuya ulaşmaz.

İç açlık/susuzluk şiddeti 0–100'dür ve **oyuncuya gösterilmez**. Eşikler bakışı
açar, tüketimi zorlamaz.

| İç ihtiyaç | İhtiyaç nesnesine bakış | Öncelik ve sıklık |
|---|---|---|
| 55'in altında | Özel ihtiyaç bakışı yok | Güvene bağlı oyuncu bakışı ve doğal çevre taraması sürer |
| 55–79 | İlk bakış 15–35 sn içinde; üç dakikada 1–2 kez, her biri 0,7–1,2 sn | Oyuncuyla kurulan bakışı veya süren işi kesmez |
| 80 ve üstü | İlk bakış 8–18 sn içinde; üç dakikada 3–5 kez, her biri 1,0–1,8 sn | Olağan çevre taramasının önüne geçer; doğrudan çağrıyı kesmez |

Her aralık değişken seçilir; iki ihtiyaç bakışı arasında **en az 20 sn** bulunur.
Nesne eldeyse baş ve göz hizası **nesneye** yönelir, oyuncunun yüzüne değil —
böylece düşük güvenli arkadaş yiyeceğe bakarken göz temasından kaçınmayı
sürdürür. İki ihtiyaç birden aşılmışsa şiddeti yüksek olanın **görülebilen**
nesnesi seçilir; ikisi arasında ritmik gidip gelme yapılmaz. İhtiyaç 45'in
altına inince orta, 70'in altına inince acil sıklık kapanır (histerezis).

Gerçekten algılanmış acil tehlike, moral dipte değilse kısa süreliğine bütün
bakış hedeflerinin önüne geçer. NPC **işaret etmez, yiyecekle oyuncunun yüzü
arasında ritmik bakmaz, her teklif anında aynı hareketi yapmaz.** İpucu
seyrektir ama doğrudur: açlık suya, susuzluk yiyeceğe sahte bir "mesaj bakışı"
üretmez. Okunurluk nesnenin seçilmesinden ve birkaç dakika içinde tekrar
görülebilmesinden gelir, kusursuz bir jestten değil.

## 9. Çöküş ilerlemesi

**Vazgeçiş**, "Oturmuş" ile "Ölüm" arasındaki ayrı ve kademeli eksendir. Güven
veya moral seviyesi değildir; birikmiş ihmalin günler içindeki bedensel
sonucudur. Tehdit, düşme ve saldırı acı veya geçici hareketsizlik yaratabilir,
fakat **Ölüm durumuna geçiş açmaz.** Ölüm yalnızca ihmalin sürmesi halinde
**en erken 6. gün şafağında** değerlendirilir.

İlk üç günde açlık, susuzluk ve yalnız geçen geceler birikir; artan ihtiyaç
bakışı ve düşen moral erken uyarıdır. Birikim ağırsa **4. gün şafağında**
görünür çöküş başlar. 4. ve 5. günün tamamı (her biri ~20 dk) müdahale
penceresidir. Açılar ayakta nötr baş pozuna göredir.

| Zaman ve durum | Nefes | Baş | Bakışı kaldırma | Uzatılan yiyecek | Dokunuş |
|---|---|---|---|---|---|
| **4. gün · geri çekilme** | Dk'da 10–12; derinlik ~%65. Nefes sesi belirginleşir | 12–18° aşağı | Yaklaşmada ~%70; 0,6–1,2 sn sonra kısa bakış | Kendi aramaz; elde tutulursa 1–3 sn sonra küçük lokma alabilir | Başını/omzunu dokunuşa doğru az çevirir; kalkmaz |
| **5. gün · vazgeçiş** | Dk'da 7–9; derinlik ~%45. İç çekmelerin arası açılır | 25–32° aşağı | Yaklaşmada ~%30; bakış kısa ve yarım kalır | İlk teklife uzanmaz. Su verilip 60–120 sn yanında kalınırsa küçük lokma alabilir | İlk dokunuşta tepki vermeyebilir; uzun kalınırsa teması kabul eder |
| **5. gecenin sonu · sınır** | Dk'da 5–7; derinlik ~%25. Uzun sessizlikler | 38–45° aşağı | Yaklaşmada ~%10; baş birkaç derece kalkar | Kendiliğinden yemez. Şafaktan önce su + yanında kalma ile son teklif kabul edilebilir | Kısa dokunuşa tepki yok; yanında kalınırsa nefes ritmi düzelebilir |

Bu değerler **sahne hedefidir**, ekranda ölçüm olarak görünmez. Değişim tek
karede olmaz: yeni gün başlayınca nefes, baş açısı ve tepki gücü 2–4 dakikada
kötüleşir. Oyuncu aynı oturuşun dün daha canlı olduğunu fark edebilmelidir.
Arkadaş ateşe dönüp bakmayı ve kendiliğinden yemeyi giderek bırakır; son gece
ateş yakılsa da ona yönelmez.

**Geri dönüş tek bir eşya verme animasyonu değildir.** Oyuncu şafaktan önce
yiyecek ve su sağlar **ve** geceyi yanında geçirirse çöküş durur. 4. günde
müdahalede önce nefes 20–40 sn içinde derinleşir, sonra baş 2–3 dakikada
yükselir; arkadaş uygun fırsatta kalkmayı dener. 5. günde önce suya ve varlığa
tepki gelir, sonra yiyeceği kabul eder; kalkış ancak sonraki şafakta mümkündür.
Yalnızca yiyecek ya da yalnızca su kısa bir iyileşme yaratır ama süreci tersine
çevirmez. Oyuncu gece ayrılırsa nefes ve baş yeniden ağırlaşır; bu kayıp da
ekranda görülür.

**6. gün şafağı karar anıdır:** toparlanma başlamışsa arkadaş uyanır — hâlâ
zayıftır ama başını kaldırır ve nefesi düzenlidir. İhmal sürmüşse sabah
uyanmaz; ancak o zaman hareketsiz son poza geçilir. Böylece oyuncu iki tam gün
boyunca yaklaşan sonucu görür; ölüm bir saldırının ya da ani şanssızlığın
sonucu gibi görünmez.

---

# Claude'un incelemesi (§6.6 — `[x]` bitmiş sayılmaz, ölçülür)

**Bağlantılar doğrulandı:** üç URL de çalışıyor (Godot AnimationTree, 
AnimationNodeStateMachineTransition, Quaternius). Kaynak uydurulmamış.

## Doğru verilmiş asıl karar

**Dokuz hücre için dokuz animasyon durumu KURULMAMASI.** Güven → mesafe,
yönelim, bakış; moral → tempo, duruş, duraklama. Bu tam olarak §4'ün istediği
"iki ayrı kanal" ve kombinatoryal patlamayı önleyen tek doğru yaklaşım.
Dokuz durum kurulsaydı her yeni eksen (yara, açlık) durum sayısını katlardı.

**Root motion kullanılmaması** da doğru gerekçeyle verilmiş: değişken mesafeyle
takip eden bir arkadaşta animasyon ile gerçek konum ayrışır. Konumun tek sahibi
hareket sistemi olmalı.

**Bizim yakalamadığımız bir riski yakalamış:** dip moralde oturmak, izleyici
tarafından sistematik olarak "düşük güven" diye okunabilir. Kabul kriterimiz
tam da bu ayrımı gerektiriyor; kör kayıt testine bu kontrolü koyması değerli.

## İKİ EKSİK — doldurulmadan gövde koda bağlanamaz

### 1. İhtiyaç bakışı yok (K-056 ihlali)

Belge bakış hedeflerini yalnızca "oyuncu" ve "çevre" olarak tanımlıyor. Ama
K-056 üçüncü bir kanal şart koşuyor: **arkadaşın ihtiyacı bakış yönünden
okunur** — aç arkadaş oyuncunun elindeki yiyeceğe bakar, susamış arkadaş
dereye ya da kaba bakar.

Bu süs değil, mekaniğin şartı: oyuncu **neyi** vereceğini yalnızca buradan
bilebilir. Ekranda gösterge yok, kelime yok. Bu kanal olmazsa "ver" eylemi
kör atışa döner ve oyunun tezi ("sen açken vermek") oynanamaz hale gelir.

**Gereken:** bakış hedefi listesine `ihtiyaç nesnesi` eklenmeli; aç/susuz
eşiği geçildiğinde bu hedefin önceliği yükselmeli, ama "mesaj jesti"ne
dönüşmeyecek kadar seyrek ve kısa kalmalı (belgenin kendi 6. maddesindeki
"derdini kusursuz jestle anlatmaz" kuralıyla çelişmemeli).

### 2. Çöküş ilerlemesi yok (K-055/D1 ihlali)

Belgede `Oturmuş` ve `Ölüm` var ama **arasındaki günler yok.** Değişmez kural
şunu şart koşuyor: ölüm ani değildir, çöküş 4. günden itibaren **görünür**,
en erken 6. günün şafağında gelir ve iki tam gün müdahale penceresi vardır.
Biçimi de karar bağlandı: **yavaş vazgeçiş** — yemez, kalkmaz, ateşe bakmaz,
bir sabah uyanmaz.

Bir `Oturmuş` durumundan doğrudan `Ölüm`e geçiş bu kuralı çiğner ve ölümü
"kötü şans" gibi gösterir.

**Gereken:** `Oturmuş` ile `Ölüm` arasına kademeli bir **vazgeçiş** ekseni:
nefes derinliği ve sıklığı, başın düşme açısı, bakış kaldırma olasılığı,
uzatılan yiyeceğe tepki — hepsi çöküş gününe göre azalarak. Oyuncu farkı
**günden güne** görebilmeli.

## Kodumuzla çapraz kontrol — bir sonuç uyarısı

Belgenin mesafeleri (yüksek 1,5–2,5 m · orta 3,5–5,5 m · düşük 7–10 m) ile
`betik/veri/ayarlar.gd`'deki algı yarıçapı tutarlı: `GORUS_MESAFESI_M = 12`,
yani düşük güvende bile arkadaş gündüz oyuncuyu görür ve jestler kaydedilir.

**Ama gece başka:** `GECE_GORUS_CARPANI = 0.45` → gece görüş 5,4 m. Düşük
güvendeki arkadaş 7–10 m'de duruyor, yani **gece yapılan hiçbir jest ona
ulaşmaz**. Sonuç: güven en düşükken, onu en çok kazanmak istediğin anda,
gece jestleri hiç sayılmaz.

Bu ya kasıtlı ve güzel bir sertlik ("karanlıkta ona ulaşmak için yanına
gitmen gerekir") ya da kazara kurulmuş bir kapan. **Kullanıcı kararı gerekiyor.**
Kasıtlı sayılırsa ateş ışığı bir istisna olmalı: ateşin aydınlattığı yarıçap
içinde algı gündüz gibi çalışsın.

## Kabul testi: HAFİF SÜRÜM (kullanıcı kararı, K-058)

Spektin önerdiği "dokuz birleşim × beş izleyici" = 45 izleme; tek kişilik
üretimde bu test hiç yapılmaz, yani kural kâğıtta kalır. Karar:

- **Geliştirme boyunca:** moral YÜKSEK sabitlenir, yalnızca üç güven seviyesi
  kaydedilir, **üç izleyici**. Üçten ikisi doğru bilmeli.
- **Yayından önce bir kez:** dokuz hücrenin tamamı, beş izleyici, dörtte dört
  ölçütü — spektin özgün hâli.

İlkeden vazgeçilmiyor, sıklığı gerçekçi hale getiriliyor.

## (özgün itiraz, kayıt için)

"Dokuz birleşimin her biri için beş izleyici" = 45 izleme. Tek kişilik
üretimde bu test hiç yapılmaz, yani kural kâğıtta kalır.

**Öneri:** geliştirme boyunca hafif sürüm — moral yüksek tutulup üç güven
seviyesi, üç izleyici. Dokuz hücrelik tam tur yalnızca yayından önce bir kez.
İlkeyi koruyan ama gerçekten uygulanabilir olan budur.

---

# İkinci tur incelemesi (Claude, 2026-09-24)

**İki eksik de kapandı.** §8 ihtiyaç bakışını üçüncü kanal olarak kuruyor;
§9 `Oturmuş` ile `Ölüm` arasına iki günlük görünür vazgeçiş koyuyor.

## Özellikle iyi iki ayrıntı

**"Nesneye bakar, oyuncunun yüzüne değil."** Bu tek cümle bir çatışmayı
çözüyor: düşük güvenli arkadaş göz temasından kaçınmayı sürdürürken yiyeceğe
bakabiliyor. Güven kanalı ile ihtiyaç kanalı birbirine karışmıyor.

**"Tehdit Ölüm geçişini açmaz."** Değişmez kuralı doğrudan animasyon
katmanına yazmış. Kural yalnızca simülasyonda değil, gövdede de korunuyor.

## Kodla çapraz kontrol: bir boşluk bulundu ve kapatıldı (K-060)

Spekt ihtiyaç bakışını **55**'te açıyordu; `ayarlar.gd`'de fırsat **0.50**'de
doğuyor (`ESIK_HISSEDILIR`). Yani `[0.50, 0.55)` aralığında **fırsat var ama
ekranda hiçbir işaret yok** — simülasyon güveni değiştirir, oyuncu sebebini
göremez. Acil eşik (80 ↔ `ESIK_AGIR = 0.80`) birebir tutuyordu.

Düzeltme: bakış eşikleri artık bağımsız sayı değil, fırsat eşiğinin **türevi**
(`BAKIS_ESIGI_ORTA := ESIK_HISSEDILIR`). İki sayı ayrı yazılırsa er geç kayar;
türev olunca kayamaz. `testler/algi.gd` bakış eşiğinin fırsat eşiğini
geçemeyeceğini denetliyor. Histerezis (45/70) spektten olduğu gibi alındı.

## Uygulamada dikkat: geri dönüş şartı koda henüz uymuyor

§9 toparlanmayı **yiyecek VE su VE geceyi yanında geçirme** şartına bağlıyor.
Koddaki `Guven.gun_dondu()` ise ihmali yalnızca `bakim_gordu_bugun` ile
geriletiyor ve onu herhangi bir bedelli jest tetikliyor — yani spektten daha
gevşek. Gövde bağlanırken ihmal geriletmesi §9'un üç şartına çekilmeli.
Bu bir çelişki değil, henüz yazılmamış bir bağ; kayıt olarak duruyor.
