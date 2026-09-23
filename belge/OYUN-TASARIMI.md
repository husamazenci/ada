# Ada — Oyun Tasarımı

> Tasarımın **tek kaynağı**. Mimari karar vermeden önce okunur.
> Tasarım kararlarını kullanıcı verir. Ajanlar risk görür, seçenek üretir,
> ölçer ve uygular. "Ada" çalışma adıdır.
>
> Açık kararların seçenekleri ve riskleri: [`ILK-DEGERLENDIRME.md`](ILK-DEGERLENDIRME.md)

---

## 1. Tek cümle

**Issız bir adada hayatta kal — ve yanındakini kaybetme.**

Tarayıcıda çalışan, birinci şahıs, 3B, tek oyunculu hayatta kalma oyunu.
Uçak düştü, sen kurtuldun, bir kişi daha kurtuldu. Oyunun bütün ağırlığı o
ikinci kişide. Elle kayıt yok, kalıcı ölüm.

Bu ikinci denemedir. Birinci denemeden çıkarılan dersler bu belgeye ve
`AGENTS.md`'ye işlendi; onlardan sapılmaz.

## 2. Oyunun kalbi: arkadaş

Hayatta kalma sistemleri arkadaşı ortaya çıkaran **basınçtır**, kendi başına
amaç değildir. Bir tasarım kararı ikisinden birini seçmeyi gerektiriyorsa
**arkadaş kazanır**.

### Tasarım pusulası

Oyuncu arkadaşa karşı tutumunu **tamamen kendi** belirleyebilmeli; arkadaş da
**kendi kararlarını** verebilmeli — gerektiğinde bencil, gerektiğinde
yardımsever. Bir karar bu iki özgürlükten birini kısıtlıyorsa yanlış karardır.

## 3. Uzunluk, ana kavis ve son

**Karar (2026-09-17, K-005):** Oyun yaklaşık **4 saat**. Son **tek kişilik
sal**. **Fırtına** sonun kendisi değil; salın birkaç gün önce gelen büyük sınav.

### Zaman: melez *(karar, K-052)*

Takvim akar, hikâye önkoşulla ilerler. Bir sahnenin tetiği "8. gün" değil,
**önkoşul + en erken gün**: önkoşul bir önceki sahnenin kalıcı izidir.
Koşullar sağlanınca sahne ÇAĞIRIR — arkadaş oraya gider ve bekler, iş yarım
durur; ekranda ok, işaret, yazı yoktur (K-041). Oyuncu bir gün içinde
gelmezse sahne **sensiz** olur: izi yine dünyada kalır, zincir ilerler.
**Oyunun sonu takvimden değil hikâyeden gelir** (kapanış sahnesinin izi);
takvimde yalnızca güvenlik tavanı vardır (20. gün).

Gün/gece ve hayatta kalma zamana bağlı kalır: açlık, ateş, köpek, fırtına.
Aşağıdaki gün numaraları artık bir takvim değil, **hedef tempodur**.

### Takvim *(hedef tempo — K-052 ile kapı olmaktan çıktı)*

Gün ≈ 20 dk (gündüz ~13, alacakaranlık ~2, gece ~5) × 12 oyun günü ≈ 4 saat.

| Oyun günü | Ne olur |
|---|---|
| 1–2 | Yalnızca doğa: deniz, hava, açlık |
| 3+ | Hayvanlar; arkadaşın kırılganlığı |
| 5+ | **Yazılmış sahneler yoğunlaşır:** köpek, yara, kıtlık (bkz. `HIKAYE-OMURGASI.md`) |
| ~8. gece | **Fırtına.** Barınak; arkadaşın kendi kararıyla seni barınağa çekip çekmemesi — güveni sözsüz ölçebileceğin an |
| ~10 | Fırtınanın kıyıya attığı **tek kişilik can salı** |
| ~12 | Sal biriyle birlikte gider ya da gelgit onu alır; oyun o günün batımında biter |

Fırtına salı getiren olaydır: sebep–sonuç hiçbir şey anlatmadan kurulur.

### Son: tek kişilik

Uçaktan kopmuş küçük bir şişme can salı kıyıya vurur. Bir yetişkini taşır;
iki kişi binince su alır ve battığı gözle görülür — oyuncu bunu deneyerek
öğrenir, hiçbir yazı söylemez. Salı kim alır? Oyuncu alıp gidebilir; salı
arkadaşına verebilir — oyunun en büyük bedelli jesti. Arkadaş da kendi kararını
verir: salı sana doğru iter, kalmayı seçer ya da bir gece salla birlikte
kaybolur. Sal kıyıdan açılınca kamera kıyıda kalanla kalır. Kurtuluş
gösterilmez. Salı verince oyun hemen bitmez; kalan gün oynanır.

- **Arkadaş öldüyse:** Sal yine gelir. Soru "kim gider"den "gidebilir
  miyim"e döner: gitmek ya da onun yattığı yerin yanında kalmak.
- **Arkadaş çekildiyse:** Salı senden önce o bulabilir; kıyıda salı yerinde
  bulmamak bir sondur. Ya da onu bulup geri kazanmak için salla yarışırsın.

### Yazılmış sahneler ve kontrol *(karar, K-050)*

Omurga yazılıdır, eti ilişkiden gelir (K-049, Model 2). Gün gün taslak
`docs/HIKAYE-OMURGASI.md`'de; aşağıdakiler karardır.

- **Tam cutscene sayısı: 3** (şimdilik — kullanıcı: "daha çok olmalı ama
  şimdilik 3 diyelim, sonra ekleriz"):
  1. **Uyanış** (1. gün, kumsal) — 30–40 sn.
  2. **Fırtına** (8. gece) — **yalnızca uyanma anı**, 15–20 sn: çatı
     gıcırdıyor, ateş sönüyor, dışarıda rüzgâr. **Sonra kontrol oyuncuya
     bırakılır.** Sebep: arkadaşın o gecedeki varyantı (kolundan çeker /
     bekler / tek gider) oyunun en okunur davranış anıdır; kontrol alınırsa
     o bir sahne seçimine dönüşür, oyuncunun okuduğu bir karara değil.
  3. **Kapanış** (12. gün) — **seçimden sonra**. Seçimin kendisi oyuncuda
     kalır; kamera ancak karar verildikten sonra kıyıda kalanla kalır.
- **İlk ateş 2. gün.** İlk gece ateşsiz geçer: karanlıkta, üşüyerek, yan yana
  ya da ayrı. "İlk geceyi yalnız mı geçirdin" arkadaşın hafızasına yazılır.
  Sebep: oyunun ilk bedeli olan anı burada doğar; ateş hediye edilirse
  doğmaz.
- **9. günün çöküşü her oyunda olur, şiddeti değişir.** Ne kadar ağır
  geçeceği fırtına gecesindeki davranışa bağlıdır. Sebep: omurga yazılı
  kalır ama sonuç oyuncunun hikâyesi olur — "kötü şans" değil (K-049).
- **Açık:** 11. günün (sessiz gün) boş kalıp kalmayacağı **henüz karar
  değil** — kullanıcı sonra konuşulacak dedi.

## 4. Arkadaşın davranış tablosu

Oyuncunun gördüğü **tek şey** bu. Hiçbir sayı gösterilmediği için bu tablo
aynı zamanda oyunun **kabul kriteridir**: bir davranış ekranda ayırt
edilemiyorsa o seviye yok demektir.

```
GÜVEN
  Yüksek  Yakında yürür · sen bakınca göz teması kurar · sen söylemeden
          iş yapar · yiyeceğini paylaşır · tehlikeye seninle girer
  Orta    Mesafe açar · çağırınca gecikmeli gelir · kendi işini yapmayı
          tercih eder
  Düşük   Uzakta durur · göz teması kurmaz · çağırınca gelmez · takip
          etmeyi bırakır · sonunda adanın başka bir yerine çekilir

MORAL
  Yüksek  Normal tempo · çevreye tepki verir
  Orta    Yavaşlar · sık sık durup bekler
  Düşük   Oturur ve kalkmak istemez · tehlikeyi umursamaz · seni uyarmaz ·
          BU DURUMDA ÖLEBİLİR
```

### Güven ve moral: iki ayrı eksen *(karar, K-005)*

**Güveni sen düşürürsün; morali koşullar düşürür.** Yüksek güvenli ama morali
dibe vurmuş bir arkadaş mümkündür ve en acı durum odur.

İki eksen ekranda **farklı kanallardan** okunur. Güven **yönelimi ve
mesafeyi** (kime doğru, ne kadar yakın), moral **tempoyu ve duruşu** (ne hızla,
hangi bedenle) belirler. Aksi halde "çağırınca gecikmeli gelir" (orta güven)
ile "yavaşlar" (orta moral) ekranda aynı görünür. Ölçülebilir karşılıkları ve
güven × moral bileşimi: `ILK-DEGERLENDIRME.md` §A.4.

### Güveni kazanma yolları *(karar: birden çok yol; liste öneri)*

İlke değişmez kuraldır: **o an senin ihtiyacın olan bir şeyden vazgeçmek.**
Her yolun bir "ucuz ikizi" vardır ve o güveni yükseltmez. Arkadaş bedeli
yalnızca **gördüğünden** değerlendirir (algı dürüstlüğü): o bakmıyorken
yaptığın fedakârlığı bilmez, o bakmıyorken yediğini de bilmez.

| Yol | Senin bedelin | Ucuz ikizi (yükseltmez) | Nerede |
|---|---|---|---|
| Açken yiyeceğini vermek | Açlık | Tokken ya da bolken vermek | Dilim |
| Onu tehlikeden çıkarmak | Güvenliğin: ışığın dışına çıkmak, yaralanma | Tehlike yokken yanına gitmek | Dilim |
| Riskli işi onun yerine üstlenmek | Güvenliğin: o karanlığa yakıt toplamaya giderken senin gitmen | Aydınlıkta, tehlikesiz iş | Dilim |
| Sözü bir geceyi geçirerek tutmak | "Bekle" işaretiyle ayrılıp karanlık basmadan dönmek; yolun riski | Hemen dönmek | Tam oyun |
| Yaralıyken ona bakmak | Kendi yiyeceğin, zamanın | Yaralı değilken ilgi | Tam oyun |
| Fırtınada barınağın korunaklı yerini ona bırakmak | Islaklık, soğuk | Fırtına yokken | Tam oyun |
| Salı ona vermek | Adadan çıkış | — | Son |

### Gidiş, kavga ve ölüm anları *(karar, K-026)*

Hiçbiri yazıyla, müzikle ya da kamera hareketiyle işaretlenmez; oyuncu ne
olduğunu gördüğünden kurar.

- **Gidiş ihtiyaca bağlıdır.** Güven dibe vurduğunda:
  - *Arkadaş açsa* yiyeceği zorla alır ve gider — gece de olabilir, karanlık
    onun riskidir. Araya girersen seni iter: yere düşersin, kısa bir an
    bedenine hâkim olamazsın, yaralanmazsın. Ara sahne yok, kontrol sende;
    araya girmeyip almasına izin vermek de bir seçimdir.
  - *Toksa* şafağı bekler ve sessizce gider; çıkışta bir kez dönüp bakar.
    Yiyeceğe dokunmaz.
  - Oyuncu hangisinin geleceğini bilemez; ihtiyaç davranışı belirler.
- **Moral dibe vurursa:** gece boyunca oturur ve kalkmaz — uyarı budur. O gece
  bitmeden, sen bakmıyorken, açıklığın kenarındaki kuru ağaçta kendini asar;
  şafakta bulunur. Ölüm kalıcıdır. Oyun menüde içerik uyarısı gösterir.
  Tehlikeyi umursamayıp köpeğe yem olması ayrı bir yol olarak kalır.
- **Arkadaş ölürse:** bedeni düştüğü yerde kalır, kalıcıdır. Oyun sürer.
  Karanlıkta öldüyse onu sonradan bulursun.
- **Oyuncu ölürse:** kamera yere iner, bakış toprak hizasında kalır. Dünya
  ~10 s daha akar: ateş yanar, köpek çekilir, arkadaş güvenine göre davranır.
  Son görülen şey ilişkinin son hâlidir. Sonra yavaş karartma, sessizlik,
  menü. Yuva silinir (K-006).
- **Dilimin sonu (şafak):** son 60 s'de ışık doğar, köpek çekilir; oyuncu
  hâlâ oynar. Son kareyi ilişkinin hâli belirler — yanında mı, karşıda mı,
  gitmiş mi, yatıyor mu. Sonra yavaş karartma ve menü.
- **Yaralanma görünür:** yaralı olan yavaş yürür, arkadaş aksar. Ölümden
  önceki uyarı ekranda olmalı; yalnızca sayıda olan uyarı uyarı değildir.

### Gidiş ve geri kazanma *(tam oyun — öneri)*

Kullanıcı: "En gerçekçi, insan hissettiren davranışlar olmalı." Dil modeli
kullanılmaz; utility AI ile yapılır (kullanıcı teyit etti, K-010). Öneri:

- **Günler önceden işaretler:** mesafe büyür, ateşin karşı tarafında uyur,
  yalnız yer.
- **Gidiş anı:** dilim için karar verildi (K-026, yukarıda): açsa zorla alır,
  toksa şafağı bekler ve bir kez dönüp bakar.
- **Nereye:** hafızasında en güvenli bulduğu yere — onu tanıyan oyuncu bulabilir.
- **Çekildikten sonra:** kampa uzaktan yaklaşır, izler, görülünce çekilir.
  İzleri 6+. gün izleriyle aynı dili kullanır (K-007).
- **Geri kazanma:** bulununca kaçmaz ama yaklaşmana izin vermez. Uzaktan
  bedelli jestler (yiyeceği bırakıp uzaklaşmak) mesafeyi aşama aşama kapatır.
  Döndükten sonra güvenin çıkabileceği tavan kalıcı olarak düşüktür.
- **İnsan hissinin kaynağı:** hafıza (belirli olayları hatırlar), tereddüt
  (karar anında duraklar, geri döner), tutarsızlık (kişilik + küçük
  rastgelelik), bağlam (gece karanlığa yürümez). Hiçbiri LLM gerektirmez.

## 5. Arkadaş konuşuyor mu?

**Karar (K-005):** Kelimesiz ama sesli — nefes, iç çekme, uyarı, acı, korku,
rahatlama. **Çok nadir** sahnelenmiş anlarda 1–2 kelime. Dilimde kelime yok,
ses var.

Sahnelenmiş anların kuralları *(öneri — değişmez kurallarla uyum için)*:
- Kelime asla bir isim, geçmiş, yer ya da güven düzeyi söylemez ("sana
  güveniyorum" yok).
- Oyuncunun kontrolü alınmaz; sahne oyuncunun ne yapacağını belirlemez.
  Yalnızca arkadaş konuşur.
- Bütün oyunda en fazla 3–5 an (ör. fırtına gecesi, sal, geri kazanıldığı an).
- Hangi anın geleceği ve hangi kelimenin söyleneceği ilişkinin durumuna
  bağlıdır; hiçbiri garanti değildir.

**Ekrandaki satırlar (karar, K-050):** Nadiren beliren satırlar **duyum ve
durum cümleleridir** — "üşüyorsun", "o hâlâ orada". Oyuncunun iç sesi DEĞİL:
"onu bırakamam" gibi bir satır oyuncuya ne hissettiğini söyler ve tutumunu
kendi belirleme özgürlüğünü (tasarım pusulası) kısar. Ölçüt K-041'dekiyle
aynı: satır ne yapacağını değil ne YAŞADIĞINI söylüyorsa doğrudur.

**Dil (karar, K-010):** Kelimeler oyuncunun seçtiği oyun dilindedir — şimdilik
Türkçe ve İngilizce. Kelimenin dili arkadaşın değil oyuncunun seçimidir (çeviri
geleneği); bu yüzden dil bir kimlik ipucu sayılmaz.

## 6. Değişmez kurallar

Kullanıcıya sorulmadan değiştirilmez.

<!-- DEGISMEZ-KURALLAR:BASLA — AGENTS.md §2 ile belge/OYUN-TASARIMI.md §6 birebir aynı tutulur -->
- Arkadaş LLM ile yapılmaz. İhtiyaç tabanlı utility AI.
- **İlişki barı yok.** Hiçbir sayı, çubuk, yüzde gösterilmez. Güven yalnızca
  davranıştan okunur.
- **Güven hızlı düşer, yavaş yükselir.** Yalnızca **bedeli olan**
  davranışlarla yükselir: sen açken yiyeceğini ya da suyunu vermek, verdiğin
  sözü tutmak, onu tehlikeden çıkarmak. İlke şudur: o an **senin ihtiyacın
  olan** bir şeyden vazgeçmek. Liste kapalı değil, ilke kapalı. Ucuz jestler
  (yanında durmak, tokken vermek) tek başına yükseltmez. Düşüş yükselişin
  üç katı hızlıdır ve her düşüş, **onun ihtiyacı olan** bir şeyi almak ya da
  vermemektir (K-055).
- **Arkadaş yalnızca gördüğünü değerlendirir.** O bakmıyorken yaptığın
  fedakârlığı bilmez, o bakmıyorken yediğini de bilmez. **Yokluk da algıdır:**
  yanında olmadığını fark eder (K-055).
- **Arkadaş gerçek bir insan gibi hissettirmelidir** (kullanıcı kararı, K-056).
  Bu bir üslup tercihi değil, kabul kriteridir. Kaynağı: kendi gündemi olması
  (sen olmasan da bir şey yapar), gecikme ve tereddüt, eksik dikkat, seçici
  hafıza, tutarsızlık, beceriksizlik, bedensel süreklilik ve bakış. **Kişilik
  geçmişten değil ALIŞKANLIKTAN gelir** — hep ateşin aynı tarafına oturması,
  yakıtı atmadan önce yoklaması gibi. İllüzyonu kıran davranışların listesi
  kapalıdır ve denetlenir (`OYUN-TASARIMI.md` §4).
- **Arkadaş kalıcı olarak ölebilir** ve **küsüp gidebilir**. Gidiş **5. günden
  önce olmaz** (K-055): güven dibe vursa bile o güne kadar uzaklaşır,
  konuşmaz, ateşin karşı tarafında uyur — ama oradadır. Gidince geri
  kazanılmaz; gidişi salın yanında ikinci bir sondur.
- **Arkadaş tehditten ÖLMEZ, senin yüzünden ölür** (K-049, K-055). Hayvan ve
  doğa onu yaralar, yıpratır, korkutur — öldürmez. Koşullar (açlık, susuzluk,
  soğuk, yara) moralini **orta**ya kadar indirebilir, dibe indiremez; dibe
  ancak **senin ihmalin** indirir. Ölüm ani değildir: çöküş 4. günden itibaren
  görünür, en erken 6. günün şafağında gelir, iki tam gün müdahale penceresi
  vardır. Sebep: "kötü şans" ölümü oyuncunun hikâyesi olmaz.
- **Arkadaşın geçmişi öğrenilmez, kendisi öğrenilir** (K-049). Adı, nereden
  geldiği, kim olduğu hiç söylenmez — o kendini anlatmaz. Ama NE olduğu
  davranışından okunur. **Çelişen ipucu YOK; hiç ipucu yok.** Bağlanma
  bilgiden değil, birlikte yaşanandan doğar.
- Adada daha önce bir insanın bulunduğunu **kesinleştiren** hiçbir iz yoktur.
- **Oyun ÖĞRETMEZ, anlatır** (K-041). Öğretici yok, görev listesi yok,
  işaret/ok/HUD yok. Yönlendirme dünyadan gelir: arkadaş yapar ve bakar, yarım
  iş yarım durur. Ama oyun bir HİKÂYE anlatır: kontrolün alındığı sayılı ve
  kısa sahneler ve nadiren beliren kısa satırlar olabilir. Ölçüt: o satır
  oyuncuya ne yapacağını değil, ne YAŞADIĞINI söylüyorsa doğrudur.
- Fantastik yaratık yok, kötü adam yok. Tehdit hayvan ve doğa. Arkadaş kötü
  adam değildir; ama çaresizlikte sana karşı güç kullanabilir (itmek, yiyeceği
  zorla almak). Bu bir tehdit türü değil, ilişkinin sonucudur. (K-026)
- Multiplayer yok. **Elle kayıt ve yükleme yok.** Tek yuvalı askıya alma: oyun
  sürerken tek yuvaya sürekli yazılır; ölüm kesinleştiği an yuva silinir. (K-006)
<!-- DEGISMEZ-KURALLAR:BITIR -->

<!-- GORSEL-YON:BASLA -->
**Görsel yön:** Doğal, kasvetli ve **tutarlı stilize** (kullanıcı kararı, K-053).
Gerçekçilik kovalanmaz; gerilim ve atmosfer **ışıktan, karanlıktan, sesten,
bedenin zamanlamasından ve gösterilmeyenden** kurulur — doku çözünürlüğünden
değil. Stil birliği tek tek varlıkların kalitesinden önemlidir: farklı ellerden
çıkmış ama aynı dilde konuşan bir dünya, tutarsız bir gerçekçilikten iyidir.
Oranlar gerçek kalır (sık orman içindeki ağaç 15–25 m, taç/boy 0.25–0.35; açıklık
kenarında taç/boy 0.5–0.8; genç ağaç 3–12 m). (K-035, K-053)

**Bütçe görselden önce gelir (K-047):** Görsel hedef ile performans bütçesi
çakışırsa **bütçe kazanır**. Hedef makine fansızdır (K-001). Stilize hedefi
**HEDEFTİR**; 60 fps bir **SINIRDIR**.
<!-- GORSEL-YON:BITIR -->
> Bu blok `AGENTS.md` §2 ile **birebir aynıdır**. Birini değiştiren
> ikisini birden değiştirir; `testler/degismez-esitlik.sh` denetler.


## 7. Dünya

- Ada **elle tasarlanır**, prosedürel üretilmez. Tek ada, her tepesi kasıtlı.
  Birinci denemede tohumdan üretim (gölet oyma, iz oyma, nirengi yerleştirme)
  bütün bir hata ailesi doğurdu; karşılığında kalıcı ölümlü, anlatı ağırlıklı
  bir oyunun ihtiyaç duymadığı tekrar oynanabilirliği verdi.
- Ada ölçeği: **en az 300 m çap.** Birinci denemede 120 m'ydi ve "ormanın
  içinde olmak" hiç gerçekleşmedi (orman denizden en fazla 21 m içerideydi).

### Tehditler *(karar: yaralar ve öldürür; ayrıntılar öneri)*

| Tehdit | Ne zaman, nerede | Arkadaşla etkileşim sebebi |
|---|---|---|
| **Yaban köpeği** | Gece; ateş ışığının dışında dolaşır | Ateşi birlikte beslemek; onu tehlikeden çıkarmak. **Dilimdeki tehdit.** |
| **Yaban domuzu** | Gündüz, orman; ansızın karşılaşınca saldırır | Birlikte yürürken uyarması; "tehlikeye seninle girer" |
| **Deniz** | Akıntı, dalga, kayalık kıyı; sal | Suda onu kurtarmak; salın riski |
| **Hava** | Soğuk ve ıslak geceler; ~8. gece fırtına | Barınak; seni barınağa çekmesi |

**Yaralanma — az ve keskin:** iki durum, *sağlam* ve *yaralı* (yavaş yürür,
koşamaz, zamanla iyileşir). Yaralıyken ikinci ciddi saldırı öldürebilir. Bunun
iki sebebi var: (1) ölümden önce her zaman bir uyarı (ilk yara) olur — 4 saatlik
kalıcı ölümlü bir oyunda ölüm haksız gelmemeli; (2) yaralı olan diğerine
muhtaçtır — ihtiyaç arkadaşla etkileşim doğurur, bu yüzden var.

Hayvanlar 3. günden sonra görünür (takvim, §3): değişmez kural tehdidi "hayvan
ve doğa" diye ikiye ayırıyor; 1–2. gün yalnızca doğa.

## 8. İlk hedef: dikey dilim

Ada yok, ağaç yok, envanter yok, craft yok. **Tek bir açıklık, bir ateş, bir
gece, bir tehdit, bir arkadaş — ve tek bir yiyecek.**

Bu dilim çalışmadan ada, ağaç, craft, hava, barınak **yok**. Birinci denemede
tam tersi yapıldı ve oyunun kalbi en sona kaldı.

### Dilimdeki en küçük mekanik küme

Bundan azı güveni yükseltemez.

- **Açlık:** oyuncuda ve arkadaşta ayrı ayrı. Tek sayaç, ekranda gösterilmez.
- **Tek yiyecek türü**, sayılı miktarda. İki eylem: **YE** ve **VER**.
- **Ateş:** yakıt ister, söner, gece tehdidini uzak tutar. Yakıt açıklığın
  kenarındaki sayılı dal yığınlarından; toplamak ışığın kenarına gitmek demek.
- **Gece tehdidi:** tek bir **yaban köpeği**; ateşin ışık yarıçapının dışında
  kalır. İlk saldırı yaralar, yaralıyken ikincisi öldürebilir.
- **Çağırma:** arkadaşı yanına çağırma eylemi.
- **Koşma** *(K-030)*: Shift basılıyken. Yaralıyken ve çok açken koşulamaz.
  Köpekten hızlı değildir: ondan koşarak kaçılmaz, ateşe ya da arkadaşın
  yanına sığınılır. Koşan oyuncunun arkasında arkadaş geride kalır — ondan
  uzaklaşan oyuncudur.
- **Ses** *(K-005)*: tehdidin yaklaşması (dal kırılması, hırıltı); arkadaşın
  nefesi, uyarı ve acı sesleri. Kelime yok.
- **Açlık bedende okunur** *(K-005)*: oyuncu acıktıkça yavaşlar; çok açken
  sersemler (afallama efekti). Arkadaşın açlığı da bedeninden okunur.

**Dilimde güveni yükseltmenin üç yolu var, üçü de bedelli** (§4): açken
yiyeceğini vermek · onu tehlikeden çıkarmak · riskli işi onun yerine
üstlenmek. Yiyecek hâlâ merkezde: oyunun tezi o jestte. Sen tokken vermek ucuz
jesttir, güveni yükseltmez.

*(Not: önyükleme belgesinde dilimdeki tek yol yiyecekti ve bu kasıtlıydı.
Kullanıcı 2026-09-17'de "birkaç yol" istedi; teknik lider bunu dilime de
uyguladı, çünkü öteki iki yol dilimde zaten var olan mekaniklerle (tehdit,
yakıt) kuruluyor. Dilimde tek yol kalsın denirse geri alınır.)*

### Bitti sayılması için

- Arkadaş yanında. Ne yaptığını yalnızca davranışından anlıyorsun; hiçbir
  sayı, çubuk ya da yazı yok. (Dilimde konuşmuyor — genel karar açık.)
- Güven hem düşüyor hem yükseliyor; yükselmesi yalnızca bedeli olan
  davranışla oluyor ve tek gecede gözle fark edilecek kadar oluyor.
- Davranış tablosundaki **üç güven seviyesi** de ekranda ayırt edilebiliyor.
- Çok düşerse arkadaş çekip gidiyor; gidiş kalıcı.
- Moral düşerse arkadaş ölebiliyor; ölüm kalıcı.
- Gece tehdidi var ve ateş onu uzak tutuyor. Tehdit yaralıyor ve öldürebiliyor;
  ölümden önce her zaman bir uyarı var.
- Açılış testi ve performans bütçesi geçiyor.

## 9. Yol haritası (dilimden sonra; sıra önemli)

1. **Oyunun sonu.** Karar verildi: tek kişilik sal, öncesinde fırtına (§3).
   Ayrıntı tasarımı sistemlerden önce yapılır; final her sistemin neyi ifade
   edebilmesi gerektiğini belirler.
2. **Ada:** elle tasarlanmış, nirengi noktalarıyla.
3. **Hayatta kalma ihtiyaçları — az ve keskin.** Her ihtiyaç arkadaşla
   etkileşim için bir sebep olmalı; olmuyorsa eklenmez. (Birinci denemede
   açlık, susuzluk, dayanıklılık, nefes, yara, enfeksiyon, sıcaklık vardı;
   ilişki oyunu için fazla kalabalık.)
4. **Tehdit takvimi:** 1–2. gün yalnızca doğa · 3. günden sonra arkadaşın
   kırılganlığı · 6. günden sonra adada kaynağı belirsiz bir şeyin izleri
   (bkz. §6, iz kuralı).
5. **Ses ve atmosfer.**
6. **Hava:** fırtına ve yağmur — arkadaşın kendi kararıyla seni barınağa
   çekmesi; güveni sözsüz ölçebileceğin an. Fırtına artık ana kavsin parçası
   (~8. gece, salı getiren olay); sıra değişmedi ama önemi arttı.

## 10. Kararlar ve açık sorular

| # | Konu | Durum | Nerede |
|---|---|---|---|
| 1 | Oyunun sonu | **karar:** tek kişilik sal; fırtına ondan birkaç gün önce | §3, K-005 |
| 2 | Oyun uzunluğu | **karar:** ~4 saat · takvim sayıları öneri | §3, K-005 |
| 3 | Kayıt | **karar:** tek yuvalı askıya alma; ölünce biter (değişmez kural değişti) | §6, K-006 |
| 4 | Arkadaş konuşuyor mu | **karar:** kelimesiz ama sesli; nadir anlarda 1–2 kelime | §5, K-005 |
| 5 | Güven / moral ayrı eksen | **karar:** evet, ayrı kanallar | §4, K-005 |
| 6 | Gidiş ve geri kazanma | **karar (dilim):** açsa zorla alıp gider, toksa şafakta sessiz · geri kazanma öneri; dil modeli yok | §4, K-010, K-026 |
| 7 | Güveni kazanma yolları | **karar:** birden çok yol; liste öneri | §4, K-005 |
| 8 | Dilimde ses | **karar:** evet | §8, K-005 |
| 9 | Çok açken ekran etkisi | **karar:** sersemleme (afallama) | §8, K-005 |
| 10 | Tehditler | **karar:** yaralar ve öldürür; köpek, domuz, deniz, hava | §7, K-005 |
| 11 | Arkadaşın izleri | **karar:** 6+. gün izleriyle aynı dil — gerilim en yüksek | §6, K-007 |
| 12 | Oyun dili ve kelimelerin dili | **karar:** oyuncunun seçtiği dil — Türkçe, İngilizce | §5, K-010 |
| 13 | Arkadaşın güç kullanması | **karar:** değişmez kural genişledi — iter, zorla alır; kötü adam değil | §6, K-026 |
| 14 | Ölüm anları ve dilimin sonu | **karar:** oyuncu yere düşer, dünya ~10 s sürer · arkadaşın bedeni kalır · şafakta ışık doğar, karartma | §4, K-026 |
| 15 | Moral ölümü | **karar:** şafakta kuru ağaçta asılı bulunur · menüde içerik uyarısı | §4, K-026 |
| 16 | Koşma | **karar:** Shift; yaralı ve çok açken yok; köpekten yavaş | §8, K-030 |


## Kumsal ve enkaz · birlikte geliştirilen bölüm (2026-09-20)

- Oyuncu kumsalda kendine gelir, enkazı dışarıdan keşfeder. Açılış cutscene'i
  henüz karar değildir; sahne fikirleri prototipten önce ayrıca konuşulur.
- Kumsal sakin, hafif esintili ve canlı; gizem/korku sessizlik ve ıssızlıktan
  doğar. Hayatta kalma, gerilim ve hikâye birlikte taşınır.
- Büyük enkazın bir kısmı su içinde, bir kısmı kumsalda kalır. İleride içinde
  birkaç sahne ve gerekli malzemeler için geri dönme ihtiyacı düşünülüyor.
  Malzemeler, giriş yöntemi ve sahnelerin akışı henüz seçilmedi.
- İlk yerleşim denemesi: 24 m gövde, 4.2 m çap; yaklaşık 33 m ötede kuru
  kumdan ilk bakış. Bunlar nihai onay değil, birlikte incelenecek ölçüler.
- Çalışma biçimi: küçük bölüm → somut görüntü/oynanış → kullanıcıyla tartışma
  → düzeltme. Uzun bağımsız çalışma izni, bütün oyunun tasarımını tamamlamak
  veya sonraki bölümlerin kararlarını kendiliğinden vermek anlamına gelmez.
