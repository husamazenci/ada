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
| `sahne/` `betik/cizim/` | **Cursor** | Görsel, kamera, kontrol, oyun hissi |
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

### Şu an
- Faz 0 bitti: proje iskeleti, iki test, dokuz negatif kontrol, LFS, 48 CC0 ses.
- Tasarım gözden geçirmesi bitti (K-055, K-056): kapsam 6 gün/120 dk, zincir
  düzeltildi, moral modeli sayıya bağlandı, düşüş tablosu yazıldı, su ihtiyaç
  oldu, fiil listesi dört tuşa indi, insan hissi kural seviyesine çıktı.
- Sıradaki: **Faz 1 · çekirdek an** — saf simülasyon katmanı, penceresiz.

---

## 4. Cursor kuyruğu

## [x] Gri kutu: birinci şahıs kontrol ve sahne — sahip: cursor · **ÖLÇÜLDÜ (Claude)**

SONUÇ:    Kabul ölçütleri GEÇTİ. Şeride uyulmuş: yalnızca `betik/cizim/oyuncu.gd`,
          `sahne/dunya.tscn`, `project.godot`'un `[input]` bölümü. 10 `@export`
          (aralıklı ve gruplu), sekiz girdi eylemi, zemin + iki kapsül + kamera,
          180 kare koşuda SIFIR hata, `--headless --quit` 0.

## [ ] Işık yukarı bakıyor — sahip: cursor · ÖLÇÜLDÜ, TEK SATIR

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
