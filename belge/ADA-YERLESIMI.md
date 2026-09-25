# Ada yerleşimi

> **Taslak** · 2026-09-25 · Claude.
> ChatGPT'nin kuyruğundaki maddeydi; kullanıcının limiti bittiği için
> devralındı. **Sayılar tahmin değil, hesaplanmış** — üreten betik bu
> belgenin sonunda.

Ada **elle** tasarlanır, prosedürel üretilmez (AGENTS.md §4). İkinci denemede
tohumdan üretim bir hata ailesi doğurdu ve karşılığında bu oyunun ihtiyaç
duymadığı tekrar oynanabilirliği verdi. **Tek ada, her tepesi kasıtlı.**

Yürüme 2.0 m/s · koşu 3.4 m/s (`betik/cizim/oyuncu.gd`).
Gün 20 dakika. Kamp merkezde (0, 0); +X doğu, +Z güney.

---

## 1. Yerler

| Yer | Konum (m) | Kamptan | | Hangi gün |
|---|---|---|---|---|
| **KAMP** — açıklık | (0, 0) | — | | 2. günden itibaren |
| **DERE** | (18, −12) | 22 m | 11 sn | her gün, günde birkaç kez |
| **ODUN — yakın** | (−28, 15) | 32 m | 16 sn | her gece |
| **ODUN — doğu** | (22, 28) | 36 m | 18 sn | her gece |
| **ODUN — uzak** | (−44, −30) | 53 m | 27 sn | her gece |
| **ENKAZ** — kumsal | (−95, −120) | 153 m | 77 sn | 1. gün |
| **KAYALIK** — gelgit havuzları | (120, 75) | 142 m | 71 sn | 3. gün (balık) |
| **YİYECEK — kuzey** | (85, −95) | 127 m | 64 sn | her gün |
| **YİYECEK — batı** | (−130, 60) | 143 m | 72 sn | her gün |
| **SAL** — uzak kıyı | (−40, 255) | 258 m | 129 sn | 5–6. gün |

**Ada kabaca 370 m (doğu–batı) × 495 m (kuzey–güney).** §4'ün "en az 300 m
çap" şartını karşılıyor: ikinci denemede ada 120 m'ydi ve "ormanın içinde
olmak" hiç gerçekleşmedi.

---

## 2. Ölçütler ve denetim

| Ölçüt | Hedef | Ölçülen | |
|---|---|---|---|
| kamp ↔ dere | ≤ 60 m | **22 m** (11 sn) | ✓ |
| kamp ↔ en yakın odun | 30–80 m | **32 m** (16 sn) | ✓ |
| kamp ↔ en yakın yiyecek | 120–240 m | **127 m** (64 sn) | ✓ |
| kamp ↔ sal | ≥ 240 m | **258 m** (129 sn) | ✓ |
| enkaz ↔ kamp | ≤ 180 m | **153 m** (77 sn) | ✓ |
| kamp ↔ kayalık | ≤ 200 m | **142 m** (71 sn) | ✓ |

Gerekçeler: **su** günde birkaç kez taşınıyor, uzak olsa oyun su taşımaya
dönerdi. **Yiyecek** uzak, çünkü kıtlığın bedeli yürüyüş. **Sal** uzak,
çünkü son yolculuk kısa olmamalı. **Enkaz** yakın, çünkü 1. günden 2. güne
geçiş bir gece yürüyüşü olmamalı.

---

## 3. İki bulgu — yerleşim mekanikleri sınıyor

Yerleri koyarken asıl soru "güzel mi" değil, **var olan mekanikler bu
mesafelerde çalışıyor mu** idi. İkisi ölçüldü.

### a) Odun almaya gidince köpek uyarısına yetişiyorsun

Köpeğin uyarısı 42 sn (uluma + ışığın sınırında durma), saldırı penceresi
6 sn: toplam **48 saniyelik** tepki süresi.

| Yığın | Gidiş | Dönüş (yürüyerek) | Dönüş (koşarak) |
|---|---|---|---|
| yakın (32 m) | 16 sn | 14 sn ✓ | 8 sn ✓ |
| doğu (36 m) | 18 sn | 16 sn ✓ | 10 sn ✓ |
| uzak (53 m) | 27 sn | 25 sn ✓ | 15 sn ✓ |

**Üçünden de dönülebiliyor** — yani odun almak bir ölüm tuzağı değil.
Ama gerilim tam da burada: dönebiliyorsun, o hâlde **dönmemek bir seçim.**
Uyarıyı duyduğunda elinde yarım yığın odun var; dönersen ateş sönebilir
(0.10 ihmal), dönmezsen arkadaş yaralanır (0.20 ihmal + güven düşüşü).
İki ihmal arasında seçim yapıyorsun, ve ikisi de senin.

### b) "Bekle" sözü yalnızca KISA işler için tutulabilir

Sözün ömrü 96 saniye (`SOZ_SURESI_GUN = 0.08`).

| Nereye | Gidiş-dönüş | Söz tutulur mu |
|---|---|---|
| odun (53 m) | 53 sn | **tutulabilir** |
| yiyecek (127 m) | 127 sn | **TUTULAMAZ** |
| sal (258 m) | 258 sn | **TUTULAMAZ** |

Bu bir hata değil, **sözün anlamı**: "bekle" = *bir dakikalığına orada kal*,
uzun bir yolculuk için verilmiş bir taahhüt değil. Yiyecek toplamaya
giderken "bekle" dersen sözünü **kaçınılmaz olarak** bozarsın — ve 0.15
ihmal yazılır.

> **Açık soru (kullanıcıya):** bu kabul edilebilir mi? İki seçenek var:
> (1) olduğu gibi kalsın — "bekle" kısa iş sözüdür, uzun yola çıkmadan önce
> söylemek oyuncunun hatasıdır; (2) söz verilirken menzil ölçülsün ve uzun
> yola çıkacaksan söz hiç verilemesin. İkincisi daha bağışlayıcı ama oyunun
> "öğretmez, anlatır" kuralına aykırı: oyun sana sözün tutulamayacağını
> söylemiş olur.

---

## 4. Ateşin çemberi ve karanlık

Ateş ışığı 6 m yarıçapında. Gece görüşü 5.4 m. **En yakın odun yığını
32 m'de** — yani odun almak, ışığın çemberinden çıkıp **beş kat** uzağa
gitmek demek. Tasarımın "yakıt toplamak ışığın kenarına gitmek demektir"
cümlesi burada sayıya dönüşüyor.

Köpek ateşin çemberinin **sınırında** dolanır (ölçüldü: 6.00 m), içine
girmez. Sen odun almaya gittiğinde köpek hâlâ kampın etrafındadır — yani
tehlikede olan sen değil, **arkadaş**.

---

## 5. Henüz karar verilmemiş

- **Arazi yüksekliği.** Düz mü, tepeli mi? Tepe görüş mesafesini ve yürüme
  süresini değiştirir; yukarıdaki saniyeler **düz zemin** varsayıyor.
- **Barınak.** Kayanın arkasında, kampa çok yakın (≤ 15 m) olmalı — 3. gün
  kurulup 4. gün fırtınada sınanıyor.
- **Enkazın kapısı.** 1. gün açılmıyor (ateş başlatıcısı içeride). 2. gün
  açılışı nasıl oluyor, yazılmadı.
- **Yol yok.** Ada üzerinde patika olmamalı: yönlendirme dünyadan gelir,
  işaretten değil (§2 "oyun öğretmez").

---

## 6. Sayıları üreten betik

`araclar/ada-olcum.py` — konumları değiştirince tabloyu yeniden üretir ve
ölçütleri denetler. Bu belgedeki hiçbir sayı elle yazılmadı.
