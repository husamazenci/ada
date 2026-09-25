# AGENTS.md — Ada (üçüncü deneme)

> 2026-09-23 · Godot 4.7 zemininde yeniden kuruldu.
> İki AI ajanının ortak ve **kalıcı** kural kaynağıdır. `CLAUDE.md` buna
> sembolik bağdır; düzenleme yalnızca burada yapılır. Tasarım ayrıntısı
> `belge/OYUN-TASARIMI.md`'dedir. Zemin değişikliğinin gerekçesi
> `belge/UCUNCU-DENEME.md`'dedir.

---

## 1. Proje

**Ada**: birinci şahıs, 3B, tek oyunculu hayatta kalma oyunu. **Issız bir adada
hayatta kal — ve yanındakini kaybetme.** Uçak düştü, sen kurtuldun, bir kişi
daha kurtuldu. Oyunun bütün ağırlığı o ikinci kişide. Elle kayıt yok, kalıcı ölüm.

Bu **üçüncü** denemedir. Birinci ve ikinci deneme tarayıcıda, Three.js ile
yapıldı; ikisi de aynı yerde takıldı. Ölçüldü: 15.028 satırın yalnızca **748'i**
(%5) oyunun kalbiydi; gerisi motor yazmak ve yazdığı motoru ölçmekti. **Sapma.**

- **Oyunun kalbi arkadaş.** Hayatta kalma sistemleri arkadaşı ortaya çıkaran
  basınçtır, kendi başına amaç değildir. Bir karar ikisinden birini seçmeyi
  gerektiriyorsa **arkadaş kazanır**.
- **Tasarım pusulası:** Oyuncu arkadaşa karşı tutumunu tamamen kendi
  belirleyebilmeli; arkadaş da kendi kararlarını verebilmeli. Bir karar bu iki
  özgürlükten birini kısıtlıyorsa yanlış karardır.
- **Arkadaşın davranış tablosu** (`belge/OYUN-TASARIMI.md` §4) oyuncunun gördüğü
  tek şeydir ve oyunun **kabul kriteridir**: bir davranış ekranda ayırt
  edilemiyorsa o seviye yok demektir.

### Roller

- **Kullanıcı** tasarım kararlarını verir ve **oyunun hissini kendi ayarlar**.
- **Ajanlar** riskleri görür, seçenek üretir, ölçer ve uygular. Tasarım kararını
  kendi başına vermez; seçenek + öneri sunar.

---

## 2. Değişmez kurallar

Kullanıcıya sorulmadan değiştirilmez. Zemin değişti, bunlar değişmedi.

<!-- DEGISMEZ-KURALLAR:BASLA — AGENTS.md §2 ile belge/OYUN-TASARIMI.md §6 birebir aynı tutulur -->
- Arkadaş LLM ile yapılmaz. İhtiyaç tabanlı utility AI.
- **İlişki barı yok.** Hiçbir sayı, çubuk, yüzde gösterilmez. Güven yalnızca
  davranıştan okunur.
- **Güven hızlı düşer, yavaş yükselir.** Yalnızca **bedeli olan**
  davranışlarla yükselir: sen açken yiyeceğini ya da suyunu vermek, verdiğin
  sözü tutmak, onu tehlikeden çıkarmak. İlke şudur: o an **senin ihtiyacın
  olan** bir şeyden vazgeçmek. Liste kapalı değil, ilke kapalı. Ucuz jestler
  (yanında durmak, tokken vermek) tek başına yükseltmez. Düşüş yükselişin
  iki katı hızlıdır (K-057: üç kat, davranış tablosundaki ORTA güveni
  ulaşılamaz kılıyordu) ve her düşüş, **onun ihtiyacı olan** bir şeyi almak ya da
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
- **Oyun ÖĞRETMEZ, anlatır** (K-041, K-059 ile genişledi). Ekran üstü HUD yok,
  işaret yok, ok yok. Yönlendirme dünyadan gelir: arkadaş yapar ve bakar, yarım
  iş yarım durur. Ama oyun bir HİKÂYE anlatır: kontrolün alındığı sayılı ve
  kısa sahneler ve nadiren beliren kısa satırlar olabilir. Ölçüt: o satır
  oyuncuya ne yapacağını değil, ne YAŞADIĞINI söylüyorsa doğrudur.
- **Defter** (K-059, kullanıcı kararı). Enkazda bulunan BOŞ defter. Karakter
  onu kendi eliyle doldurur; üç şey yazar: **olan biten** (geçmiş zaman),
  **adanın çizimi**, ve **sayılı birkaç çekirdek iş**. Defter ekran üstü bir
  gösterge DEĞİLDİR: dünyada bir nesnedir, açmak oyuncunun seçimidir, yazma
  anlarında kontrol oyuncuda kalır (tam cutscene sayısı 3'te kilitli).
  **Değişmez sınır: defter ARKADAŞ hakkında hiçbir iş yazmaz.** İşler yalnızca
  dünyaya dairdir (ateş, su, barınak, sal). İlişkiye dair hiçbir yönlendirme
  vermez — o alan tamamen oyuncunundur. Bu sınır inşa değişmeziyle denetlenir.
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
> Bu blok `belge/OYUN-TASARIMI.md` §6 ile **birebir aynıdır**. Birini değiştiren
> ikisini birden değiştirir.

---

## 3. Öncelik: önce kalp, sonra kabuk

- **Çekirdek an önce.** Gri kutu, iki kapsül, açlık, YE/VER. Tez şudur:
  *sen açken yiyeceğini verdiğinde onun davranışı gözle görülür biçimde değişir.*
  Bu cümle gri kutuda çalışmıyorsa oyun yok demektir.
- **GRİ KUTU KAPISI (yeni, pazarlık dışı):** arkadaşın üç güven seviyesi gri
  kapsüllerle ayırt edilemiyorsa **hiçbir görsel iş başlamaz.** Bu bir öncelik
  tavsiyesi değil, bir kapıdır. İkinci denemede görsel iş kalbi yiyip bitirdi.
- Sıra: (1) çekirdek an · (2) gövde ve animasyon · (3) dikey dilim (gece, ateş,
  tehdit) · (4) görsel yön · (5) ada · (6) son (fırtına + tek kişilik sal).
- **Bir iş arkadaşa hizmet etmiyorsa yapma; kullanıcıya söyle.**

---

## 4. Teknik yığın ve hedef

- **Yığın:** **Godot 4.7 · GDScript.** C#/.NET yok — derleme adımı ajanların
  turunu yavaşlatır. Kod ve sahne okunabilir ve **diff'lenebilir** kalmalı.
- **Masaüstü uygulaması** (macOS). Tarayıcı şartı kaldırıldı (K-054): tek
  kişilik, kalıcı ölümlü bir oyuna hiçbir şey kazandırmıyordu.
- **`.uid` ve `.import` dosyaları COMMIT EDİLİR** — yoksayılmaz. Godot'nun
  resmî listesinde yoksayılacak yalnızca iki şey var: `.godot/` ve
  `*.translation`. Sebep iki ajanlı depoda kritik: `.uid` commit edilmezse
  her ajan aynı betik için farklı rastgele kimlik üretir ve sahnelerdeki
  `uid://` referansları birleşmede yanlış dosyayı gösterebilir. `.import`
  dosyaları da içe aktarma ayarını taşır; yoksa her makine sesi farklı
  ayarla içe aktarır.
- **`.tscn` ve `.tres` düz metindir ve LFS'e GİRMEZ.** Ajanların sahneyi
  okuyabilmesinin tek sebebi budur. İkili varlıklar (`.glb`, `.png`, `.wav`…)
  LFS'e girer; `.gitattributes` ilk varlıktan önce kuruldu.
- **Ada elle tasarlanır, prosedürel üretilmez.** Tek ada, her tepesi kasıtlı.
- **Ada ölçeği: en az 300 m çap.**
- **Hedef makine (K-001):** MacBook Air `Mac14,2`, Apple M2 (8 CPU / 8 GPU),
  16 GB, macOS 15.6.1. Fansız → termal kısma. Bütçe **bu makineye** göre geçerli.
- **Performans bütçesi bir testtir:** hedef makinede ortalama kare süresi
  ≤ 16.7 ms (60 fps) ve p95 ≤ 20 ms. Çizim çağrısı ve üçgen sınırları **Faz 1'de
  Godot sayaçlarıyla yeniden taban çizgisi alınarak** konur — ikinci denemenin
  sayıları (150 / 250k) Three.js dönemine aitti, taşınmaz.
- **Bütçe ölçümü tören değildir:** geliştirme derlemesinde kare süresi ve çizim
  sayacı **sürekli açık** bir HUD'da durur (`betik/cizim/damga-katmani.gd`).
  İkinci denemede ölçüm 3,5 dakika sürüyor ve şarj + sessiz makine istiyordu;
  sonuç: üç dal ölçülmeden birleşti.
- **HUD hüküm VERMEZ, hükmü `araclar/butce.gd` verir.** İki sebep ölçüldü
  (2026-09-24, M2 / Metal / Godot 4.7.2): (a) vsync açıkken duvar saati ekran
  yenilemesine kilitlenir ve her şey 16.7 ms çıkar — araç vsync'i KAPATIR;
  (b) `viewport_get_measured_render_time_gpu` bu makinede 960 kare boyunca
  **0.000** döndü, yani GPU yükü ölçülemiyor. HUD bu yüzden GPU yazmaz ve
  kırmızıya yalnızca TAKILMA (en kötü kare > 20 ms) ile döner.
- **Taban çizgisi (2026-09-24, gri kutu sahnesi, vsync kapalı, 1449 kare):**
  ortalama **6.90 ms** · p95 **6.94 ms** · en kötü 7.51 ms ·
  **17 çizim çağrısı** · **45 758 üçgen** · 119 nesne.
  Sahnede zemin kutusu, oyuncu kapsülü ve tek karakter (14 318 üçgen) var.
  Üçgen sayacı bütün geçişleri toplar — gölge geçişi karakteri ikinci kez
  sayar; bu yüzden 14k model 45k'ya çıkıyor.
  **Sayısal SINIR henüz konmadı ve kasıtlı:** ada, ağaç, ateş ve barınak
  girmemiş bir sahneden çıkarılan sınır anlamsız olur. Sınır dikey dilimin
  gerçek içeriği girdiğinde bu tabandan türetilir.
- **Oyun iki dilli: Türkçe ve İngilizce** (K-010). Ekranda görünen her metin
  Godot'nun CSV yerelleştirmesinden gelir; koda görünür metin yazılmaz. Bir test
  her anahtarın iki dilde de var olduğunu denetler.
- **Oyun durumu serileştirilebilir olmalı** — ilk günden (K-006).

---

## 5. Mühendislik disiplini

Pazarlık dışı. Her biri önceki iki denemede gerçekten yaşandı.

### 5.1 Çıkış kodları

**Bütün araç ve testlerde aynı:** `0` geçti · `1` başarısız · `2` ÇALIŞTIRILAMADI.
**"Atlandı" diye bir sonuç YOKTUR.** Birinci denemenin açılış testi playwright
bulamayınca "ATLANDI" yazıp 0 ile çıkıyordu (K-003). **Sıfır şey ölçen bir test
"geçti" demez, `2` ile çıkar** — katman kuralı testi bunu uyguluyor.

### 5.2 Katmanlar saf kalır

`betik/veri/` (saf veri + inşa değişmezleri) · `betik/sim/` (dünyanın kuralları)
· `betik/ai/` (arkadaşın algısı, güveni, morali, kararı) · `betik/cizim/` ve
`sahne/` (görsel düğüm yalnızca burada).

İlk üçü görsel düğüm içe aktaramaz; `testler/katman-kurallari.gd` denetler.
Sebep: arkadaşın davranışı pencere açmadan, saniyenin altında ve belirlenimci
ölçülebilmeli — ekranda görmeden önce sayıyla.

### 5.3 Birim ve eksen

Değişken adı birimi taşır (`boyM`, `xHucre`). Katman sınırını ham sayı geçmez.
Yerel eksen dönüşümleri tek yerde tanımlanır ve yorumda açıkça yazılır.

### 5.4 Hata görünür olur

Hata konsola değil **ekrana da** basılır. Mantık ölse bile dünya çizilmeye devam
eder ve ikisi gözle ayırt edilebilir.

### 5.5 Yapı damgası

İlk günden ekranda görünür ve her değişiklikte güncellenir (`betik/veri/surum.gd`).

### 5.6 Tek değişken değiştir

Bir denemede yalnızca bir şey değişir.

### 5.7 Ölçtüğünü doğrula

En sık hata ailesi: "ölçtüğümü sandığım şey, ölçmek istediğim şey değildi."
Her ölçümden önce sor: **bu gerçekten ölçmek istediğim şey mi?** Her rapor ölçüm
koşullarını yazar: yapı damgası, Godot sürümü, çözünürlük, şarj durumu.

### 5.8 Negatif kontrol

Her test için hatayı bilerek geri koy ve testin **düştüğünü gör**. Düşmüyorsa
test bir şey ölçmüyordur. Yeni bir test en az bir negatif kontrolle birlikte
commit edilir (`testler/negatif-kontrol.sh`).

### 5.9 Değişikliğin uygulandığını doğrula

Aranan metin bulunamazsa değiştirme sessizce hiçbir şey yapmaz. Kritik
değişiklikten sonra `grep` ile kontrol et.

### 5.10 Kabul kriteri kayıttır

Bir davranış "ekranda ayırt edilebiliyor" denemez — **3 dakikalık kayıt alınır**,
kodu bilmeyen birine izletilir. Seviyeyi söyleyebiliyorsa geçti. İkinci denemede
bu kriter yazılıydı ama hiç kimseye kanıtlanmadı.

### 5.11 Yorum disiplini

Yorumlar **Türkçe** ve NE yaptığını değil **NEDEN** öyle olduğunu anlatır.
Başarısız denemeyi de yazar: "önce X denedim, şu yüzden olmadı".

---

## 6. Üç ajanlı çalışma

### 6.1 İş bölümü

- **Claude Code:** sistem kurmak · çok dosyaya yayılan iş · saf veri +
  değişmez modülleri · test yazma · ölçüm ve analiz · belge · uzun işler.
- **Cursor:** o an açık dosyada satır satır düzenleme · tek fonksiyonda hata
  ayıklama · anlık görsel geri bildirim gerektiren iş.
- **ChatGPT (kotalı):** tek dosyalık, **tam tanımlı**, incelenebilir işler.
  Kota sınırlı olduğu için belirsiz iş verilmez — verilen madde §6.3
  formatında eksiksiz yazılır.

### 6.2 Oyun hissi KULLANICIDADIR

Hız, ivme, kamera salınımı, zıplama yüksekliği, arkadaşın tepki gecikmesi —
bunlar `@export var` ile tanımlanır, editör panelinde kaydırıcı olur ve **oyun
çalışırken** değişir. Kullanıcı kendi ayarlar; ajana kuyruk maddesi yazılmaz.
İkinci denemede bu iş bir ajanın 12 maddelik kuyruğuydu.

### 6.3 Dal, kuyruk ve git

- Her ajan **kendi dalında**: `claude/<is>`, `cursor/<is>`, `gpt/<is>`.
  Kimse doğrudan `main`'de çalışmaz.
- **`git add .` YASAK** (ve `-A`, `commit -a`). Her zaman dosya adıyla ekle.
- Commit öneki: `claude:` / `cursor:` / `gpt:`. Mesaj **NEDEN**'i anlatır.
- **Belge dalları** sorulmadan `main`'e birleşir. **Kod dalları birleşmeden
  önce kullanıcıya sorulur.**
- Devir formatı (kuyruk maddesi):
  `DOSYA / SORUN (ölçülmüş) / İSTENEN / KABUL (somut sayı ya da kayıt) / DOKUNMA`
- Bir dosyayı değiştirmeden önce **diskten oku**. Bağlamındaki sürüme güvenme.
- Kuyruk maddesi `[x]` olunca bitmiş sayma — **ölç**.

---

## 7. Kullanıcıyla çalışma

- `belge/OYUN-TASARIMI.md` tasarımın tek kaynağıdır; karar vermeden önce okunur.
- `belge/KARAR-GUNLUGU.md`: her önemli karar ve her ilginç hata — sebebi ve
  **nasıl bulunduğu** ile birlikte.
- **Belge enflasyonu yasak.** İkinci denemede 5.356 satır belgeye karşı 748 satır
  arkadaş kodu vardı (7:1). *İki dakika oynayarak kapanacak bir soru yazılmaz,
  oynanır.*
- Görsel bir iddiada bulunmadan önce **bak.** "Ağaçlar düzeldi" demeden önce
  ağaca bak.
- Bir şeyi yanlış yaptıysan söyle ve neden yanlış olduğunu açıkla. **Sessizce
  düzeltme.**
- Emin değilsen tahmin etme, **ölç**. Ölçemiyorsan sor.
- Belgeler ve yorumlar Türkçe.

---

## 8. Varlıklar

- Bütçe **0 TL**: yalnızca CC0/ücretsiz. Poly Haven · ambientCG · Quaternius ·
  Kenney · Fab (CC0 filtresi) · Mixamo · freesound (lisansı tek tek bak).
- **`belge/VARLIK-KAYNAKLARI.md` her varlık için tek satır tutar:**
  dosya · kaynak URL · lisans · indirme tarihi · yapılan değişiklik.
  Sesler için bu defter zaten var (`varlik/ses/LISANS.md`, CC0) — diğer
  türlere yayılacak.

---

## 9. Komutlar

| Ne | Komut |
|---|---|
| Editörü aç | `godot --path ~/Projects/ada-godot --editor` |
| Oyunu çalıştır | `godot --path ~/Projects/ada-godot` |
| Katman kuralları | `godot --headless --path . --script res://testler/katman-kurallari.gd` |
| Hikâye zinciri | `godot --headless --path . --script res://testler/zincir.gd` |
| Moral tabanı (A2) | `godot --headless --path . --script res://testler/moral-tabani.gd` |
| Algı ve ateş ışığı | `godot --headless --path . --script res://testler/algi.gd` |
| Defter sınırı | `godot --headless --path . --script res://testler/defter.gd` |
| İki dil | `godot --headless --path . --script res://testler/dil.gd` |
| Kayıt gidiş-dönüş | `godot --headless --path . --script res://testler/kayit.gd` |
| Altı günlük koşu | `godot --headless --path . --script res://testler/alti-gun.gd` |
| Çağırma (K-068) | `godot --headless --path . --script res://testler/cagri.gd` |
| Animasyon kütüphanesi | `godot --headless --path . --script res://testler/animasyon.gd` |
| Ateş ve yakıt (K-070) | `godot --headless --path . --script res://testler/ates.gd` |
| Yaban köpeği (K-071) | `godot --headless --path . --script res://testler/kopek.gd` |
| "Bekle" sözü (K-072) | `godot --headless --path . --script res://testler/soz.gd` |
| Günün ışığı (K-073) | `godot --headless --path . --script res://testler/isik.gd` |
| Kadraj (görüntü + ölçüm) | `godot --path . --script araclar/kadraj.gd` — görünür pencere |
| Çağrı sondası (ekranda) | `godot --path . --script araclar/cagri-sondasi.gd` — görünür pencere |
| Performans bütçesi | `godot --path . --script araclar/butce.gd` — görünür pencere, ~12 s |
| Gün dönüşü (ekranda) | `godot --path . --script araclar/gun-donusu.gd` — görünür pencere |
| Köpek (ekranda) | `godot --path . --script araclar/kopek-sondasi.gd` — görünür pencere |
| Nefes: çöküş ≠ ölüm | `godot --path . --script araclar/nefes-sondasi.gd` — görünür pencere |
| Negatif kontroller (hepsi) | `./testler/negatif-kontrol.sh` — ~3 dk |

Çıkış kodu **0** geçti · **1** başarısız · **2** çalıştırılamadı.
**2'yi "geçti" sayma.**

---

## 10. Belge haritası

| Dosya | Ne için |
|---|---|
| `AGENTS.md` (`CLAUDE.md` → bağ) | Ortak ve kalıcı kurallar |
| **`belge/OYUN.md`** | **Oyunun tek okumalık anlatımı — yeni gelen ÖNCE bunu okur** |
| `belge/OYUN-TASARIMI.md` | Tasarımın tek kaynağı; davranış tablosu |
| `belge/KARAR-GUNLUGU.md` | Kararlar ve hatalar; sebebi ve nasıl bulunduğu |
| `belge/UCUNCU-DENEME.md` | Zemin değişikliğinin gerekçesi ve kurulum |
| `belge/HIKAYE-OMURGASI.md` | 12 günlük omurga |
