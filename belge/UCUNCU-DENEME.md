# Üçüncü Deneme — Kurulum ve Plan

> 2026-09-23 · Kullanıcı kararlarıyla hazırlandı.
> Zemin: **Godot 4.7.2 + masaüstü** · Bütçe: **0 TL (yalnızca CC0/ücretsiz)**
> Görsel: **tutarlı stilize — gerilimden taviz yok** · Ajanlar: **Claude + Cursor + ChatGPT (kotalı)**
>
> Bu belge iki denemenin ölçülmüş kanıtına dayanır. Tahmin yok; her iddianın
> arkasında bu depodan bir sayı ya da bir karar kaydı var.

---

## 0. Neden iki deneme de aynı yerde takıldı (ölçüm)

İkinci denemenin toplamı: **15.028 satır, 5 günde 122 commit.** Dağılımı:

| Katman | Satır | Pay |
|---|---:|---:|
| **`src/ai/` — arkadaş, yani oyunun kalbi** | **748** | **%5** |
| `tests/` + `tools/` — motoru ölçmek için yazılan altyapı | 6.634 | %44 |
| Arazi, deniz, ışık, ağaç, beden, ses, kayıt, menü — yani motor | 7.646 | %51 |
| 3B model varlığı | 0 dosya | — |
| Belgeler | 5.356 satır | (kod dışı) |

Birinci deneme (`~/Projects/yeni-oyun`, 30 Ağustos – 16 Eylül) aynı yığındaydı:
tarayıcı + Three.js + Python'la üretilen varlıklar. Aynı sonuç, iki kez.

**Teşhis: sebep disiplinsizlik değildi.** Disiplin olağanüstüydü — negatif
kontrol, çıkış kodu 2, yapı damgası, "ölçtüğünü doğrula". Sebep şu: *Three.js'te
oyun yapmak, önce oyun motoru yazmak demektir.* 52 karar kaydının **9'u**
("ölçüm aracım bana yalan söyledi": K-003, K-012, K-013, K-014, K-015, K-016,
K-019, K-023, K-032) motorun kendisiyle değil, motoru ölçen ev yapımı aletle
ilgiliydi. Bir motorda bu dokuz kaydın tamamı hiç yazılmazdı.

**Godot'nun kapattığı kalemler:** arazi, çarpışma, navmesh, animasyon ağacı,
ışık/gölge, ses motoru ve 3B ses, kayıt/serileştirme, girdi eşlemesi,
yerelleştirme (CSV), kare süresi ve çizim çağrısı sayaçları, profiler.
Yani yukarıdaki tablonun **%95'i**. Geriye kalan %5 oyunun kendisidir.

---

## 1. Bugün makinede yapılacaklar (~90 dakika)

Makinede şu an: Git 2.39.5 · Node 24 · Xcode CLI · Cursor. **Yok:** Homebrew,
Godot, Blender, git-lfs, ffmpeg. Disk boşluğu 147 GB — yeterli.

### 1.1 Homebrew (diğer her şeyin önkoşulu)

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Bitince Apple Silicon'da PATH'e eklenmesi gerekir:

```
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile && eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 1.2 Godot 4.7.2

```
brew install --cask godot
```

Notlar:
- Sürüm 4.7.2 (18 Ağustos 2026), Apple Silicon derlemesi var, **imzalı ve
  noter onaylı** — Gatekeeper uyarısı çıkmaz. Kurulum gerektirmez, kendi
  kendine yeter.
- **.NET sürümünü ALMA.** GDScript seçiyoruz: C# için ayrıca .NET SDK gerekir,
  derleme adımı eklenir, ajanların iterasyonu yavaşlar. GDScript'i LLM'ler iyi
  biliyor ve sen de okuyabilirsin — `AGENTS.md` §4'teki "kod okunabilir ve
  diff'lenebilir kalmalı" kuralının aynısı.

### 1.3 `godot` komutunu doğrula (testler bunu kullanacak)

Elle bağ kurmaya **gerek yok**: `brew install --cask godot` ikiliyi kendisi
`/opt/homebrew/bin/godot` olarak bağlar. Yalnızca doğrula — çıktı
`4.7.2.stable.official...` demeli:

```
godot --version
```

Bu bağ olmadan `godot --headless --script ...` çalışmaz; saf simülasyon
testlerinin tamamı buna dayanıyor.

### 1.4 Blender + Git LFS + ffmpeg

```
brew install --cask blender && brew install git-lfs ffmpeg
```

- **Blender:** Mixamo'dan inen FBX'i glTF'e çevirmek, ölçek/pivot düzeltmek,
  poligon düşürmek için. Kaçınılmaz — ücretsiz varlık yolu Blender'dan geçer.
- **git-lfs:** ikili varlıklar için. **İlk varlık commit'inden ÖNCE** kurulmalı;
  sonradan eklemek git geçmişini yeniden yazmayı gerektirir.
- **ffmpeg:** ses kırpma/dönüştürme (elindeki 96 `.wav` dosyası için de).

### 1.5 Cursor ↔ Godot bağlantısı

Godot'yu aç → `Editor > Editor Settings > Text Editor > External`:
- `Use External Editor`: **açık**
- `Exec Path`: `/Applications/Cursor.app/Contents/MacOS/Cursor`
- `Exec Flags`: `{project} --goto {file}:{line}:{col}`

Cursor tarafında `godot-tools` eklentisini kur (VS Code marketplace'inden gelir).

### 1.6 Hesaplar (hepsi ücretsiz, bugün açılsın)

| Ne | Ne için | Not |
|---|---|---|
| **Adobe / Mixamo** | Rigli insan gövdesi + mocap animasyon | Ücretsiz; doğruladım, ayakta |
| **Poly Haven** | CC0 HDRI, doku, model | Hesap şart değil ama indirme kolaylaşır |
| **ambientCG** | CC0 zemin/kaya/ağaç kabuğu dokuları | — |
| **Quaternius** | CC0 doğa ve karakter modelleri | Stilize, birbiriyle tutarlı — bizim yönümüz |
| **Kenney** | CC0 ses efekti + prototip modeli | Gri kutu fazı için ideal |
| **freesound.org** | Ortam sesi | Lisanslar karışık — her dosyanın lisansı ayrı bakılacak |
| **GitHub** | Özel depo | LFS ücretsiz kotası 1 GB; aşarsan varlıkları harici diskte tut |

---

## 2. Yeni deponun iskeleti

Eski depo **silinmez, dokunulmaz** — referans olarak kalır. Yeni depo ayrı:

```
git init ~/Projects/ada-godot
```

### Klasör düzeni

```
ada-godot/
  project.godot
  sahne/           # .tscn dosyaları — küçük ve parçalı tutulur
  betik/
    sim/           # dünyanın kuralları: açlık, ateş, tehdit, eylemler
    ai/            # arkadaşın algısı, güveni, morali, kararı
    veri/          # saf veri tabloları + inşa değişmezleri
    cizim/         # yalnızca burada görsel/düğüm kodu
  varlik/
    karakter/
    doga/
    doku/
    ses/
  testler/         # godot --headless --script ile koşan saf testler
  belge/
  .scratch/
```

**Katman kuralı aynen sürüyor** (`AGENTS.md` §5.2): `sim/`, `ai/` ve `veri/`
görsel düğüm (`Node3D`, `MeshInstance3D`, materyal, viewport) **içe aktaramaz**.
Bunu bir test denetler. Sebep değişmedi: arkadaşın davranışı pencere açmadan,
saniyenin altında ve belirlenimci ölçülebilmeli.

### `.gitignore`

```
.godot/
.scratch/
.DS_Store
dist/
*.translation
```

`.godot/` Godot'nun içe aktarma önbelleğidir; asla commit edilmez.

### `.gitattributes` — ilk varlıktan önce

```
*.glb    filter=lfs diff=lfs merge=lfs -text
*.fbx    filter=lfs diff=lfs merge=lfs -text
*.blend  filter=lfs diff=lfs merge=lfs -text
*.png    filter=lfs diff=lfs merge=lfs -text
*.jpg    filter=lfs diff=lfs merge=lfs -text
*.wav    filter=lfs diff=lfs merge=lfs -text
*.ogg    filter=lfs diff=lfs merge=lfs -text
*.exr    filter=lfs diff=lfs merge=lfs -text
```

`.tscn` ve `.tres` **LFS'e girmez** — onlar düz metindir, diff'lenmeleri
ajanların sahneyi okuyabilmesinin tek sebebidir.

---

## 3. Varlık lisans defteri (yeni kural)

`belge/VARLIK-KAYNAKLARI.md` — her varlık için tek satır:

```
| dosya | kaynak (URL) | lisans | indirme tarihi | değişiklik |
```

Sebep: bugün 0 TL'lik CC0 karışımıyla ilerliyoruz; oyunu bir gün yayımlarsan
"bu ağaç nereden geldi" sorusunun cevabı üç ay sonra bulunamaz. Freesound'daki
dosyaların bir kısmı atıf ister, bir kısmı ticari kullanıma kapalıdır. Defter
tutulmazsa tek tek geri izlemek gerekir.

---

## 4. Eski denemeden ne taşınır, ne taşınmaz

### Taşınır (değerli olan kısım)

- **Tasarım kararlarının tamamı.** `OYUN-TASARIMI.md`, `KARAR-GUNLUGU.md`
  (K-001…K-052), `HIKAYE-OMURGASI.md`, `ADA-SECENEKLERI.md`. Bunlar iki ay
  düşünmenin ürünü; kod eskidi, tasarım eskimedi.
- **48 ses dosyası** (`public/ses/`). Nefes, uluma, dal kırılması, yeme. Godot
  bunları doğrudan okur. Gerilimi kuracak en güçlü elindeki malzeme ve bedava.
- **Mühendislik disiplininin özü:** negatif kontrol · çıkış kodu 2 = "ölçülemedi"
  · yapı damgası · "ölçtüğünü doğrula" · tek değişken değiştir · yorumlar NEDEN'i
  anlatır. Bunlar araçtan bağımsız, evrensel ve iki denemede de işe yaradı.
- **Davranış tablosu ve kabul kriteri fikri** (`OYUN-TASARIMI.md` §4).

### Taşınmaz (motor yazma maliyeti)

`src/cizim/`, `src/veri/ada.js`, `src/veri/isik.js`, `src/veri/aciklik-cevresi.js`,
`src/sim/dunya.js`, `src/ses/motor.js`, `src/askiya-alma.js`, `src/kamera-bedeni.js`,
`tools/kare-suresi.mjs`, `tools/gpu-farki.mjs`, `tools/bak.mjs`, `tools/harita.mjs`.
**~9.000 satır.** Karşılıkları Godot'da hazır gelir.

### Yeniden yazılır ama küçülür

`src/ai/arkadas.js` (748 satır) → GDScript'e taşınır. Mantık kalır; algı
(görme, duyma, mesafe) ve yol bulma motordan gelir, yani kısalır.

---

## 5. Farklı yapacağım on üç şey

Her madde bu depoda gerçekten yaşanmış bir şeyden çıktı.

**1 · Motoru yazma.** Gerekçe yukarıda: kalp %5'te kaldı çünkü %95 kabuğa gitti.

**2 · Karakter animasyonu ilk iş olsun, son değil.** Bu oyunun tamamı bir bedeni
okumaktan ibaret — "güven yalnızca davranıştan okunur" değişmez kuralı bunu
söylüyor. İkinci denemede arkadaş ilkel şekillerden çiziliyordu
(`arkadas-cizim.js`, 282 satır) ve hiç iskeleti yoktu. Godot'da ilk hafta:
Mixamo gövdesi + `AnimationTree` + dört animasyon (dur, yürü, otur, çök).

**3 · Gri kutu kapısı.** Arkadaşın **üç güven seviyesi gri kapsüllerle ayırt
edilemiyorsa hiçbir görsel iş başlamaz.** İkinci denemede Cursor ve Codex'in
tamamı görsele gitti (ışık, sis, deniz, falez, ağaç halkası) — `src/ai/` 748
satırda kaldı. Bu bir öncelik tavsiyesi değil, bir kapı: geçilmeden öteye
gidilmez.

**4 · "Çekirdek an", dikey dilimden de küçük.** Senin dilim tanımın bile fazla
kalabalık (iki açlık sayacı + yiyecek + ateş + yakıt + gece tehdidi + çağırma +
koşma + ses + sersemleme). Önce **tek oda, tek arkadaş, tek yiyecek, iki eylem
(YE / VER)**. Tez şu: *sen açken yiyeceğini verdiğinde onun davranışı gözle
görülür biçimde değişir.* Bu cümle gri kutuda çalışmıyorsa oyun yok demektir —
ateş de ada da bunu kurtarmaz.

**5 · Ölçüm aracını sen yazma.** 52 kararın 9'u ev yapımı ölçüm aletinin
yalanıydı. Godot kare süresini, çizim çağrısını ve üçgeni motor içinden verir
(`Performance.get_monitor`). Bütçe HUD'u geliştirme derlemesinde **sürekli
açık** durur.

**6 · Bütçe ölçümü tören olmaktan çıksın.** `tools/kare-suresi.mjs` 3,5 dakika
sürüyordu ve şarj + sessiz makine + düşük güç kapalı istiyordu; sonuç olarak
ölçüm defalarca ertelendi ve panoda "KARE SÜRESİ BORCU SÜRÜYOR" diye kaldı —
üç dal ölçülmeden `main`'e girdi. Sürekli açık bir sayaç bu borcu yapısal olarak
imkânsız kılar.

**7 · Kabul kriteri video olsun.** "Üç güven seviyesi ekranda ayırt edilebiliyor"
yazılıydı ama hiç kimseye kanıtlanmadı. Yeni kural: **3 dakikalık kayıt**, kodu
bilmeyen birine izletilir, seviyeyi söyleyebiliyorsa geçti. (macOS'ta
Cmd+Shift+5 yeterli.)

**8 · His ayarını ajana verme, kendine ver.** Godot'da `@export var` ile
tanımlanan her sayı editör panelinde kaydırıcı olur ve **oyun çalışırken**
değişir. İkinci denemede bu iş bir ajanın tüm kuyruğuydu: 12 madde, her biri
"değiştir–bak–değiştir" turu. Artık yürüme hızını, kamera salınımını, arkadaşın
tepki gecikmesini sen elinle ayarlıyorsun — saniyeler içinde, kimseye sormadan.
Bu tek başına Cursor kuyruğunun yarısını siler.

**9 · Belge enflasyonunu durdur.** 5.356 satır belge / 748 satır arkadaş kodu =
**7:1**. Yeni kural: *iki dakika oynayarak kapanacak bir soru yazılmaz, oynanır.*
Belge üçe iner: bir tasarım sayfası, bir karar günlüğü, bir pano.

**10 · Ajan sayısını üçte tut, şeritleri ayır.** Dört ajan 1.282 satırlık
koordinasyon panosu üretti; kimlik tuzakları, port dağıtımı, birleşme borçları
ve "hangi ajan neye dokunabilir" tartışmaları işin kendisi hâline geldi.
Koordinasyon maliyeti ajan sayısıyla karesel büyür.

**11 · Git LFS ilk günden.** Sonradan eklemek geçmişi yeniden yazmak demek.

**12 · Varlık lisans defteri ilk günden.** (§3)

**13 · Ada en sona.** İkinci denemede ada, falez, deniz, ağaç halkası, enkaz —
hepsi arkadaş yaşamadan önce yapıldı. Sıra tersine döner: arkadaş çalışır,
sonra ona bir dünya verilir.

---

## 6. Gerilim nereden gelecek (stilize kararının karşılığı)

"Yarı gerçekçilik"ten vazgeçtik ama gerilimden vazgeçmedik. Gerilim şuradan gelir:

- **Ses.** Elindeki en güçlü koz ve zaten hazır: 48 dosya (22 sakin nefes, 10 korku
  nefesi, 5 uluma, 5 acı, 4 dal kırılması, yeme, dip). Dal kırılması, hırıltı,
  arkadaşın nefesinin ritmi. Godot'nun 3B sesi mesafeyi ve yönü kendisi hesaplar —
  ikinci denemede bu 306 satır el yazısı ses motoruydu.
- **Karanlık ve görüş alanı.** Ateşin ışık yarıçapı bir sınır çizer; tehdit o
  sınırın dışında durur. Bu poligonla değil, ışıkla kurulan bir korkudur.
- **Bedenin zamanlaması.** Arkadaşın ne zaman durduğu, ne zaman sana baktığı, ne
  zaman bakmadığı. Animasyon geçiş süreleri — tamamen stilize bir modelde bile
  tam güçte çalışır.
- **Kamera ve kontrol.** Koşarken kaybettiğin görüş, yaralıyken ağırlaşan hareket.
- **Gösterilmeyen.** Sayı yok, çubuk yok, uyarı yok — bilmemek gerilimin kendisi.

Bu beşinin hiçbiri doku çözünürlüğüne bağlı değil. `Inside`, `Firewatch` ve
`Shelter` da gerçekçi değil; üçü de ağır.

---

## 7. Faz planı

| Faz | Ne | Kapı (geçilmeden sonraki faz başlamaz) |
|---|---|---|
| **0** | Kurulum (§1), yeni depo (§2), `AGENTS.md` yeniden yazımı | `godot --version` çalışıyor, boş proje açılıyor, katman kuralı testi geçiyor |
| **1** | **Çekirdek an.** Gri kutu, iki kapsül, açlık, YE/VER | Kodu bilmeyen biri, kaydı izleyip "arkadaş sana güveniyor/güvenmiyor" diyebiliyor |
| **2** | Gövde ve animasyon. Mixamo + `AnimationTree` | Arkadaşın üç güven seviyesi **duruşundan ve yürüyüşünden** okunuyor |
| **3** | Dikey dilim. Gece, ateş, yakıt, köpek, çağırma, koşma, ses | `OYUN-TASARIMI.md` §8 "bitti sayılması" listesinin tamamı + 3 dakikalık kayıt |
| **4** | Görsel yön. Stil birliği, ışık, sis, materyal | Bütçe HUD'u 60 fps'te; kadraj karşılaştırması |
| **5** | Ada. Elle tasarlanmış, 300 m | Yürüyerek geçilebiliyor, nirengi noktaları okunuyor |
| **6** | Son: fırtına + tek kişilik sal | — |

---

## 8. İlk hafta, gün gün

- **Gün 1:** §1 kurulumu. Godot'nun kendi 3B demolarından birini aç, fansız M2'de
  nasıl döndüğünü gör. Boş proje + git + LFS + `.gitattributes`.
- **Gün 2:** `AGENTS.md` yeniden yazılır (§9 deltaları). Katman kuralı testi ve
  headless test koşucusu kurulur — çıkış kodu 0/1/2 disiplini aynen.
- **Gün 3:** Gri kutu sahnesi: zemin, birinci şahıs kamera, iki kapsül, WASD.
  Bütçe HUD'u aynı gün eklenir.
- **Gün 4–5:** Açlık + YE/VER + arkadaşın karar ağacı (eski `arkadas.js`'in
  taşınmış hâli). Saf simülasyon testi: 12 gün, saniyenin altında.
- **Gün 6:** Mixamo gövdesi ve dört animasyon; Blender üzerinden glTF.
- **Gün 7:** İlk kayıt. İzlet. Faz 1 kapısı geçildi mi, geçilmedi mi — karar.

---

## 9. `AGENTS.md`'de değişecek maddeler

Değişmez kuralların (arkadaş LLM değil · ilişki barı yok · güven yavaş yükselir ·
kalıcı ölüm · oyun öğretmez ama anlatır · fantastik yok · multiplayer yok)
**hiçbiri değişmiyor.** Değişen yalnızca teknik zemin:

| § | Eski | Yeni |
|---|---|---|
| 4 | vanilla JS · Three.js · Vite | **Godot 4.7.2 · GDScript** |
| 4 | Tarayıcı | **Masaüstü (macOS), indirilen uygulama** |
| 4 | Çizim çağrısı < 150 · üçgen < 250k | Godot sayaçlarıyla yeniden taban çizgisi alınır |
| 5.1 | `bak.mjs`, `harita.mjs`, `gpu-farki.mjs`, `kare-suresi.mjs` | Motorun profiler'ı + sürekli açık bütçe HUD'u |
| 5.2 | "THREE içermeyen saf veri modülü" | "Görsel düğüm içermeyen saf `.gd` modülü" — kural aynı, kelime değişti |
| 6.1 | Dört ajan | **Üç:** Claude (sistem, kod, test, ölçüm) · Cursor (açık dosyada satır düzenleme) · ChatGPT (kotalı: tek dosyalık, tam tanımlı, incelenebilir işler) |
| 6.1 | "Oyun hissi Cursor'dadır" | **Oyun hissi KULLANICIDADIR** — `@export` kaydırıcıları, canlı |
| 6.7 | Port 3000/3001/3002 | Godot tek örnek çalıştırır; port kuralı düşer |
| — | — | **YENİ:** görsel iş gri kutu kapısından önce başlamaz |
| — | — | **YENİ:** kabul kriteri 3 dakikalık kayıt |
| — | — | **YENİ:** varlık lisans defteri |
