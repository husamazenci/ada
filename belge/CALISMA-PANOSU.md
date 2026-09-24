# Çalışma Panosu

> Üç ajan: **Claude Code** · **Cursor** · **ChatGPT** (kotalı).
> Herkes kendi bölümüne yazar, diğerininkini değiştirmez.

---

## 1. Dosya sahipliği — çakışma bunun için var

| Alan | Sahip | Not |
|---|---|---|
| `betik/sim/` `betik/ai/` `betik/veri/` | **Claude** | Saf katman; görsel düğüm giremez |
| `testler/` | **Claude** | Her test negatif kontrolüyle |
| `belge/` `AGENTS.md` | **Claude** | Tasarım kararı kullanıcınındır |
| `sahne/` `betik/cizim/oyuncu.gd` | **Cursor** | Oyuncunun kontrolü ve oyun hissi |
| `betik/cizim/arkadas.gd` | **Claude** | Arkadaşın gövdesi — `betik/ai/davranis.gd`'yi UYGULAR, karar vermez. His sayıları `@export`, kullanıcı ayarlar |
| `varlik/` | **ChatGPT** (araştırma) → kullanıcı (indirme) | Lisans defteri şart |
| `project.godot` | **paylaşımlı** | Cursor yalnızca `[input]`, Claude yalnızca `[application]`/`[rendering]` |

**Kural:** bir dosya başka ajana aitse **dokunma** — panoya madde yaz.

---

## 2. Dal düzeni

- `main` — kimse doğrudan çalışmaz.
- `claude/<is>` · `cursor/<is>` · `gpt/<is>`
- Belge dalları sorulmadan `main`'e birleşir. **Kod dalları kullanıcıya sorulur.**
- Commit öneki: `claude:` / `cursor:` / `gpt:` — mesaj **NEDEN**'i anlatır.
- `git add .` YASAK. Dosya adıyla ekle.

**Cursor'un çalışma ağacı henüz kurulmadı.** Kurulumu (kullanıcı çalıştırır):

```
git -C ~/Projects/ada-godot worktree add ~/Projects/ada-godot-cursor -b cursor/ilk main
```

ChatGPT'nin ağacı yoktur — web sohbetidir. İşi kullanıcı yapıştırır ve
çıktısını kullanıcı depoya koyar. Bu yüzden ChatGPT'ye verilen madde
**tek dosyalık ve tam tanımlı** olmalıdır.

---

## 3. Claude bölümü

*Yalnızca Claude Code yazar.*

### GECE RAPORU — 2026-09-24 (kullanıcı uyurken)

Dal: `claude/faz-1-cekirdek`. **`main`'e BİRLEŞTİRİLMEDİ** — kod dalı, onay bekler.

**Yazılanlar (saf katman, penceresiz):** `veri/ayarlar.gd` (bütün ayarlanabilir
sayılar tek kaynakta) · `veri/sahneler.gd` (9 sahnelik omurga + inşa
değişmezleri) · `sim/ihtiyaclar.gd` · `sim/dunya.gd` (fırsat sayacı) ·
`ai/guven.gd` (güven + moral + ihmal).

**Testler:** `alti-gun` (tez ölçümü) · `moral-tabani` (A2 değişmezi) ·
`zincir` (A1 değişmezi) · `katman-kurallari` · `degismez-esitlik`.
**26 negatif kontrolün 26'sı geçiyor.**

**Altı günlük koşu:**
| tip | fırsat | alınan | ihanet | güven | moral | son |
|---|---|---|---|---|---|---|
| fedakâr | 11 | 11 | 0 | 1.00 yüksek | 0.68 yüksek | — |
| dengeli | 8 | 6 | 3 | 0.17 düşük | 0.58 orta | — |
| bencil | 4 | 0 | 4 | 0.00 düşük | 0.26 dip | arkadaş gitti |

**Kullanıcıya üç soru** (sabah):
1. **"Dengeli" oyuncu düşük güvende bitiyor.** 3× oranı çoğunlukla yardım eden
   ama ara sıra kendini düşünen oyuncuyu da dibe atıyor. Orta güven neredeyse
   ulaşılamaz. Oran 3× kalsın mı, 2×'e mi insin?
2. **Fırsat sayısı 11, hedef 12–16 idi.** Hedefi ben tahminle koymuştum ve
   dayandığı ekonomi henüz tasarlanmadı; testi geçirmek için hedefi
   değiştirmedim, iddia olmaktan çıkarıp ölçüm olarak raporladım. Ekonomi
   tasarlanınca band onaylanacak.
3. **Su henüz fırsat üretmiyor.** Dere kampta olduğu için susuzluk yalnızca
   yolculukta ve çöküşte ısırmalı; ikisi de mekân gerektiriyor, yani gri kutu
   sahnesinden sonra.

### BİRLEŞME — 2026-09-24 (kullanıcı onayıyla)

`claude/faz-1-cekirdek` ve `cursor/ilk` `main`'e alındı, çakışma yok.
Birleşme sonrası ölçüm (§6.6): **7/7 çıkış 0** — katman-kurallari, zincir,
moral-tabani, alti-gun, degismez-esitlik, negatif-kontrol (26/26), oyun 180
kare. Üç oyuncu tipi üç güven seviyesine ayrışıyor.

**Açık borç:** ışık yukarı bakıyor (kuyrukta, Cursor, tek satır). Gri kutu
`main`'de ama düz aydınlatılıyor.

### KAPANDI — ihmal kanalının beşi de bağlı (K-061 borcu, 2026-09-25)

`ayarlar.gd`'deki beş ihmal kaynağının **hepsi** artık dünyada karşılık
buluyor. Moral ölümü oynanışla tetiklenebilir durumda.

| Kaynak | Önkoşul | Şimdi yapılabilir mi |
|---|---|---|
| Çökmüş/yaralıyken geceyi yalnız bırakma | `mesafe_m` | **BAĞLANDI** |
| Tehlikede bırakma | köpek | **BAĞLANDI** — köpek geldi (K-071) |
| Geceleyin ateşi söndürme | yakıt sistemi | **BAĞLANDI** (K-070) |
| Elinde varken vermeme | — | **BAĞLANDI** |
| Sözü tutmama | "bekle" mekaniği | **BAĞLANDI** (K-072) |

### AÇIK BORÇ — kıyafet (2026-09-25)

Animasyon kütüphanesi geldi ve bağlandı (K-069). Kalan: model **iç çamaşırlı
bir temel gövde**. Hayatta kalma oyunu için CC0 bir giysi paketi gerekiyor.

### AÇIK BORÇ — çöküş ile ölüm ekranda ayrışmıyor (2026-09-25)

`Death01` son karesinde arkadaş yüzüstü yatıyor. Tasarım çöküşün **günlerce**
sürmesini ve oyuncunun defalarca müdahale şansı olmasını istiyor — ama yatan
çöküş ölümle aynı görünüyor. Canlıyken küçük bir devinim (nefes) gerekiyor,
yoksa gerçekten öldüğünde ekranda hiçbir şey değişmez.

### AÇIK BORÇ — orta moralin bedeni yok (2026-09-25)

Spektin "omuz/baş düşmesi 12°" maddesi bağlı değil: elle omurga bükme
animasyonla çakıştığı için kaldırıldı. Doğru yeri bir `SkeletonModifier3D` —
animasyonun ÜSTÜNE ekler. Şu an orta moral yalnızca tempo (×0.70) ile okunuyor.

### AÇIK BORÇ — mırıltı sesi (K-068)

Çağırma çalışıyor, yazı ekranda beliriyor, ama **ses yok**. Kullanıcının
kararı: "kelime duyulmasın, karakterin boğuk mırıltısı duyulsun". Uydurma
bir yer tutucu koymaktansa sessiz bırakıldı. CC0 bir mırıltı/nefes sesi
gerekiyor (`varlik/ses/` altında 48 CC0 ses var, aralarında yok).

### GECE PLANI — 2026-09-25 (kullanıcı uyurken, ~5 saat)

**Claude'un sırası (bu gece):**

1. **Köpeği sahneye bağla.** Simülasyon çalışıyor, model (Husky) depoda, ama
   ikisi bağlı değil — köpek ekranda YOK. `betik/cizim/kopek.gd` + sahne
   düğümü + animasyon durum makinesi (Walk / Gallop / Attack / Idle_2_HeadLow).
2. **Ateşi sahneye koy.** Ocak nesnesi + ışık + `ATES_ISIK_YARICAPI_M` = 6 m'lik
   gerçek çember. Şu an K-058'in "ateş ışığı istisnası" yalnızca sayıda var,
   ekranda yok — ve `oyun.gd`'deki bağlam merdiveni onun yerine duruyor.
3. **Çöküş ile ölümü ekranda ayır.** `Death01` son karesinde arkadaş yüzüstü
   yatıyor; canlıyken küçük bir nefes devinimi gerekiyor, yoksa gerçekten
   öldüğünde hiçbir şey değişmiyor.
4. **Orta moralin bedeni.** Spektin 12°'lik omuz düşüşü `SkeletonModifier3D`
   ile animasyonun ÜSTÜNE eklenmeli.
5. Sıra vakit kalırsa: yakıt yığınlarını sahneye koymak (odun toplamak
   "ışığın kenarına gitmek" olsun).

Hepsi tek dalda: `claude/kopek`. Kod dalı — sabah birleştirme için onay
sorulacak.

### Şu an
- Faz 0 bitti: proje iskeleti, iki test, dokuz negatif kontrol, LFS, 48 CC0 ses.
- Tasarım gözden geçirmesi bitti (K-055, K-056): kapsam 6 gün/120 dk, zincir
  düzeltildi, moral modeli sayıya bağlandı, düşüş tablosu yazıldı, su ihtiyaç
  oldu, fiil listesi dört tuşa indi, insan hissi kural seviyesine çıktı.
- Faz 1 sürüyor: saf simülasyon + köprü + gri kutu kapısı + çağırma bitti.
  10 test, 74 negatif kontrol, derlenebilir `.app`.
- **Çağırma (K-068) bağlandı** — Q ile seslen, arkadaş bedeniyle cevap versin.
  Sahnede ölçüldü: yüksek 1.05 sn · orta 4.85 sn · düşük gelmiyor.
- **Gerçek gövde sahnede** — kapsül gitti, 1.81 m insan geldi; mesafeler
  bozulmadı (2.20 / 4.28 / 8.28 m).
- **Animasyon bağlandı (K-069)** — dur / yürü / otur / çöküş. Rig birebir aynı
  çıktı, retarget gerekmedi. 11 test, 82 negatif kontrol.
- **Ateş ve yakıt bağlandı (K-070)** — ihmalin 5 kaynağından 4'ü artık dünyada.
  12 test, 91 negatif kontrol.
- **Köpek simülasyonu kuruldu (K-071)** — uyarı → siluet → saldırı; ateş
  caydırıyor; üç sonuç (girdin / denedin / girmedin) ayrışıyor. Güveni
  yükseltmenin ÜÇÜNCÜ yolu ("onu tehlikeden çıkarmak") açıldı.
  13 test, 102 negatif kontrol.
- **"Bekle" sözü bağlandı (K-072)** — Q'ya basmak "gel", basılı tutmak "kal".
  Yeni söz türü açılmadı. **İhmalin beş kaynağı da artık dünyada.**
- **Köpeğin gövdesi geldi** — Husky (kurt değil), 0.74 m, 12 klip.
- 14 test, 111 negatif kontrol.

---

## 4. Cursor kuyruğu

> **ÖNCE:** `cursor/ilk` dalı `main`'in gerisinde. Başlamadan
> `git merge main` — yoksa köpek, animasyon ve ateş hiç yokmuş gibi görünür.

---

## [ ] Köpeğin his ayarı — sahip: cursor · **GECE İŞİ 2026-09-25**

DOSYA:    `betik/cizim/kopek.gd` (Claude gece kuracak), `sahne/dunya.tscn`
SORUN:    Köpeğin simülasyonu ölçüldü ve çalışıyor (K-071): uluma 0.0156 gün,
          kenarda 0.0209 gün, saldırı penceresi 0.005 gün. Ama bunlar SAF
          sayılar — hayvanın ekranda ne hızla dolandığı, nasıl atıldığı,
          ısırmadan sonra nasıl çekildiği hiç ayarlanmadı.
İSTENEN:  `@export` his sayıları: dolanma hızı, atılma hızı, atılma mesafesi,
          çekilme hızı, dönüş hızı. Ateşin çemberi etrafında dolanırken
          `Walk`, atılırken `Gallop`, ısırırken `Attack` oynasın.
KABUL:    (1) Köpek ışığın sınırında GÖRÜNÜR ama çembere GİRMEZ — ateş
          yarıçapı `ATES_ISIK_YARICAPI_M` = 6.0 m.
          (2) Atılma anı gözle "ani" okunmalı; oyuncunun 0.005 gün (~6 sn)
          tepki penceresi var, hayvan o süre içinde erişmeli.
          (3) `araclar/gri-kutu.gd` hâlâ 0 ile çıkmalı.
DOKUNMA:  `betik/sim/kopek.gd` YOK (kural orada, sen hisse bak).
          `betik/ai/*` ve `betik/veri/*` YOK.

## [ ] Koşma (Shift) ayarı — sahip: cursor

DOSYA:    `betik/cizim/oyuncu.gd`
SORUN:    K-030 koşmayı tarif ediyor ama ayarlanmadı: "Yaralıyken ve çok
          açken koşulamaz. Köpekten hızlı değildir."
İSTENEN:  Shift ile koşma; `sim.oyuncu.yarali` true iken ve
          `aclik >= ESIK_AGIR` iken koşma KAPALI.
KABUL:    Köpek galop hızı > oyuncu koşu hızı (ölçülmüş iki sayı, panoya yaz).
          Koşarken kamera salınımı artmalı ama mide bulandırmamalı.
DOKUNMA:  `betik/sim/*`, `betik/ai/*` YOK.

## [ ] Isırık geri bildirimi — sahip: cursor

DOSYA:    `betik/cizim/oyuncu.gd`, `betik/cizim/damga-katmani.gd` DEĞİL
SORUN:    Köpek ısırdığında (`kopek_sonucu` = "araya girdin") ekranda hiçbir
          şey olmuyor. Yara iki gün sürüyor ama oyuncu ısırıldığını bile
          anlamayabilir.
İSTENEN:  Kısa kamera sarsıntısı + yaralıyken hafif, sürekli bir eğim/ağırlık
          hissi. HUD YOK, sayı YOK, kırmızı kenar YOK (§2: ekranda gösterge
          olmaz — bedenden okunur).
KABUL:    Kod bilmeyen biri kaydı izleyince "ısırıldı" diyebilmeli.
DOKUNMA:  `betik/sim/*` YOK.

---

## [x] Gri kutu: birinci şahıs kontrol ve sahne — sahip: cursor · **ÖLÇÜLDÜ (Claude)**

SONUÇ:    Kabul ölçütleri GEÇTİ. Şeride uyulmuş: yalnızca `betik/cizim/oyuncu.gd`,
          `sahne/dunya.tscn`, `project.godot`'un `[input]` bölümü. 10 `@export`
          (aralıklı ve gruplu), sekiz girdi eylemi, zemin + iki kapsül + kamera,
          180 kare koşuda SIFIR hata, `--headless --quit` 0.

## [ ] Işık yukarı bakıyor — sahip: cursor · **VERİLDİ 2026-09-24**

**ÖNCE:** `git merge main` — kabul ölçütü `araclar/kadraj.gd`'yi kullanıyor ve
o araç `main`'de. Birleştirmeden ölçüm yapılamaz.

DOSYA:    `sahne/dunya.tscn`, yalnızca `[node name="Isik"]` satırındaki transform
SORUN:    DirectionalLight3D'nin −Z'si YUKARI bakıyor. Ölçüldü:
          `X dönüşü +50° → ışığın gittiği yön (0.000, +0.766, -0.643)`
          Yukarı bakan ışık, yukarı bakan zemini aydınlatamaz. Sonuç: sahnede
          yönlü ışık katkısı SIFIR, her şey ortam ışığıyla düz duruyor.
          Kadraj ölçümü (1280×720, Metal, M2):
          | | kapsül üst | kapsül alt | zemin | gradyan |
          |---|---|---|---|---|
          | mevcut (+50°) | 92.1 | 92.1 | 47.6 | **0.0** |
          | −50° | 200.8 | 166.8 | 109.6 | 46.4 |
          Gölge sistemi suçlu DEĞİL: yukarı bakan ışığın gölge haritası her
          şeyi gölgede bıraktığı için öyle görünüyordu. Yön düzelince gölge
          de doğru çalışıyor (doğrulandı, gölge açıkken).
İSTENEN:  Işığın X dönüşü −50° olsun (−Z'nin Y bileşeni NEGATİF olmalı).
          §5.3 gereği transform'un yanına yorum: Godot'nun `Transform3D`
          serileştirmesi SATIR önceliklidir; ışığın yönü −Z SÜTUNUdur.
KABUL:    `godot --path . --script araclar/kadraj.gd` ile alınan kadrajda
          kapsülün dikey gradyanı > 30 ve ÜSTÜ altından PARLAK olacak
          (şu an üst 92.1 = alt 92.1, yani gradyan 0).
DOKUNMA:  `betik/sim/` `betik/ai/` `betik/veri/` `testler/` `araclar/` `belge/`
          `AGENTS.md`; `betik/cizim/oyuncu.gd` bu madde için gerekmiyor.

DOSYA:    `sahne/dunya.tscn` (yeni içerik), `betik/cizim/oyuncu.gd` (yeni),
          `project.godot` **yalnızca `[input]` bölümü**
SORUN:    Godot projesi boş. Oyun hissini ayarlayacak bir zemin yok; Faz 1'in
          davranış testleri gözle doğrulanamıyor.
İSTENEN:  Gri kutu sahnesi ve birinci şahıs kontrol.
          - Düz zemin (StaticBody3D + BoxShape), ~60×60 m, gri malzeme.
          - `CharacterBody3D` oyuncu: WASD yürüme, fare bakış, Shift koşma.
          - Göz yüksekliği 1.70 m. Yürüme ~2.0 m/s, koşma ~3.4 m/s.
          - Girdi eylemleri: `ileri geri sol sag kos etkiles ver cagir`
            (E = etkileş, F = ver, Q = çağır, Shift = koş).
          - **Bütün his sayıları `@export`** olsun: hız, ivme, fare
            hassasiyeti, kamera salınımı, göz yüksekliği. Kullanıcı bunları
            editörde oyun çalışırken ayarlayacak (AGENTS.md §6.2).
          - Sahnede iki gri kapsül dursun (oyuncu ve arkadaş yer tutucusu);
            arkadaşın kapsülü şimdilik hareketsiz.
KABUL:    `godot --path . ` ile oyun açılıyor, WASD+fare ile gezilebiliyor,
          konsolda sıfır hata. `godot --headless --path . --quit` hâlâ 0.
DOKUNMA:  `betik/sim/` `betik/ai/` `betik/veri/` `testler/` `belge/` `AGENTS.md`
          `project.godot`'un `[input]` dışındaki bölümleri.

---

## 5. ChatGPT kuyruğu

---

## [ ] CC0 kıyafet paketi araştırması — sahip: gpt · **GECE İŞİ 2026-09-25**

Karakter modeli (Quaternius Universal Base Characters) **iç çamaşırlı bir
temel gövde**. Hayatta kalma oyunu için kıyafet gerekiyor.

ŞART:     (1) CC0 ya da atıfla kullanılabilir — lisans SAYFADAN okunmuş olmalı,
          ikinci elden değil.
          (2) **Quaternius Universal rigine uyumlu** ya da rigsiz/gövdeye
          giydirilebilir olmalı. 65 kemik, UE adlandırması (`pelvis`,
          `spine_01..03`, `thigh_l`, `upperarm_l` …).
          (3) Görsel dil: doğal, kasvetli, yarı gerçekçi (K-044). Parlak,
          çizgi film ya da fantastik giysi OLMAZ — uçak kazasından çıkmış
          biri: yırtık gömlek, pantolon, çıplak ayak ya da tek ayakkabı.
İSTENEN:  En fazla 5 aday, her biri için tek satır: ad · URL · lisans ·
          format · üçgen sayısı · rig uyumu · neden uygun.
          **Lisansı belirsiz olanı listeye yazma.**

## [ ] CC0 mırıltı / nefes sesi araştırması — sahip: gpt · **GECE İŞİ**

Çağırma mekaniği (K-068) çalışıyor ama SESSİZ. Kullanıcı kararı:
*"kelime duyulmasın, karakterin boğuk mırıltısı duyulsun, yazı ekranda
görünsün"*. `varlik/ses/` altında 48 CC0 ses var, aralarında mırıltı yok.

ŞART:     CC0. İnsan sesi ama **kelime değil**: boğuk mırıltı, nefes, iç
          çekme, kısık "hey" benzeri. Erkek ve/veya nötr.
İSTENEN:  3–6 aday dosya, her biri için: ad · URL · lisans · süre · örnekleme
          hızı. Ayrıca ayrı bir liste: arkadaşın **nefes** sesleri (çöküşte
          canlı olduğunu göstermek için gerekiyor — panoda açık borç).

## [ ] Ada yerleşim taslağı — sahip: gpt · **GECE İŞİ, uzun**

Dilim şu an 60×60 m düz bir kutuda geçiyor. Ada ELLE tasarlanacak (§4:
prosedürel üretim YOK) ve **en az 300 m çap** olacak.

VERİLENLER (bunlar sabit, değiştirme):
- 6 gün, ~107 dakika. Günde ~20 dk: gündüz 13, alacakaranlık 2, gece 5.
- Zorunlu yerler: **enkaz** (kumsal, 1. gün), **açıklık + dere** (2. gün
  kamp), **kayalık kıyı + gelgit havuzları** (3. gün balık), **barınak**
  (kayanın arkası), **sal** (kıyı, 5. gün), **yiyecek noktaları** (uzak).
- Ateş ışığı yarıçapı 6 m; gece görüşü 5.4 m. Köpek ışığın dışında dolanır.
- Günde 4 odun + 2 yiyecek toplanabiliyor; toplama yürüyüş demek.
İSTENEN:  Tek sayfa metin: hangi yer nerede, aralarındaki YÜRÜME SÜRESİ
          (saniye, 1.6 m/s ile), ve her yerin hangi güne hizmet ettiği.
          Kroki gerekmez, mesafe tablosu yeter.
ÖLÇÜT:    Kamp ile dere arası ≤ 30 sn (su günde birkaç kez taşınıyor).
          Kamp ile uzak yiyecek arası 60–120 sn (kıtlığın bedeli yürüyüş).
          Kamp ile sal arası ≥ 120 sn (son yolculuk kısa olmamalı).

---

## [x] Arkadaşın animasyon durum makinesi — sahip: gpt (Sol-6) · **İNCELENDİ**

SONUÇ:    `belge/ANIMASYON-SPEKTI.md`. Üç bağlantı doğrulandı. Asıl mimari
          karar DOĞRU: dokuz hücre için dokuz durum kurulmuyor; güven →
          mesafe/yönelim/bakış, moral → tempo/duruş/duraklama. Root motion
          yok, gerekçesiyle. Bizim görmediğimiz bir riski yakalamış: dip
          moralde oturmak "düşük güven" diye okunabilir.
EKSİK:    (1) İhtiyaç bakışı yok — aç arkadaş yiyeceğe, susamış kaba bakmalı
          (K-056); bu olmadan oyuncu NEYİ vereceğini bilemez. (2) Çöküş
          ilerlemesi yok — `Oturmuş` ile `Ölüm` arasındaki iki günlük görünür
          vazgeçiş eksik (K-055/D1).
KARAR BEKLİYOR: gece algı yarıçapı 5,4 m, düşük güvende arkadaş 7–10 m'de →
          gece jestleri hiç kaydedilmiyor. Kasıtlı sertlik mi, kapan mı?

## [ ] Animasyon spektinin iki eksiği — sahip: gpt (Sol-6) · **VERİLDİ 2026-09-24**

DOSYA:    `belge/ANIMASYON-SPEKTI.md`'ye eklenecek iki bölüm (kod yok)
SORUN:    Spekt iki değişmez kuralı karşılamıyor. (1) Bakış hedefleri yalnızca
          "oyuncu" ve "çevre"; ihtiyaç bakışı yok — oyuncu NEYİ vereceğini
          bilemiyor (K-056). (2) `Oturmuş` ile `Ölüm` arasındaki iki günlük
          görünür vazgeçiş yok; doğrudan geçiş ölümü "kötü şans" gösterir
          (K-055/D1).
KABUL:    Her iki bölüm de davranış tablosuyla ve illüzyon kırıcılar listesiyle
          çelişmemeli; "mesaj jesti" üretmemeli.
DOKUNMA:  Kod dosyaları.

DOSYA:    **yeni** `belge/ANIMASYON-SPEKTI.md` (kod yok, tasarım belgesi)
SORUN:    Oyunun kabul kriteri "arkadaşın üç güven seviyesi EKRANDA ayırt
          edilebilsin". Elimizde Quaternius Universal Animation Library var
          (CC0, 120+ animasyon, humanoid rig, Godot'da test edilmiş) ama
          hangi animasyonun hangi güven×moral durumuna karşılık geldiği,
          geçişlerin ne kadar süreceği ve AnimationTree'nin nasıl kurulacağı
          hiç tasarlanmadı. Bu tasarlanmadan gövde koda bağlanamaz.
İSTENEN:  Spesifikasyon (aşağıdaki promptla verildi).
KABUL:    Her güven×moral hücresi için EKRANDA GÖRÜLEBİLİR bir karşılık;
          K-056'daki illüzyon kırıcıların her birine somut karşı önlem;
          3 dakikalık kayıtta seviyenin ayırt edilmesini sağlayacak üç
          gözlenebilir işaret.
DOKUNMA:  Depodaki hiçbir kod dosyası.

## [x] CC0 varlık araştırması — sahip: gpt · **ÖLÇÜLDÜ (Claude, 2026-09-24)**

SONUÇ:    `belge/VARLIK-KAYNAKLARI.md` yazıldı. 18 URL çağrıldı, 18'i yaşıyor;
          sayfa başlıkları eşleşiyor (yanlış sayfa yok); lisanslar sayfanın
          kendisinden okundu. Beş kategoride de ≥3 aday geldi — kabul ölçütü
          karşılandı.
DÜZELTME: (1) Kurt varlığı için GPL şüphem yanlıştı — sayfa çoklu lisans
          veriyor (CC0/GPL2/GPL3), ChatGPT haklıydı. (2) `Character: Dog`
          gerçekten CC-BY 3.0, atıf gerekir. (3) ChatGPT'nin atladığı asıl
          bulgu: Quaternius **Universal Animation Library** (CC0, 120+ anim,
          Base Characters ile AYNI rig, Godot'da test edilmiş) — Mixamo'ya
          gerek kalmıyor, retarget riski sıfır.
ÖNERİ:    Beş paketin hepsi Quaternius, hepsi CC0, hepsi aynı görsel dil →
          stil birliği riski kökünden kalkıyor. Kullanıcı onayı bekliyor.

## [ ] (arşiv) CC0 varlık araştırması — özgün madde

DOSYA:    **yeni dosya** `belge/VARLIK-KAYNAKLARI.md` (kod yok, yalnızca tablo)
SORUN:    Bütçe 0 TL, yalnızca CC0/ücretsiz varlık kullanılacak. Elde hiç 3B
          model yok. Stil birliği en büyük risk — farklı ellerden çıkmış
          varlıklar aynı dilde konuşmalı.
İSTENEN:  Aday varlıkların tablosu. Her satır: **ne · kaynak URL · lisans ·
          çokgen/çözünürlük · stil notu**. Aranan kategoriler:
          1. **İnsan gövdesi** — rigli, humanoid, stilize; yürüme/koşma/oturma/
             çökme animasyonlarıyla uyumlu (Mixamo'ya retarget edilebilir).
          2. **Ağaç ve çalı** — iğne yapraklı ve geniş yapraklı, stilize.
          3. **Kaya, kütük, dal** — kamp ve kıyı için.
          4. **Zemin dokusu** — kum, çakıl, orman zemini, çimen.
          5. **Yaban köpeği** — dört ayaklı, animasyonlu.
          Kaynaklar: Poly Haven · ambientCG · Quaternius · Kenney · Fab
          (CC0 filtresi) · OpenGameArt (lisansı tek tek bak) · Mixamo.
KABUL:    Her kategoride en az 3 aday; her satırda ÇALIŞAN URL ve AÇIK lisans
          adı. Lisansı belirsiz olan varlık tabloya **girmez**. En sonda tek
          paragraf: "stil birliği için hangi üçlü birlikte kullanılmalı".
DOKUNMA:  Depodaki hiçbir kod dosyası. Yalnızca bu tek belge.

---

## 6. Notlar

- Ölçüm (kare süresi, GPU) aynı anda tek ajan tarafından yapılır.
- `.scratch/` git'e girmez; geçici her şey oraya.
- Bir dosyayı değiştirmeden önce **diskten oku** — başka ajan değiştirmiş olabilir.
