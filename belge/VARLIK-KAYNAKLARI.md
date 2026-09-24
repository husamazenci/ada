# Varlık kaynakları ve lisans defteri

> Araştırma: **ChatGPT** (2026-09-24, pano §5 maddesi).
> Doğrulama: **Claude** — her URL çağrıldı, her lisans sayfanın kendisinden
> okundu (§6.6: kuyruk maddesi `[x]` olunca bitmiş sayılmaz, ölçülür).
> Bütçe 0 TL. **Lisansı belirsiz olan varlık bu deftere girmez.**

Kullanılan varlık buraya **indirme tarihi ve yapılan değişiklikle** yazılır.
Aşağıdaki 1–N bölümleri ADAY listesidir; gerçekten indirilip depoya girenler
en sonda "İndirilenler" bölümünde.

---

## 1. Doğrulama özeti

18 URL çağrıldı, **18'i yaşıyor** (HTTP 200) ve sayfa başlıkları iddia edilen
varlıkla eşleşiyor — yani yanlış sayfa yok. Lisanslar sayfa içeriğinden
okundu, ikinci elden değil.

**Üç düzeltme/ekleme:**

1. **Kurt varlığı (`3d-wolf-animation-for-game`) yanlış alarmdı.** Önce GPL
   göründüğü için şüphelendim; sayfa **çoklu lisans** veriyor (CC0 **ve**
   GPL 2.0 **ve** GPL 3.0). OpenGameArt'ta çoklu lisansta biri seçilir, yani
   ChatGPT'nin "CC0 seçeneği mevcut" ifadesi doğruymuş.
2. **`Character: Dog` gerçekten CC-BY 3.0** — atıf zorunlu. Tabloda kalıyor
   ama kullanılırsa künyeye yazılması gerekir.
3. **ChatGPT'nin atladığı asıl bulgu:** Quaternius'un **Universal Animation
   Library**'si (CC0, 120+ animasyon) Universal Base Characters ile **aynı
   rigi** kullanıyor ve Godot'da test edilmiş. Bu, Mixamo'ya olan ihtiyacı
   tamamen kaldırıyor ve retarget riskini sıfırlıyor.

---

## 2. ÖNERİLEN SET — tek elden, tek dil

Stil birliği en büyük riskti (K-053: "farklı ellerden çıkmış ama aynı dilde
konuşan bir dünya"). Beş paketin hepsi **Quaternius**, hepsi **CC0**, hepsi
aynı görsel dil. Risk kökünden kalkıyor.

| Paket | İçerik | Format | Doğrulandı |
|---|---|---|---|
| [Universal Base Characters](https://quaternius.com/packs/universalbasecharacters.html) | 6 humanoid gövde, 20 saç, ort. 13k üçgen | FBX · glTF · Blend | CC0 ✓ |
| [Universal Animation Library](https://quaternius.com/packs/universalanimationlibrary.html) | **120+ animasyon**, aynı rig: 8 yönde yürüme, koşma, **oturma**, **itme**, sürünme, **ölüm** | FBX · GLB · Blend | CC0 ✓ |
| [Stylized Nature MegaKit](https://quaternius.com/packs/stylizednaturemegakit.html) | 116 model: 40 ağaç, 35 bitki, 27 kaya, çalı, çimen | FBX · OBJ · glTF · Blend | CC0 ✓ |
| [Ultimate Animated Animal Pack](https://quaternius.com/packs/ultimateanimatedanimals.html) | 12 hayvan, her biri 12+ animasyon (saldırı, ölüm, yürüme, dörtnal) | FBX · OBJ · glTF · Blend | CC0 ✓ |
| [Survival Pack](https://quaternius.com/packs/survival.html) | 53 hayatta kalma nesnesi (kamp, alet, kap) | FBX · OBJ · Blend | CC0 ✓ |

**Tasarıma doğrudan denk düşenler:** `oturma` (moral düşük · ateş başı),
`itme` (salı itmek · arkadaşın seni itmesi, K-026), `ölüm` (yavaş vazgeçiş,
K-055), `8 yönde yürüme` (güven mesafesi ve yönelimi, §4 davranış tablosu).

**İki uyarı:**
- Ücretsiz sürüm paketin **%60–70'ini** içerir; gerisi Patreon. Ücretsiz kısım
  bu oyuna fazlasıyla yeter, ama "şu model yok" sürprizi indirmeden görülmez.
- **Survival Pack'te glTF YOK** (FBX/OBJ/Blend) — Blender'dan geçirilecek.
- Ultimate Animated Animal Pack'teki 12 hayvanın hangileri olduğu sayfada
  yazmıyor; **köpek/kurt var mı indirmeden önce görsel kontrol edilmeli.**
  Yoksa aşağıdaki OpenGameArt adayları devreye girer.

---

## 3. Tam aday listesi (ChatGPT'nin tablosu + doğrulama)

| Ne | Kaynak | Lisans (doğrulandı) | Çokgen / çözünürlük | Stil notu |
|---|---|---|---|---|
| **İnsan gövdesi** ||||
| Universal Base Characters | [quaternius](https://quaternius.com/packs/universalbasecharacters.html) | CC0 ✓ | ort. 13k üçgen | Humanoid rig, glTF. **Önerilen.** |
| Lowpoly Dummy Character (10 anim) | [OGA](https://opengameart.org/content/lowpoly-dummy-character10-animations) | CC0 ✓ | belirtilmemiş | Rigli, animasyonlu; FBX → glTF |
| Low Poly Character | [OGA](https://opengameart.org/content/low-poly-character-1) | CC0 ✓ | belirtilmemiş | Rigli; .blend → glTF |
| **Ağaç ve çalı** ||||
| Stylized Nature MegaKit | [quaternius](https://quaternius.com/packs/stylizednaturemegakit.html) | CC0 ✓ | 40 ağaç, 35 bitki | Ghibli esintili stilize. **Önerilen.** |
| Low Poly Pine Tree | [OGA](https://opengameart.org/content/low-poly-pine-tree-0) | CC0 ✓ | belirtilmemiş | İğne yapraklı; FBX/OBJ |
| LowPoly Leaf Tree | [OGA](https://opengameart.org/content/lowpoly-leaf-tree) | CC0 ✓ | belirtilmemiş | Geniş yapraklı; palete uyarlanmalı |
| Low Poly Nature Group | [OGA](https://opengameart.org/content/low-poly-nature-group) | CC0 ✓ | belirtilmemiş | Çalı ve ada bitkileri |
| **Kaya, kütük, dal** ||||
| Stylized Nature MegaKit (kayalar) | [quaternius](https://quaternius.com/packs/stylizednaturemegakit.html) | CC0 ✓ | 27 kaya | Ağaçlarla aynı dil. **Önerilen.** |
| Free Vegetation Asset Pack | [OGA](https://opengameart.org/content/free-vegetation-asset-pack) | CC0 ✓ | dal 126–440, kütük 88–350 üçgen | Üç LOD var |
| Low Poly Wood Log | [OGA](https://opengameart.org/content/low-poly-wood-log) | CC0 ✓ | belirtilmemiş | Tekil kütük |
| Low Poly Rocks | [OGA](https://opengameart.org/content/low-poly-rocks) | CC0 ✓ | ~150 poligon; 4096² normal | **Normal haritası 4K — stilize dile aykırı**, küçültülmeli |
| **Zemin dokusu** ||||
| Coast Sand 04 | [Poly Haven](https://polyhaven.com/a/coast_sand_04) | CC0 1.0 ✓ | 1K–8K | **Fotogerçekçi — dikkat, aşağıya bak** |
| Gravel 022 | [ambientCG](https://ambientcg.com/view?id=Gravel022) | CC0 ✓ | 1K–8K | 1K ve düşük normal kullanılmalı |
| Forest Ground Texture | [OGA](https://opengameart.org/content/forest-ground-texture) | CC0 ✓ | 512² renk + normal | Sade; tekrar görünümü kontrol edilmeli |
| Ground Textures Free | [OGA](https://opengameart.org/content/ground-textures-free) | CC0 ✓ | 1024² | Koyu, düşük doygunluk palete uyar |
| **Yaban köpeği** ||||
| Ultimate Animated Animal Pack | [quaternius](https://quaternius.com/packs/ultimateanimatedanimals.html) | CC0 ✓ | 12 hayvan, 12+ anim | **Önerilen** — köpek/kurt içeriği doğrulanmalı |
| Animated Animales Low Poly | [OGA](https://opengameart.org/content/animated-animales-low-poly) | CC0 ✓ | belirtilmemiş | Köpek ve kurt; glTF'ye dönüştürülebilir |
| Character: Dog | [OGA](https://opengameart.org/content/character-dog) | **CC-BY 3.0 ✓ — atıf zorunlu** | belirtilmemiş | Yürüme, bekleme, havlama |
| Cube Pets | [Kenney](https://kenney.nl/assets/cube-pets) | CC0 ✓ | belirtilmemiş | Belirgin kübik — **oyuncak görünümlü, bu oyuna uymaz** |
| 3D Wolf Animation | [OGA](https://opengameart.org/content/3d-wolf-animation-for-game) | CC0 ✓ (çoklu: CC0/GPL2/GPL3) | belirtilmemiş | Yürüme, koşma, saldırı; .blend → glTF |

---

## 4. Stil uyarısı — fotoğraf dokusu tuzağı

Poly Haven ve ambientCG dokuları **fotogerçekçidir**. Quaternius modellerinin
düz, elle boyanmış dilinin yanında bunlar yamalı durur — iki farklı oyun gibi
görünür. K-053 "tutarlı stilize" dedi ve tutarlılık burada kırılır.

**Kural:** zemin önce Nature MegaKit'in kendi çimen/zemin varlıklarıyla
denenir. Fotoğraf dokusu kullanılacaksa 1K'ya indirilir, normal haritası
neredeyse kapatılır ve rengi düzleştirilir. Ölçüt gözle: **kadrajda hangi
yüzeyin fotoğraf olduğu anlaşılıyorsa yanlıştır.**


---

## İndirilenler — depoda gerçekten duran varlıklar

### Universal Base Characters (Quaternius) · CC0 · indirildi 2026-09-24

| | |
|---|---|
| Kaynak | Quaternius — Universal Base Characters [Standard] |
| Lisans | CC0 (`License_Standard.txt` pakette) |
| Depodaki yer | `varlik/karakter/temel/` |
| Kullanılan | `Superhero_Male_FullBody.gltf` + `.bin` + 7 doku |
| Ölçü | boy 1.81 m, **metre biriminde** — ölçeklemeye gerek yok |
| Rig | 65 kemik, UE adlandırması (`pelvis`, `spine_01..03`, `thigh_l` …) |
| Yoğunluk | 14 318 üçgen · 3 ağ (gövde, saç, göz) · 3 malzeme |

**Yapılan değişiklikler:**

1. **İki doku adı düzeltildi.** Satıcı ihracı `T_Hair_1_Normal_png.png` ve
   `T_Eye_Normal_png.png` arıyordu; pakette bu adda dosya YOK, doğruları
   `T_Hair_1_Normal.png` ve `T_Eye_Normal.png`. Düzeltilmeseydi Godot iki
   normal haritayı bulamaz ve **hata bile vermeden** saç/göz normalsiz
   kalırdı. `.gltf`'in LFS dışında, düz metin tutulması bunu görünür kıldı.
2. **Yalnızca kullanılan dosyalar depoya alındı** (11 MB). Satıcı klasörünün
   tamamı 127 MB ve çoğu Unity/Unreal kopyası; `.gitignore`'da.

**"Superhero" isim, kostüm değil:** model iç çamaşırlı bir TEMEL gövde.
Hayatta kalma oyunu için **kıyafet gerekiyor** — ayrı bir CC0 paket işi.

### Universal Animation Library (Quaternius) · CC0 · indirildi 2026-09-25

| | |
|---|---|
| Kaynak | Quaternius — Universal Animation Library [Standard] |
| Lisans | CC0 1.0 (`LISANS.txt` pakette) |
| Depodaki yer | `varlik/karakter/animasyon/UAL1_Standard.glb` (7.6 MB) |
| İçerik | **43 klip**, 65 kemik |
| Rig uyumu | Gövdeyle **birebir**: aynı 65 kemik, aynı adlar, **aynı sıra** |

**Kök hareketsiz sürüm alındı.** Pakette iki GLB var: `UAL1_Standard` (kök
hareketi kapalı) ve `UAL1_Standard_RM` (kök hareketi klibe gömülü). Hareketi
`betik/cizim/arkadas.gd` sürüyor — mesafe güvenden, tempo moralden geliyor —
bu yüzden kök hareketli sürüm iki kanalı da ezerdi.

**AnimationLibrary olarak içe aktarılıyor, sahne olarak değil.** Sahne olsaydı
7.6 MB'lık `Mannequin` ağı da gelirdi; gövdemiz ayrı. `.import` dosyasında
`importer="animation_library"`.

**Godot klip adlarını DEĞİŞTİRİR:** `_Loop` ekini kırpar ve onu döngü işareti
olarak kullanır (`Idle_Loop` → `Idle`, döngü açık). Koddaki kapalı liste
(`betik/veri/animasyonlar.gd`) Godot'nun verdiği adları tutar.

Oyunun kullandığı altı klip: `Idle` · `Walk` · `Sitting_Enter` ·
`Sitting_Idle` · `Sitting_Exit` · `Death01`.

**İleride hazır bekleyenler:** `Push` (sal), `Fixing_Kneeling` (barınak),
`Hit_Chest`/`Hit_Head` (köpek), `Idle_Torch` (ateş başı), `Crouch_*` (yaralı),
`Interact`, `PickUp_Table`.

### Satıcı klasörleri depoya girmez

İkisi de `.gitignore` ve `.gdignore` altında: git'e girmiyorlar, Godot da
taramıyor. Kullanılan dosyalar `varlik/karakter/temel/` ve
`varlik/karakter/animasyon/` altına kopyalandı.
