# Karar Günlüğü

Her önemli karar ve her ilginç hata burada. Sebebi ve **nasıl bulunduğu**
ile birlikte — "ne yapıldı"yı git geçmişi zaten söylüyor; burası "neden" ve
"nereden biliyoruz" içindir.

Kayıt biçimi:

```
## K-NNN · YYYY-AA-GG · başlık
- Tür:     karar | hata | ölçüm
- Durum:   geçerli | öneri (onay bekliyor) | geçersiz (yerine K-NNN)
- Ne:
- Neden:
- Nasıl bulundu / ölçüldü:   (komut, dosya, çıktı)
- Sonuçları:
```

Yeni kayıt en alta eklenir. Eski kayıt silinmez; geçersiz kalırsa işaretlenir.

---

## K-001 · 2026-09-17 · Hedef donanım ölçüldü

- **Tür:** ölçüm
- **Durum:** geçerli
- **Nasıl ölçüldü:** `system_profiler SPHardwareDataType`,
  `system_profiler SPDisplaysDataType`, `sw_vers`, Chrome'un `Info.plist`
  dosyası, `node --version`, `npm --version`, `git --version`.
  (Seri numarası ve donanım kimlikleri bilerek yazılmadı.)

| Alan | Ölçülen değer |
|---|---|
| Model | MacBook Air — model tanımlayıcısı `Mac14,2` |
| Çip | Apple M2 |
| CPU | 8 çekirdek (4 performans + 4 verimlilik) |
| GPU | Apple M2, 8 çekirdek, entegre, Metal 3 |
| Bellek | 16 GB birleşik bellek (GPU ile paylaşımlı) |
| Ekran | Dahili Liquid Retina, 2560 × 1664, Retina |
| İşletim sistemi | macOS 15.6.1 (24G90) |
| Tarayıcı | Google Chrome 152.0.7977.83 |
| Node / npm | v24.18.0 (nvm) / 11.16.0 |
| git | 2.39.5 (Apple Git-154) |

**Ölçülemeyenler (tahmin edilmedi):**
- Ekran yenileme hızı `SPDisplaysDataType` çıktısında yok. 60 Hz varsayılıyor
  ama ölçülmedi; tarayıcıda `requestAnimationFrame` aralığıyla ölçülecek.
- `window.devicePixelRatio` Retina için 2 bekleniyor; tarayıcıda ölçülecek.
- Headless Chrome'un bu makinede GPU mu yazılım mı kullandığı ölçülmedi
  (bu görevde paket kurulmadı). Bkz. `ILK-DEGERLENDIRME.md` §C.5.

**Performans bütçesi için sonuçları:**
1. **Fansız kasa.** Uzun oturumda termal kısma olur. Kare süresi ölçümü
   soğuk makinede değil, ısınmadan sonra alınmalı (öneri: 2 dk ısınma + 60 s
   ölçüm) ve rapor güç kaynağını (pil / adaptör, düşük güç modu) yazmalı.
2. **Retina.** Tam ekran bir Chrome penceresinde çizim tamponu yaklaşık
   2900 × 1700 fiziksel pikseldir. Entegre GPU'da darboğaz büyük ihtimalle
   çizim çağrısı değil piksel doldurma olacak. Bütçe testi hangi çözünürlükte
   ve piksel oranında koştuğunu raporlamazsa sonucu anlamsızdır.
   Piksel oranı üst sınırı (ör. 1.5) **karar bekliyor**.
3. **rAF ekran yenilemesine kilitli.** Kare süresi rAF aralığından ölçülürse
   hep ~16.7 ms çıkar ve bütçe testi hiçbir şey ölçmez. Ölçüm yöntemi:
   `ILK-DEGERLENDIRME.md` §C.6.
4. **Birleşik bellek.** Doku belleği sistem belleğinden yer; doku bütçesi
   ileride ayrıca konmalı.
5. **Chrome kendini günceller.** Her ölçüm raporu Chrome sürümünü yazmalı;
   sürüm değişince eski ölçümle karşılaştırma işaretlenmeli.

---

## K-002 · 2026-09-17 · İz kuralı

- **Tür:** karar (tasarım — değişmez kural)
- **Durum:** geçerli (kullanıcı kararı)
- **Ne:** Adada daha önce bir insanın bulunduğunu **kesinleştiren** hiçbir iz
  yoktur. Tehdit takviminde 6. günden sonra ortaya çıkan izlerin kaynağı
  bilerek belirsiz kalır: hayvan mı, doğa mı, başka bir şey mi — oyuncu kesin
  karar veremez.
- **Neden:** Arkadaşın kimliğindeki belirsizlikle aynı ilke. Kesin bir insan
  izi (yazı, alet, işlenmiş kereste, ayakkabı izi) oyuna çözülecek bir gizem
  ekler; oyuncunun dikkati "yanımdaki kim, bana ne yapacak" sorusundan
  "burada kim yaşamış" sorusuna kayar. Anlam kurma işi arkadaştan bir
  bulmacaya geçer. Ayrıca "oyun hiçbir şey anlatmaz" kuralını dolaylı yoldan
  deler: kesin bir iz, bir hikâyenin ilk cümlesidir.
- **Nasıl sağlanacak (4.2 — inşa ile, sonradan kontrol ile değil):** Her iz
  saf veri modülünde tanımlanır; inşa sırasında şu değişmezler sağlanır,
  sağlanmazsa modül yüklenmez:
  - Her izin `olasiKaynaklar` listesinde en az iki kaynak vardır ve en az
    biri insan dışıdır (hayvan / doğa).
  - Yasaklı öğe sınıfları: yazı ve işaret, alet ve alet izi (düz kesik,
    çivi, düğüm), işlenmiş malzeme, ayakkabı izi, yapı, düzenli geometri
    (düz sıra, dik açı, eşit aralık).
  - İzlerin dizilişi insan-benzeri bir düzen kurmaz (ör. kesintisiz bir
    patika çizmez).
  - Negatif kontrol: bir ize yalnızca `insan` kaynağı verilir → modül
    yüklenirken hata vermelidir.
- **Kapsam dışı:** Uçak enkazı, oyuncunun ve arkadaşın kendi izleri —
  bunların kaynağı bilinir.
- **Açık nokta (karar kullanıcıda):** Arkadaş küsüp gittiğinde bıraktığı
  izler, 6+. gün izleriyle aynı görsel dili kullanabilir mi? Kullanırsa oyuncu
  kendi arkadaşının izini "başka biri" sanabilir. Bu güçlü bir an olabilir ama
  kuralı dolaylı yoldan zorlar.
- **Nasıl bulundu:** Kullanıcının önyükleme belgesinde, tehdit takvimiyle
  birlikte verildi.

---

## K-003 · 2026-09-17 · Birinci denemenin açılış testi yeşil görünüp hiçbir şey ölçmüyor olabilir

- **Tür:** hata (ders)
- **Durum:** geçerli — Ada araçları bu derse göre tasarlanıyor
- **Nasıl bulundu:** `~/Projects/yeni-oyun` salt okunur incelendi (hiçbir
  şey değiştirilmedi):
  - `tests/acilis-testi.mjs` playwright bulamazsa `ATLANDI` yazıp
    `process.exit(0)` ile çıkıyor — yani **başarı koduyla**.
  - Bugün bu makinede playwright yok: `yeni-oyun/node_modules` içinde
    yalnızca `three` ve `vite` var, `~/Library/Caches/ms-playwright` yok,
    global npm paketleri yalnızca `corepack` ve `npm`.
  - Sonuç: test bugün çalıştırılırsa çıkış kodu 0 döner ama hiçbir şey test
    etmez. Geçmişte başka bir yoldan (`PLAYWRIGHT_PATH`) çalıştırılıp
    çalıştırılmadığını **bilmiyorum**; yalnızca bugünkü durumu ölçtüm.
- **Aynı dosyada bulunan diğer sorunlar:**
  - "Gerçek düğmeye tıklama" `page.evaluate(() => d.click())` ile yapılıyor.
    DOM `click()` görünürlük, üstünü örten katman ve `pointer-events`
    denetimi yapmaz; oyuncunun tıklayamadığı bir düğmeyi test tıklayabilir.
  - `--use-gl=swiftshader` zorlanıyor: yazılım GPU. Kare süresi ve görsel
    ölçümler hedef makineyi temsil etmez.
  - Zararsız uyarı listesinde `/deprecated/i` gibi geniş kalıplar var; gerçek
    bir hatayı yutabilir.
  - Sabit 11 s bekleme: yavaş koşuda yanlış hata, hızlı koşuda boşa süre.
- **Ada için kural:** Bağımlılık yoksa araç `ÇALIŞTIRILAMADI` der ve 2 koduyla
  çıkar; "atlandı" diye bir sonuç yoktur. Tıklama Playwright locator'ı ile
  yapılır (görünürlük / üstü örtülme denetimi). Her rapor GPU'nun adını yazar
  ve beklenenle karşılaştırır. İzin verilen uyarılar kesin metinle, tarih ve
  gerekçeyle listelenir.

---

## K-004 · 2026-09-17 · Kurulum durumu ve git kimliği

- **Tür:** ölçüm
- **Durum:** geçerli — git kimliği bölümü geçersiz (yerine K-009)
- **Ne:**
  - `~/Projects/ada` oturum başladığında zaten vardı: içinde yalnızca `.git`;
    `main` ve `claude/kurulum` aynı boş commit'te (`4b969c8`, yazar
    `Claude <noreply@anthropic.com>`, 2026-09-17 14:38). İstenen başlangıç
    durumunun birebir aynısı olduğu için devam ettim. `.gitignore` yoktu,
    eklendi.
  - Makinede git kullanıcı kimliği (`user.name` / `user.email`) hiçbir
    düzeyde yapılandırılmamış; `GIT_AUTHOR_*` ortam değişkenleri de yok.
    Commit'ler ilk commit ile aynı kimlikle, komut başına `git -c` ile atıldı.
    Global ayar **değiştirilmedi**.
  - Depoda uzak sunucu (remote) yok.
- **Sonuçları:** Cursor commit atmadan önce bir kimlik gerekir. Karar
  kullanıcıda (bkz. `ILK-DEGERLENDIRME.md` karar listesi).

---

## K-005 · 2026-09-17 · Tasarım kararları (ilk değerlendirmeye cevaplar)

- **Tür:** karar (kullanıcı)
- **Durum:** geçerli — "Gidiş" satırındaki LLM sorusu K-010 ile kapandı
- **Nasıl alındı:** `ILK-DEGERLENDIRME.md` §D'deki sorulara kullanıcının
  cevabı. Kullanıcının sözü tırnak içinde; uygulama notu teknik liderin.

| Konu | Karar | Uygulama notu |
|---|---|---|
| Son | "Fırtına olsun ama oyun sonu gibi değil; onu geçtikten birkaç gün sonra tek kişilik sal olsun." | Fırtına ~8. gece, sal ~10. gün. Fırtına salı kıyıya getiren olay olur; sebep–sonuç anlatımsız kurulur. |
| Uzunluk | "4 saat gibi." | Öneri: 12 oyun günü × ~20 dk. |
| Konuşma | "Kelimesiz ama sesli; çok nadir cutscene halinde 1–2 kelime." | "Cutscene" oyuncunun kontrolünü almayan sahnelenmiş an olarak önerildi (OYUN-TASARIMI §5). Kelimelerin dili açık. |
| Güven / moral | Ayrı eksen, ayrı kanal — onaylandı. | Güven = mesafe ve yönelim; moral = tempo ve duruş. |
| Güveni kazanma | "Birkaç yolu olsa daha güzel olur." | İlke aynı (bedel). Dilime üç yol: açken yiyecek, tehlikeden çıkarmak, riskli işi üstlenmek. |
| Dilimde ses | Alınsın. | Tehdit yaklaşması + arkadaşın nefes, uyarı, acı sesleri. |
| Çok aç olunca | "Afallama efekti." | Görüş kenarı kararması yerine sersemleme. His ayarı Cursor'da; hareket tutması riskine karşı kısa ve seyrek. |
| Tehditler | Yaralayıp öldürebilir; domuz ve köpek; deniz ve hava da. | Köpek gece (dilimdeki tehdit), domuz gündüz ormanda, deniz, hava. Yaralanma iki durumlu (sağlam/yaralı); ölümden önce hep bir uyarı olsun diye. |
| Gidiş | "Emin değilim; en gerçekçi, insan hissettiren davranışlar olmalı; bu alanda AI olabilir diye düşünmüştüm." | **Açık.** Öneri OYUN-TASARIMI §4'te. "AI" ile LLM kastedildiyse değişmez kuralla çatışır; soruldu. |

---

## K-006 · 2026-09-17 · Değişmez kural değişti: kayıt

- **Tür:** karar (kullanıcı) — **değişmez kural değişikliği**
- **Durum:** geçerli
- **Eski:** "Kayıt sistemi yok."
- **Yeni:** "Elle kayıt ve yükleme yok. Tek yuvalı askıya alma var: oyun
  sürerken tek yuvaya sürekli yazılır, oyuncu kaldığı yerden devam eder; ölüm
  kesinleştiği an yuva silinir ve oyun biter."
- **Neden:** ~4 saatlik oyun tek oturuma sığmaz. Kapanan sekme ya da uyuyan Mac
  bir kazadır; kalıcı ölüm seçimlerin sonucu olmalı, kazaların değil.
  Kullanıcının sözü: "Tek kayıt alınsın ama ölünce biten bir oyun."
- **Teknik ayrıntı (kullanıcı bana bıraktı) — ve kendi önerimi düzelttim:**
  `ILK-DEGERLENDIRME.md` A.5'te "oyun açılınca yuva okunur ve hemen silinir"
  önermiştim. Bu yanlıştı: oyun açıldıktan sonra tarayıcı çökerse o oturumun
  tamamı kaybolur; kazayı affetme amacını boşa çıkarır. Doğrusu **sürekli
  yazmak** (öneri: 5 saniyede bir ve sayfadan çıkarken). Geri sarılabilecek en
  uzun süre yazma aralığıdır.
- **Bilinen açık (kabul edildi):** Tehlike anında Chrome'u zorla kapatan oyuncu
  en fazla ~5 s geri sarar. Ölüm "kesinleştiği an" (ölüm animasyonundan
  **önce**) yuva silindiği için ölümün kendisi geri alınamaz. Tarayıcı verisi
  silinirse yuva gider.
- **Mimariye sonucu:** Oyunun bütün durumu — arkadaşın hafızası dahil — ilk
  günden serileştirilebilir saf veri olmalı. Test: kaydet → yükle → aynı durum.
  Negatif kontrol: bir alanı serileştirmeden çıkar → test düşmeli.

---

## K-007 · 2026-09-17 · İz kuralı genişledi: arkadaşın izleri

- **Tür:** karar (kullanıcı)
- **Durum:** geçerli — K-002'deki açık noktayı kapatır
- **Ne:** Arkadaşın izleri (çekildikten sonra ve gece gizlice yiyecek aldığında)
  6+. gün izleriyle **aynı görsel dili** kullanır. Oyuncu "bu o mu, başka bir
  şey mi" ayırt edemez.
- **Neden:** Kullanıcının sözü: "Oyunun gerilim faktörü nasıl en tavan
  olacaksa." Bir yiyecek eksildiğinde "hayvan mı, o mu" sorusu arkadaşa duyulan
  güveni doğrudan sınar — gerilim ilişkinin tam merkezine düşer.
- **Sınır:** K-002'nin inşa değişmezleri arkadaşın izleri için de geçerlidir:
  ayakkabı izi yok, her izin en az iki olası kaynağı var ve en az biri insan
  dışı. İz hiçbir zaman "bir insan" demez; yalnızca "bir şey" der. Böylece
  "kesinleştiren iz yok" kuralı korunur.
- **Sonucu:** 6. günden önce görülen belirsiz bir iz yalnızca arkadaştan ya da
  hayvandan gelebilir; takvimin kendi izleri 6. günden sonra başlar.

---

## K-008 · 2026-09-17 · Teknik kararlar: araç kütüphanesi ve performans ölçümü

- **Tür:** karar (teknik lider — kullanıcı "kendin karar ver" dedi)
- **Durum:** geçerli
- **Araç kütüphanesi:** Playwright (ayrı test koşucusu olmadan, düz `node`
  betikleri) + makinede kurulu Google Chrome + `pngjs`. Sebep:
  `ILK-DEGERLENDIRME.md` §C.1 — en önemlisi, Playwright'ın tıklaması görünmeyen
  ya da üstü örtülü bir düğmeye tıklamayı reddeder; "gerçek düğmeye tıkla"
  şartının kendisi budur.
- **Çözünürlük:** Oyun ekranın piksel oranını en fazla **2** kullanır (Retina'nın
  tamamı). Bütçe oyunun gerçekte çalıştığı çözünürlükte ölçülür. İlk ölçümde
  bütçe aşılırsa **tek değişken olarak** önce 1.5 sınırı denenir.
  Sebep: `ILK-DEGERLENDIRME.md` A.4'teki okunabilirlik hesabı 2 üzerinden;
  ölçmeden düşürmek tahmin olur.
- **Kare süresi eşikleri:** ortalama ≤ 16.7 ms (kullanıcı kuralı) **ve** en yavaş
  %5'lik dilim (p95) ≤ 20 ms. Sebep: ortalama iyi olsa bile düzenli takılmalar
  hissedilir; ortalama bunu gizler.
- **Ölçüm sıklığı:** çizim çağrısı ve üçgen her yapıda (açılış testi,
  saniyeler). Kare süresi (~3 dk, görünür pencere) her kod dalı `main`'e
  birleşmeden önce ve istenince.

---

## K-009 · 2026-09-17 · Çalışma ortamı: worktree ve git kimliği

- **Tür:** karar (kullanıcı onayı + teknik lider) ve ölçüm
- **Durum:** geçerli
- **Worktree:** Kullanıcı onayıyla `git worktree add ../ada-cursor -b cursor/ilk
  main`. Claude `~/Projects/ada`, Cursor `~/Projects/ada-cursor`.
- **Git kimliği (kullanıcı "kendin karar ver" dedi):**
  - Yalnızca bu depo için; global ayara dokunulmadı.
  - `extensions.worktreeConfig` açıldı; kimlik çalışma ağacına göre değişir:
    - Depo varsayılanı (Cursor'un çalışma ağacı dahil):
      `Hüseyin Demir Altaş <mr.altas009@gmail.com>`. Ad, macOS hesabının
      `RealName` alanından okundu (`dscl`); tahmin edilmedi.
    - `~/Projects/ada` (Claude): `Claude <noreply@anthropic.com>`.
  - **Neden çalışma ağacına göre:** commit öneki (`claude:` / `cursor:`) unutulsa
    bile `git log --author` kimin yaptığını gösterir; Claude'un her commit'te
    `git -c` yazmasına gerek kalmaz.
  - **Neden Cursor kullanıcının kimliğiyle:** Cursor kullanıcının kendi
    editöründe, onun adına çalışan araçtır; ajanı `cursor:` öneki ayırır.
  - **Mahremiyet notu:** Depo bir gün herkese açık bir sunucuya gönderilirse
    e-posta commit'lerde görünür. Tek komutla değiştirilebilir.
- **Nasıl doğrulandı:** Her iki çalışma ağacında `git var GIT_AUTHOR_IDENT` —
  git'in bir sonraki commit'te **gerçekten kullanacağı** kimlik. (`git config
  user.name` yalnızca bir ayarı okur; `git log` ise geçmiş commit'i gösterir.
  İkisi de ölçmek istediğim şey değildi.)
- **İlginç hata — ölçüm yakaladı:** İlk ölçümde Cursor'un çalışma ağacı da
  `Claude <noreply@anthropic.com>` çıktı. `git config --show-origin` ile kaynak
  arandı: `git worktree add`, `extensions.worktreeConfig` açıkken **mevcut
  çalışma ağacının `config.worktree` dosyasını yeni ağaca kopyalıyor** (git
  2.39.5). Benim ağacımın Claude kimliği Cursor'unkine de geçmişti. Kopyadaki
  `user.name` / `user.email` silindi; yeniden ölçüldü:
  `ada → Claude <noreply@anthropic.com>`,
  `ada-cursor → Hüseyin Demir Altaş <mr.altas009@gmail.com>`.
  Ölçmeseydim Cursor'un bütün commit'leri Claude adına atılacaktı ve
  `git log --author` tam da korumak istediğim bilgiyi yanlış gösterecekti.
- **Kural (AGENTS.md §8):** Yeni bir worktree açıldığında kimlik
  `git var GIT_AUTHOR_IDENT` ile ölçülür.

---

## K-010 · 2026-09-17 · Dil modeli yok (teyit) · oyun dili seçilebilir

- **Tür:** karar (kullanıcı) + teknik ayrıntı (teknik lider)
- **Durum:** geçerli
- **Gidişte "AI":** Kullanıcı dil modeli kastetmediğini teyit etti. Değişmez
  kural aynen geçerli: arkadaş utility AI ile yapılır. Gidiş ve geri kazanma
  önerisi (`OYUN-TASARIMI.md` §4) öneri olarak durur; dilimden sonra ayrıntılanır.
- **Oyun dili:** Oyuncu dili seçer; şimdilik **Türkçe** ve **İngilizce**.
  Arkadaşın nadir sahnelenmiş anlardaki kelimeleri seçilen dildedir.
- **Neden kimlik kuralını delmiyor:** Kelimenin dili arkadaşın değil oyuncunun
  seçimidir; oyuncu dili değiştirince arkadaşın dili de değişir. Bu bir çeviri
  geleneğidir, ipucu değil. Kelimeler yine isim, geçmiş, yer ya da güven düzeyi
  söylemez.
- **Teknik ayrıntı (teknik lider):**
  - Varsayılan: tarayıcı dili Türkçeyse Türkçe, değilse İngilizce. Menüden
    değiştirilir. Seçim tarayıcıda hatırlanır — bu bir **ayardır**, oyun kaydı
    değildir; K-006'yı etkilemez.
  - Ekranda görünen her metin ve arkadaşın her kelimesi tek bir saf veri
    modülünden (`src/veri/metinler.js`) gelir; kodda görünür metin yazılmaz.
  - Test: her anahtar iki dilde de var ve boş değil. Negatif kontrol:
    İngilizceden bir anahtar silinir → test düşmeli.
  - Açılış testi menü düğmesinin adını **aynı modülden** okur ve iki dilde de
    koşar. Düğme metni elle teste yazılırsa, metin değişince test yanlış
    düğmeyi arar ya da hiç bulamaz.
- **Maliyet (sonraya):** Sahnelenmiş kelimeler için iki dilde, aynı sesle kayıt.
  Karar ses aşamasında (yol haritası 5).

---

## K-011 · 2026-09-17 · Headless Chrome bu makinede gerçek GPU'yu kullanıyor

- **Tür:** ölçüm
- **Durum:** geçerli — `ILK-DEGERLENDIRME.md` C.5'teki "ölçülmedi" notunun yerine. **3. sonuç GEÇERSİZ: yerine K-015.**
- **Nasıl ölçüldü:** `.scratch/gpu-sonda.mjs` — Playwright, `channel: 'chrome'`,
  `deviceScaleFactor: 2`; `WEBGL_debug_renderer_info` ile renderer adı, iki modda.
- **Sonuç (Chrome 152.0.7977.83):**

  | | Headless | Görünür |
  |---|---|---|
  | Renderer | ANGLE (Apple, ANGLE Metal Renderer: Apple M2) | aynı |
  | `MAX_TEXTURE_SIZE` | 16384 | 16384 |
  | `MAX_SAMPLES` | 4 | 4 |
  | `EXT_disjoint_timer_query_webgl2` | var | var |
  | `devicePixelRatio` | 2 | 2 |

- **Sonuçları:**
  1. C.5'teki en büyük risk (headless'ın yazılım çiziciye düşmesi) bu makinede
     yok. Yine de piksel karşılaştırması yapılacak: renderer adının aynı olması
     çıktının aynı olduğunu kanıtlamaz (birleştirme, renk profili).
  2. GPU zamanlama eklentisi var → kare süresinde GPU süresi doğrudan ölçülebilir.
  3. **Headless'ta rAF saniyede ~30 kare** (açılış testi: 5 s'de 149–150 kare).
     Kare süresi headless'ta ölçülemez; C.6'daki "yalnızca görünür mod" kararı
     ölçümle doğrulandı.

---

## K-012 · 2026-09-17 · Açılış testi, uyuyan makinede oyunu suçladı

- **Tür:** hata
- **Durum:** düzeltildi
- **Ne oldu:** Negatif kontrol koşusunda sabotajsız kopya düştü:
  `HATA oyun saati ilerledi (3.73 s / gerçek 567.70 s)`; koşu 9 dk 30 s sürdü.
- **Nasıl bulundu:** Oyunu suçlamadan önce `pmset -g log` okundu:
  `19:56:00 Entering Sleep state due to 'Clamshell Sleep' … Using Batt (Charge:17%)`,
  `20:05:24 Wake`. Kapak kapanmış, makine uyumuştu.
- **Neden hata:** Test, ölçüm koşulunun bozulduğunu değil oyunun bozulduğunu
  söyledi (AGENTS.md §5.8). Bir sonraki okuyucu oyunda olmayan bir saat hatasını
  arayacaktı.
- **Düzeltme:** 5 s'lik oynama 15 s'yi aşarsa test **2 (ÇALIŞTIRILAMADI)** ile
  "ölçüm geçersiz" der. Negatif kontrol `olcum-suresi-bozuk` uykuyu uzun bir
  beklemeyle taklit eder ve 2 bekler.
- **Aynı koşuda çalıştığı görülen korumalar:**
  - Sabotaj koşucusu `ekranda-sayi` sabotajında "aranan metin 2 kez bulundu"
    diyerek durdu; sabotaj yanlış satıra sessizce eklenmedi (§5.10).
  - Koşucunun kendisi sınandı: zararsız bir yorum değişikliği verildi → `KAÇTI —
    TEST BİR ŞEY ÖLÇMÜYOR`, çıkış 1. Koşucu gerçekten ölçüyor.
- **Ders:** Uzun ölçümlerde kapak açık ve şarj takılı olmalı.

---

## K-013 · 2026-09-17 · bak.mjs ölçümüne yapı damgası karışıyordu

- **Tür:** hata (benim) + ölçüm doğrulaması
- **Durum:** düzeltildi
- **Ne oldu:** İlk `bak.mjs` görüntüleri Playwright'ın `locator('canvas').screenshot()`
  yöntemiyle alınıyordu ve kodda "HUD ve yapı damgası parlaklığa karışmasın diye
  yalnızca canvas alınır" yazıyordu. Bu iddia **yanlıştı**: öğe görüntüsü
  canvas'ın üstündeki HTML katmanlarını da alır.
- **Nasıl bulundu:** Görsel iddiadan önce görüntüye bakıldı (AGENTS.md §7):
  `malzeme-gunduz.png`'nin sol alt köşesinde damga yazısı görüldü. Sayıyla
  doğrulandı — sol alt 600×60 piksel bölgesinde en parlak luma:
  eski **171.7** (yazı), yeni **103.7** (yalnızca gökyüzü).
- **Düzeltme:** Tampon oyunun içinden okunuyor: geliştirme sunucusunda
  `__ada.gelistirici.tamponuYakala()` → `render` ile aynı görevde `toDataURL`.
  Ölçülen şey artık tanım gereği çizim tamponu.
- **Etkisi:** Bu sahnede küçük (genel luma 101.89 → 101.87; karo ölçümleri
  değişmedi, damga karoların üstünde değildi). Ama HUD'lu bir sahnede ya da
  karanlık bir gece kadrajında fark büyürdü.
- **Ölçümün kendisi bağımsız yoldan doğrulandı:**
  - Parlaklık hesabı: düz arka plan renklerinin elle hesaplanan luması ile ölçülen
    luma — `#5d6a70` 103.7 / 104 · `#2e3238` 49.6 / 50 · `#07090b` 8.7 / 9.
    Verideki renk ekrana dönüşümsüz ulaşıyor.
  - Sayaçlar: malzeme sahnesi 12 çağrı = 4 malzeme × 3 ağ; 136 üçgen =
    4 × (plaka 2 + ikosahedron 20 + küp 12). Oyuncu kadrajında 4 çağrı / 84 üçgen:
    kameranın arkasındaki küp çizilmiyor.
- **İlk ölçümler (yer tutucu ışıkla, karar değil):** gündüz önayarında referans
  kartları luma — beyaz 125.8, %18 gri 60.0, siyah 14.2.

---

## K-014 · 2026-09-17 · Kare süresi: bayraklar çalışıyor, ilk öz denetimim yanlış sayfayı ölçtü

- **Tür:** hata (benim) + ölçüm + K-011 düzeltmesi
- **Durum:** düzeltildi; bir ölçüm şarjda tekrarlanacak
- **Ne oldu:** `kare-suresi.mjs`'in öz denetimi, ekran kilidini kaldıran bayraklarla
  açılmış Chrome'da **boş bir `<canvas>` sayfasında** 58.6 kare/s ölçtü ve
  "bayraklar etkisiz" dedi.
- **Nasıl bulundu:** Bayrakları suçlamadan önce `.scratch/vsync-sonda.mjs` ile her
  karede WebGL çizen bir sayfa ölçüldü (görünür Chrome, pil %12):

  | Bayraklar | Kare/s |
  |---|---|
  | yok | 30.3 |
  | `--disable-gpu-vsync --disable-frame-rate-limit` | 1854.3 |
  | aynısı + `--disable-features=UseSkiaRenderer` | 1829.2 |

  Bayraklar çalışıyor. Hiçbir şey çizmeyen sayfada tarayıcı yeni kare üretmediği
  için rAF ekran hızında kalıyordu. Ölçtüğüm şey bayrak değil, sayfanın boşluğuydu.
- **Düzeltme:** Öz denetim sayfası her karede çizer; eşik ≥ 200 kare/s. Sonraki
  koşuda 860 kare/s.
- **Negatif kontroller:** bayraklar kaldırılınca 2 "bayraklar etkisiz"; oyuna
  25 ms yapay yük eklenince 1 (ortalama ve p95 bütçe dışı).
- **İlk kare süresi (yer tutucu sahne — geçerli bütçe ölçümü DEĞİL: kısa protokol
  5 + 10 s, pilde %12):** 2880×1800 tampon, 4 çağrı, 84 üçgen · ortalama 2.7 ms ·
  p50 2.4 · p95 3.6 · p99 3.7 · en kötü 4.9 ms.
- **K-011 düzeltmesi:** Bayraksız GÖRÜNÜR Chrome da 30.3 kare/s verdi. Demek ki
  K-011'deki "headless'ta rAF ~30 kare/s" sonucu headless'a özgü olmayabilir. İki
  gözlem de pil %12–17 iken yapıldı. Chrome'un pil tasarrufu modu kare hızını
  30'a indirir; bu açıklama **muhtemel ama doğrulanmadı**. Şarjda yeniden
  ölçülene kadar K-011'in 3. sonucu geçersiz sayılır. Kare süresi aracı bundan
  etkilenmez: zaten görünür modda ve bayraklarla ölçüyor.

---

## K-015 · 2026-09-17 · Şarjda ölçüm: 30 kare/s pil tasarrufundandı, headless'tan değil

- **Tür:** ölçüm — K-011'in 3. sonucunu ve K-014'teki şüpheyi kapatır
- **Durum:** geçerli
- **Nasıl ölçüldü:** `.scratch/pil-sondasi.mjs` — her karede WebGL çizen sayfa,
  `deviceScaleFactor: 2`, dört kombinasyon. Şarj takılı (pil %13, şarj oluyor).

  | Mod | Bayraksız | `--disable-gpu-vsync --disable-frame-rate-limit` |
  |---|---|---|
  | headless | 60.2 kare/s | 1811.4 kare/s |
  | görünür | 60.4 kare/s | 1689.9 kare/s |

- **Sonuç:** Pilde ölçülen ~30 kare/s (K-011 ve K-014) **headless'a özgü
  değildi**; görünür modda da 30 çıkmıştı. Şarjda ikisi de ekran hızında (60).
  Sebep Chrome'un düşük pilde kare hızını yarıya indirmesi. K-011'in
  "headless'ta rAF ~30" sonucu **yanlıştı**, düzeltildi.
- **Yan sonuç:** Headless de bayraklarla kilitsiz ölçülebiliyor (1811 kare/s).
  Kare süresi yine GÖRÜNÜR modda ölçülüyor: oyuncunun gördüğü yol ekrana giden
  yoldur. Ama gerekirse headless de bir seçenek — ve bu bir ölçüm, tahmin değil.
- **Ders:** Ölçüm koşulu (güç kaynağı) raporda yazılmasa bu iki gözlem sessizce
  "headless yavaştır" gibi kalıcı ve yanlış bir kurala dönüşecekti.

---

## K-016 · 2026-09-17 · Negatif kontrol koşucusu "ölçüm yapılmadı" ile "sabotaj kaçtı"yı ayırt edemiyordu

- **Tür:** hata (benim)
- **Durum:** düzeltildi
- **Ne oldu:** Şarj takıldıktan sonra bütün negatif kontroller koşuldu; kare
  süresi aracının iki sabotajı **KAÇTI** (yani "test bir şey ölçmüyor") olarak
  raporlandı. Aynı iki sabotaj bir saat önce pilde YAKALANMIŞTI.
- **Nasıl bulundu:** Koşucuya, kaçan sabotajın çıktısını da basması eklendi
  (önce yalnızca YANLIŞ durumunda basıyordu). Çıktı şunu gösterdi:
  `ÇALIŞTIRILAMADI — düşük güç modu açık`. Pil kritik seviyeye inince macOS
  düşük güç modunu kendiliğinden açmış; kare süresi aracı ölçmeyi doğru şekilde
  reddetmiş (kod 2). Temiz koşu da kısa protokol yüzünden 2 döndüğü için koşucu
  ikisini aynı saymış.
- **Asıl kusur:** Temiz koşunun yalnızca çıkış KODUNA bakmak yetmiyor. Hiç ölçüm
  yapmamış bir temiz koşu "anlamlı" ilan edilince, ondan sonraki her sabotaj
  sonucu anlamsızdı. Bu, 5.8'in tam örneği: ölçtüğümü sandığım şey (sabotaj
  yakalanıyor mu) ölçtüğüm şey değildi (araç hiç çalışmadı).
- **Düzeltme:** Sabotaj modülleri `TEMIZ_BEKLENEN_SATIRLAR` bildirir; temiz koşu
  bu satırları basmadıysa koşucu **2 ile durur** ve "sabotajsız kopyada ölçüm
  yapmamış" der. Kare süresi için beklenen satırlar öz denetim ve oyun ölçümü.
- **Kalan iş:** Düşük güç modu kapatılınca kare süresi sabotajları ve resmi
  ölçüm yeniden koşulacak. (Pildeki koşuda ikisi de yakalanmıştı: kod 2
  "bayraklar etkisiz" ve kod 1 "ortalama kare süresi bütçede" düştü.)

---

## K-017 · 2026-09-17 · Resmi kare süresi taban çizgisi (yer tutucu sahne)

- **Tür:** ölçüm
- **Durum:** geçerli — bundan sonraki ölçümler bununla karşılaştırılır
- **Koşullar:** şarjda · düşük güç modu kapalı · 120 s ısınma + 60 s ölçüm ·
  görünür Chrome 152.0.7977.83, ekran kilidi kapatan bayraklarla · öz denetim
  865 kare/s (bayraklar etkili) · yapı `b7f69d6` / özet `bf701145`.
- **Sahne:** YER TUTUCU — düz açıklık + 4 referans küpü. 2880×1800 çizim
  tamponu, 4 çizim çağrısı, 84 üçgen.

| Ölçüt | Değer | Bütçe |
|---|---|---|
| Kare sayısı | 22 465 (60 s) | — |
| Ortalama | **2.67 ms** (374 kare/s) | ≤ 16.7 ms |
| p50 | 2.4 ms | — |
| p95 | **3.5 ms** | ≤ 20 ms |
| p99 | 3.6 ms | — |
| En kötü | 12.3 ms | — |

- **Ne anlama gelir:** Bütçede geniş pay var **ama sahne neredeyse boş.** Bu sayı
  bir başarı değil, taban çizgisi: dilim içeriği (ateş, arkadaş, tehdit, gece
  ışığı) geldikçe bu ölçüm tekrarlanacak ve payın nereye gittiği görülecek.
  Fansız kasada 3 dakikalık koşuda en kötü kare 12.3 ms — henüz termal kısma
  belirtisi yok.
- **Sabotajlar (aynı koşulda):** `vsync-bayraklari-yok` → 2 "bayraklar etkisiz";
  `agir-kare` (25 ms yapay yük) → 1 "ortalama ve p95 bütçe dışı". Yani bu
  ölçüm gerçekten ölçüyor (K-016'daki kör noktadan sonra yeniden doğrulandı).
- **K-015 bağımsız doğrulaması:** Cursor kendi çalışma ağacında açılış testini
  koştu: headless, şarjda, 5 saniyede **301 kare** (60 kare/s). Pildeki koşuda
  149 kareydi (30 kare/s). Farklı ağaç, farklı süreç, aynı sonuç — 30 kare/s'nin
  sebebi pil tasarrufuydu.

---

## K-018 · 2026-09-17 · Dilimin arkadaş AI'ı: ölçümle bulunan beş hata

- **Tür:** karar + hata (benim) + ölçüm
- **Durum:** geçerli
- **Ne yapıldı:** Dikey dilimin saf katmanları: `src/veri/` (zaman, açlık, ateş
  ve ışık yarıçapı, güven/moral/arkadaş/tehdit ayarları), `src/sim/` (dünya
  durumu, eylemler, tehdit, tohumlu rastgele) ve `src/ai/` (algı, güven, moral,
  ihtiyaçlar, utility karar). Üçü de THREE ve DOM içermez; `tests/arkadas-senaryo.mjs`
  geceyi tarayıcısız, 0.2 saniyede oynatır.
- **Testler iç değere değil GÖZLEME bakar:** mesafe, oyuncuya yönelme, tempo,
  oturma, çağrıya yaklaşma süresi. Güven ve moral SAYILARI hiçbir kontrolde
  ölçüt değil — ekranda da gösterilmeyecekleri için.

**Ölçülen değerler (tohum sabit, 1/30 s adım):**

| Ölçüt | Yüksek güven | Orta | Düşük |
|---|---|---|---|
| Medyan mesafe | 3.49 m | 7.03 m | 13.64 m (ateşin karşı tarafı %100) |
| Göz teması oranı | 0.96 | 0.20 | 0 |
| Çağrıya yaklaşma | 0.87 s | 4.77 s | gelmiyor |

- Bedelli verme: iki verme **orta → yüksek** (+0.375; bedeller 0.58 ve 0.67).
- Tokken verme: bedel 0.07 → ucuz jest, değişim 0.
- İhanet: aç arkadaşın gözü önünde iki lokma **orta → düşük** (olay başına −0.176).
- Çekilme: eşik altında 60 s + çıkışa yürüme = 75 s; sonra beş eylemin hepsi
  denendi, geri dönmedi; güven tavanı 0.7'ye indi.
- Moral: baskı altında (aç + karanlıkta) 227 s'de umursamazlık eşiğinin altına;
  ölçülen hız 0.00220/s = veri dosyasındaki oranların toplamı. Oturma 168 s'de,
  yani umursamazlıktan önce.
- Ölüm adilliği: müdahale penceresi **24.1 s** (şart ≥ 20 s), ölüm ikinci
  ısırmada, oyuncu yanına gidince arkadaş hayatta kaldı ve bu bedelli davranış
  sayıldı (+0.18).
- 12 sabotajın hepsi yakalandı.

**Ölçümün yakaladığı beş hata:**

1. **Arkadaş yiyeceğin yarısını ilk on saniyede yiyordu.** Kendi yeme eşiği
   0.4'tü; bir birim yiyip doymak yerine üst üste yiyordu. Kıtlık bitince
   oyuncunun "açken verme" jestine yiyecek kalmıyor, arkadaşın açlık baskısı da
   yok oluyordu — dilimin tezi sessizce zayıflıyordu. Eşik 0.55 ve "bir birim
   doyurmalı" inşa değişmezi eklendi.
2. **Tok oyuncu güven kazanabiliyordu (+0.05).** Arkadaşın tokluk tahmini
   geride kaldığı için "belki açtır" sayıyordu; oyuncu görüş alanı dışında
   kalıp tahmini belirsiz tutarak tok tok güven toplayabilirdi. Verme artık bir
   YAKIN GÖZLEM anı: arkadaş yiyeceği alırken tahminini keskinleştiriyor.
   Sömürü yolu kapandı (bedel 0.17 → 0.07).
3. **Koşul adları ile oran adları ayrıydı** (`ac`/`aclik`, `karanlikta`/`karanlik`).
   Test beklenen düşüş hızını oran tablosundan okurken anahtarları bulamadı ve
   "beklenen 0.00000/s" dedi. Tek sözlüğe indirildi (AGENTS.md §5.3).
4. **Çağrı reddi iki yerde denetleniyordu.** Negatif kontrol sabotajı biri
   bozulunca öteki tuttuğu için işlevsiz kaldı ve test "bir şey ölçmüyor"
   göründü. Yedek denetim kaldırıldı; red artık tek kaynakta.
5. **İki kez "ölçtüğüm şey ölçmek istediğim şey değildi" (§5.8):** (a) ihanet
   senaryosunda arkadaş yığına oyuncudan önce varıp yiyor, açlığı azalıyor ve
   ihanetin ağırlığı ölçülemiyordu; (b) moral düşüşü senaryosunda arkadaş
   gecenin ortasında tehdit tarafından öldürülüyor ve moral ölümle donuyordu —
   senaryo düşüş hızını değil ölümü ölçüyordu. İkisi de kurulum düzeltilerek
   ayrıştırıldı.

**Ayrıca:** "çağrıya gelmez" kontrolü ilk halinde oyunun iç kaydını (`yanitSaatS`)
okuyordu; artık oyuncunun gördüğü şeyi ölçüyor (mesafe kapanıyor mu).

---

## K-019 · 2026-09-17 · Kare süresi ölçümü atlandı — ama tahminle değil, kanıtla

- **Tür:** karar (ölçüm koşulu)
- **Durum:** geçerli; ölçüm çizim dalında yapılacak
- **Ne oldu:** `claude/dilim-ai` dalı `main`'e birleşmeden önce kural gereği
  (K-008) kare süresi ölçülecekti. Makine pile geçmiş ve macOS düşük güç modunu
  yeniden açmıştı; araç ölçümü reddetti (doğru davranış).
- **Karar:** Ölçüm atlandı, çünkü bu dal kare süresini DEĞİŞTİREMEZ. Bu bir
  tahmin değil, ölçülmüş bir olgu: `src/ana.js`'ten başlayan modül ağacı
  (19 dosya) çıkarıldı ve içinde `src/sim/` ya da `src/ai/` YOK. Yeni katmanlar
  yalnızca testlerin içe aktardığı saf mantık; oyun döngüsü onlara hiç
  dokunmuyor. K-017'deki taban çizgisi geçerli kalıyor.
- **Ne zaman ölçülecek:** Çizim dalında (adım 2), çünkü simülasyonu oyun
  döngüsüne bağlayan ve ekrana arkadaş, ateş, tehdit çizen iş kare süresini
  gerçekten değiştirebilir. O ölçüm şarj takılı ve düşük güç modu kapalıyken
  yapılacak.

---

## K-020 · 2026-09-18 · Gece okunabilirliği: "şiddeti artır" işe yaramadı, çünkü renkler siyahtı

- **Tür:** hata (benim) + karar (gece ışığı) + ölçüm
- **Durum:** geçerli
- **Bağlam:** Dilimin çizimi kurulduktan sonra ilk gece kadrajları alındı. Ölçüm
  yeşildi ama **görüntüye bakınca** üç şey yanlıştı (AGENTS.md §7: görsel iddia
  öncesi render al ve bak):
  1. Yüksek güvenli arkadaş oyuncuya **sırtı dönük** duruyordu. Yönelim güvenin
     ana kanalı; kadraj verisinde gövde yönü hiç ayarlanmıyordu. `arkadasYonu`
     ('oyuncuya' | 'yan' | 'uzaga') veriye eklendi ve güven bandına bağlandı.
  2. Ateş tek büyük koniydi — "trafik konisi" gibi. Üç ince, farklı fazda
     titreyen koniye çevrildi; yükseklik gerçek kamp ateşi ölçeğine (0.35–0.55 m)
     indirildi (öncesi 0.9 m, insan boyunun yarısı).
  3. Arkadaş oyuncuya dönünce **yüzü karanlıkta kaldı**: tek ışık ateş ve o
     arkasındaydı. Baş luması 4.8, çevresiyle kontrastı 0.8.
- **Asıl hata (ölçümle bulundu):** Gece yarım küre ışığının şiddetini 0.06 → 0.25
  yapmak parlaklığı HİÇ değiştirmedi (25.49 → 25.55). Şiddeti 6'ya (24 kat)
  çıkaran bir sonda baş lumasını ancak 4.8 → 11.2'ye taşıdı. Sebep ayar değil
  **renkti**: yarım kürenin gök rengi `#1c2330`, yer rengi `#050505` — şiddet
  sıfıra yakın bir şeyi çarpıyordu. Bu, birinci denemedeki "renk hiç etki
  etmiyor" hatasının kardeşi (AGENTS.md §5.7).
- **Karar:** Ay ışığı artık renkle birlikte tanımlı (`#4e6180`, şiddet 0.55) ve
  **oyuncunun arkasından** (güneyden) vuruyor; oyuncuya dönen bir yüz ışık alır.
  Oyuncunun gördüğü gökyüzü rengi ayrı bir değer olduğu için gece karanlık
  kalıyor: kadraj ortalama luması 17–28, en karanlık %5 dilim 9.
- **Ölçüm aracı da düzeltildi:** Okunabilirlik tek vekil ölçüte bakıyordu (başın
  çevresiyle kontrastı) ve yakında OTURAN arkadaşı "okunmuyor" saymıştı — başı
  ateşin aydınlattığı zeminle aynı parlaklığa denk gelmişti, oysa duruş ve
  ışıldayan gözler ekranda apaçıktı. Artık iki kanal var ve biri yeterli:
  silüet kontrastı (≥ 5 luma) **ya da** göz parıltısı (≥ 12 luma).
- **Dokuz hücrenin ölçümü (gece, ateş ışığı):** hepsi geçti. Yüksek güvende
  gözler taşıyor (parıltı 118–135, silüet 1.8–6.7), düşük güvende silüet
  taşıyor (16.5–19.1, parıltı 9.8–11.3 — arkadaş sırtı dönük olduğu için gözler
  görünmüyor). Baş yüksekliği 25–124 piksel (alt sınır 20).
- **Ayrıca yakalanan iki hata:** (a) açılış testi `saatOyunS` alanını okuyordu,
  oyun `saatS` diyor → `NaN` (yine adlandırma kayması, K-018 #3 ile aynı aile);
  (b) oyuncu oyuna ateşe **sırtı dönük** başlıyordu (yaw = π yazmıştım) —
  çizim çağrısı 7'ye düşmüştü ve sayı hatayı gösterdi.

---

## K-021 · 2026-09-18 · "Okunuyor mu" sorusunu dürüst ölçmek: vekil ölçütlerden farka

- **Tür:** hata (benim, üç tur) + karar (ölçüm yöntemi)
- **Durum:** geçerli
- **Soru:** Davranış tablosunun dokuz hücresi gece ekranda ayırt edilebiliyor mu?
  Kabul kriteri bu; ölçmek için bir sayı gerekiyordu.
- **Üç yanlış vekil ölçüt, üçü de ölçümle çürütüldü:**
  1. **Başın çevresiyle kontrastı.** Yakında OTURAN arkadaşı "okunmuyor" saydı
     (kontrast 1.78): başı, ateşin aydınlattığı zeminle aynı parlaklığa denk
     gelmişti. Görüntüye bakınca duruş ve gözler apaçık okunuyordu.
  2. **Gövdenin çevresiyle ortalama kontrastı.** 8 m'de oturan figürü 3.7 ile
     sınırın altında bıraktı; görüntüde silüetin sağ kenarı ışık alıyordu ve
     figür rahatça okunuyordu.
  3. **Kenar ışığı (gövde kutusundaki en parlak nokta − çevre).** 104–152 gibi
     değerler verdi ama figürle ilgisi yoktu: gövde dikdörtgeni çoğunlukla arka
     plan pikseli içerdiği için ateşin aydınlattığı ZEMİNİ ölçüyordu. Ay ışığını
     söndüren sabotaj bu yüzden kaçtı.
- **Dürüst ölçüm:** Arkadaş **gizlenip aynı kare yeniden çiziliyor** ve gövde
  bölgesindeki piksel farkı ölçülüyor. "Görünür olmak" tam olarak bu: ekranı
  değiştirmek. Ölçülen (gece, dokuz hücre): değişen piksel **%21.6–70.4**,
  ortalama fark 5.4–16.8. Eşik %5.
- **Göz teması ayrı ölçülüyor**, çünkü davranış tablosunda adı geçen bir
  davranış: gözlerin ekran dikdörtgenindeki en parlak piksel ile başın
  ortalaması arasındaki fark (ölçülen 118–135, eşik 20). Yalnızca göz temasının
  AÇIK olduğu kadrajlarda denetlenir; düşük güvende gözlerin görünmemesi doğru
  davranıştır.
- **Bir adlandırma da düzeltildi:** "göz parıltısı" diye ölçtüğüm şey aslında
  başın İÇ kontrastıydı (ışıklı/gölgeli yüzler). Gözleri karartan bir sabotaj bu
  yüzden kaçmıştı — ölçüm adıyla ölçtüğü şey uyuşmuyordu.
- **Negatif kontroller sayesinde bulunan iki hatam daha:** (a) `bak.mjs`'de blok
  değiştirirken **malzeme denetimlerini silmişim** — 'renk-ekrana-ulasmiyor' ve
  'karo-kadraj-disinda' sabotajları kaçtı ve bunu söyledi; (b) bütçe sabotajı
  artık içe aktarılmayan bir sembolü çağırıyordu, oyun çöküyordu ve test YANLIŞ
  sebeple düşüyordu (kod 1 ama beklenen satır yok — koşucu "yanlış biçimde
  düştü" dedi).
- **Ay ışığı kararı yerinde kalıyor** ama gerekçesi düzeltildi: figür ateş
  ışığıyla da görünüyordu; ay ışığı YÜZÜN okunması için eklendi (oyuncuya dönen
  bir yüz ateşe sırtını çeviriyor). Bunu "okunabilirlik şartı" diye sunmak
  ölçümün söylemediği bir şeyi söylemek olurdu.

---

## K-022 · 2026-09-18 · Çizim dalı birleştirildi; resmi kare süresi ölçümü BORÇ

- **Tür:** karar (ölçüm koşulu) + ölçüm
- **Durum:** borç kapandı (K-025)
- **Durum tespiti:** `claude/dilim-cizim` dalı simülasyonu ekrana bağlıyor, yani
  kare süresini gerçekten değiştirebilir (K-019'un aksine). Kural (K-008) resmi
  ölçümü şarjda ister. Kullanıcı şarjı taktığını söyledi ama makine ısrarla
  "adaptör bağlı değil" diyor ve pil düşmeye devam etti (%51 → %50 → %46).
  Araç ölçmeyi reddetti — doğru davranış.
- **Elimizdeki ölçüm (pilde, düşük güç modu KAPALI, resmi protokol 120 + 60 s):**
  yapı `d72fed5+`, 2880×1800, **42 çizim çağrısı**, 532 üçgen ·
  ortalama **2.9 ms** · p50 2.4 · p95 **3.8 ms** · p99 5.9 · en kötü 22.5 ms ·
  öz denetim 836 kare/s (bayraklar etkili).
- **Karşılaştırma:** Yer tutucu sahne (K-017, şarjda) ortalama 2.67 ms, p95 3.5 ms
  ölçmüştü. Çizim katmanının maliyeti ≈ **0.23 ms** ortalama. Bütçe 16.7 ms.
- **Neden birleştirmeyi bekletmedim:** (1) Pay çok geniş: ölçülen değer bütçenin
  altıda birinden az. (2) Aynı iki koşulun (pil / şarj) aynı sonucu verdiğini
  daha önce ölçtüm: K-014'te pilde 2.7 ms, K-017'de şarjda 2.67 ms; düşük güç
  modu kapalıyken fark ölçüm gürültüsü kadar. (3) Cursor'un his ayarı işi bu
  dala bağlı ve bekletmek onu boşa bekletiyor.
- **DÜZELTME (2026-09-18, K-023):** 2. gerekçedeki "pil ve şarj aynı sonucu
  verir" cümlesi YANLIŞLANDI. Şarjda yapılan resmi ölçüm ortalama 8.03 ms
  verdi; sebep güç kaynağı değil makinenin MEŞGUL olmasıydı. İki koşulun
  denkliğini söylemek için elimde yeterli ölçüm yoktu: iki sayı aynı çıkmıştı
  ama koşulların geri kalanı (sistem yükü) hiç ölçülmemişti.
- **BORÇ:** Şarj gerçekten bağlanınca `node tools/kare-suresi.mjs` resmi olarak
  koşulacak ve sonucu buraya eklenecek. En kötü kare 22.5 ms (bütçenin üstünde,
  tek sıçrama) ayrıca izlenecek: p99 5.9 ms olduğu için şimdilik tek seferlik
  bir takılma gibi görünüyor, ama resmi ölçümde tekrar ederse sebebi aranacak.
- **Sabotajlar (aynı koşulda):** `vsync-bayraklari-yok` → 2 "bayraklar etkisiz";
  `agir-kare` → 1 "ortalama ve p95 bütçe dışı". Kare süresi ölçümü gerçekten
  ölçüyor.

---

## K-023 · 2026-09-18 · Ölçümün üçüncü koşulu: makinenin sessiz olması

- **Tür:** hata (aracımda eksik denetim) + ölçüm + kural
- **Durum:** düzeltildi; resmi ölçüm yapıldı (K-025)
- **Ne oldu:** Şarj takıldıktan sonra resmi kare süresi ölçümü koşuldu ve
  **ortalama 8.03 ms · p50 7.6 · p95 15.7 · p99 23.3 · en kötü 63 ms** verdi
  (pilde 2.9 ms'ti). Araç "KARE SÜRESİ GEÇTİ" dedi: 8.03 ≤ 16.7. Yani yanlış
  bir sayıyı onayladı.
- **Nasıl bulundu:** Sayı kabul edilmeden önce makineye bakıldı.
  `sysctl -n vm.loadavg` → **32.3** (8 çekirdek). `top -l 2 -o cpu`:
  Logic Pro X %36.6 · WindowServer %23.6 · kernel_task %15.4 ·
  Cursor Helper %11.8 · coreaudiod %11.5 · Chrome %7.2 · Creative Cloud %2.2;
  ayrıca beş Vite sunucusu (biri başka bir projeden, biri Cursor'un).
  Ölçülen şey oyunun maliyeti değil, kalabalık bir makinede sıra beklemekti.
  Aynı koşuda sahne de farklıydı (50 çağrı / 628 üçgen; pildeki koşuda 42 / 532),
  çünkü ölçüm kadrajında simülasyon çalışıyor ve tehdit o an sahnedeydi.
- **Düzeltme:** Araç artık sistem yükünü ölçüyor; çekirdek başına yük 0.6'yı
  geçerse **2 ile çıkıyor** ve mesajda en çok CPU kullanan dört süreci
  listeliyor ki neyin kapatılacağı belli olsun. `--mesgulken-olc` yine ölçer
  ama bütçe kararı vermez.
- **Araç içinde ikinci küçük hata:** İlk hali `top -l 1` kullanıyordu ve bütün
  süreçleri %0.0 gösteriyordu ("0.0 akd · 0.0 cloudd" gibi işe yaramaz bir
  liste). `top` yüzdeyi iki örnek arasındaki farktan hesaplar; artık ikinci
  örnek okunuyor.
- **Kural (AGENTS.md §6.7):** Kare süresi ölçümünün üç koşulu — şarj takılı,
  düşük güç modu kapalı, makine sessiz. Ölçüm yapılacağı zaman öteki ajana
  haber verilir; Cursor'un dev sunucusu ve yardımcıları da yükü artırıyor.
- **Ders:** Bir ölçümün "geçti" demesi yetmez; ölçümün KOŞULLARI da ölçülmeli.
  Uyku (K-012), düşük güç modu (K-016) ve şimdi sistem yükü — üçü de aynı
  aileden: ölçtüğümü sandığım şey ölçmek istediğim şey değildi.

## K-024 · 2026-09-18 · Menü açıkken arkadaş yerinde yürüyordu: çizim, duvar saatiyle anime ediyordu

- **Tür:** hata (benim kodum) + Cursor'a devir
- **Durum:** yürüyüş düzeltildi; oturma geçişi Cursor kuyruğunda
- **Ne oldu:** Menü açıkken dünya durur (`ana.js` → `update` erken döner). Ama
  `draw` her karede çalışır ve sahneye `dtS` verir. Bu `dtS` **duvar saati**:
  menü açıkken de akar. `oyun.js` yürüyüş fazını bununla ilerletiyordu. Sonuç:
  dünya donmuşken arkadaşın bacakları yerinde sallanıyordu. Kodun yorumunda
  "Faz oyun saatiyle ilerler" yazıyordu; yorum yanlıştı.
- **Nasıl bulundu:** Cursor'un oturma geçişini doğrularken. O geçiş
  `performance.now()` kullanıyordu; bunu kuyruğa "oyun saatine bağla, `dtS`
  kullan" diye yazarken, önerdiğim `dtS`'in de menü açıkken aktığını fark
  ettim. Aynı hata benim yürüyüş kodumda da vardı.
- **Ölçüm:** Tarayıcısız bir sonda (`.scratch/sonda/menu-yuruyus.mjs`) sahneyi
  kuruyor ve aynı `saatS` ile 30 kare çizdiriyor. Eski kodda sol kalçanın açısı
  0.040 → −0.032 rad değişti (yerinde yürüme); yeni kodda saat dururken sabit,
  saat akınca salınıyor. Sondanın ilk hali NaN üretti ve NaN ≠ NaN olduğu için
  "kıpırdadı" dedi: `moral`'ı sayı sandım, o bir nesne (`{deger, bant}`).
- **Düzeltme:** Sahne kendi animasyon adımını oyun saatinden hesaplıyor
  (`durum.saatS` farkı); `guncelle` artık `dtS` almıyor ki bir daha yanlış
  saat eline geçmesin. Cursor'un oturma geçişi aynı `oyunDtS`'i kullanacak
  (pano, kuyruk maddesi).
- **Ek (aynı oturumda, ikinci ölçüm hatam):** Sabotaj çapalarını denetleyen bir
  satırlık betik "hepsi tam bir kez" dedi; ama modüldeki İLK diziyi
  (`ARGUMANLAR`) okuyordu, tek çapa denetlemedi. Sayaç ekleyince 54 çapanın
  hepsinin gerçekten bulunduğu görüldü. Sayısı yazılmayan bir "geçti",
  ölçmemiş olabilir.
- **Ders:** Aynı `dtS` hem `update`'e hem `draw`'a gidiyor, ama oyun saati
  yalnızca `update` çalışınca ilerliyor. Adı aynı olan iki değer iki ayrı saat
  demek. Animasyon da simülasyon gibi oyun saatine bağlıdır; duvar saati
  yalnızca kare süresi ölçümü içindir.

## K-025 · 2026-09-18 · Resmi kare süresi ölçümü: borç kapandı

- **Tür:** ölçüm
- **Durum:** geçti; K-022 ve K-023'teki borç kapandı
- **Koşullar (araç ölçtü):** yapı 7889f28 (`main`, kirli değil) · Chrome
  153.0.8010.48 · ANGLE Metal, Apple M2 · tampon 2880×1800 · kadraj
  `oyuncu-baslangic` (simülasyon çalışıyor) · şarjda · düşük güç modu kapalı ·
  sistem yükü 4.0 / 8 = 0.5 (eşik 0.6) · ısınma 120 s + ölçüm 60 s · öz denetim
  827 kare/s (vsync gerçekten kapalı).
- **Sonuç:** 18 140 kare · ortalama **3.31 ms** · p50 3.5 · p95 **4.7** · p99 5.4
  · en kötü 10.3 ms · 42 çizim çağrısı · 532 üçgen. Bütçe (ort ≤ 16.7, p95 ≤ 20)
  yaklaşık beş kat pay bırakıyor.
- **Karşılaştırma:** pildeki bilgi amaçlı ölçüm 2.9 ms'ti (K-022); fark
  makinede kalan arka plan yükü (iPhone Mirroring'in görüntü akışı,
  `avconferenced` ≈ %22) ile uyumlu. Meşgul makinedeki 8.03 ms (K-023) oyunun
  değil kalabalığın ölçüsüydü; bu koşu onu doğruluyor.
- **Aynı gün sessiz makinede:** `kare-suresi` sabotajlarının üçü de yakalandı,
  yük denetiminin sabotajı (`yuk-denetimi-yok`) ilk kez koşuldu.
- **Açık kalan:** GPU süresi ölçülmüyor (oyun içinde zamanlama sorgusu yok).
  Sahne büyüyünce (ada, ağaçlar) CPU değil GPU darboğaz olabilir; o gün gerekecek.

## K-026 · 2026-09-18 · Oyunun sonları: ölüm, gidiş, kavga, moral ölümü, şafak

- **Tür:** tasarım kararı (kullanıcı) + değişmez kural değişikliği
- **Durum:** karar verildi; uygulama `claude/oyun-sonu` dalında
- **Neden şimdi:** Kod okunarak bulundu ki bugün (a) oyuncu ölünce dünya donuyor
  ama oyuncu donmuş dünyada yürüyor; (b) arkadaş ölünce de çekilince de bir anda
  kayboluyor — iki ayrı davranış satırı ekranda AYNI görünüyor; (c) yara
  simülasyonda var ama ekranda hiçbir yerde görünmüyor, yani "ölümden önce her
  zaman bir uyarı" kuralı yalnızca sayıda sağlanıyor; (d) ışık hiç değişmiyor.
- **Kararlar (kullanıcı seçti; önerilen seçenekler dahil):**
  - *Oyuncu ölürse:* kamera yere iner, dünya ~10 s daha akar, sonra karartma →
    menü. (önerilendi)
  - *Arkadaş ölürse:* bedeni kalır, oyun sürer. (önerilendi)
  - *Şafak:* ışık doğar, sonra karartma → menü. (önerilendi)
  - *Gidiş:* kullanıcı önerilen üç seçeneğin yerine kendi önerisini getirdi:
    "arkadaş bize saldırabilir … o çatışmanın sonucunda eşyaların bir kısmını
    alıp gitsin." Ardından: kavgada kontrol oyuncuda (itme, yaralamaz); açsa
    kavga, toksa şafakta sessiz gidiş. (ikisi de önerilendi)
  - *Moral ölümü:* kullanıcının önerisi — "moral çok düşerse arkadaşı kendini
    asmış olarak bulalım bir gece sonunda; gerilimi iyice arttırır." Asılı
    gösterim seçildi.
- **Değişmez kural değişti** (AGENTS.md §2 = OYUN-TASARIMI §6): "kötü adam yok,
  tehdit hayvan ve doğa" kuralına "arkadaş çaresizlikte güç kullanabilir; bu
  tehdit türü değil ilişkinin sonucudur" eklendi. Kullanıcı açıkça onayladı.
- **Teknik liderin itirazları (kayıtta kalsın):**
  - Ara sahne kontrolü alır; önerilen "kontrol sende" seçildi.
  - Asılı beden oyundaki en KESİN görüntü; oyunun ilkesi belirsizlik (izlerin
    kaynağı, arkadaşın kimliği). Belirsiz bulunuş ("köpek mi, kendisi mi?")
    önerildi; kullanıcı asılı gösterimi seçti. Uygulama belirsizliği başka
    yerde korur: an gösterilmez, oyuncu yalnızca sonucu bulur.
  - Dilimde ağaç yoktu; ilk ağaç (tek kuru ağaç, açıklığın kenarında) bu
    karar için ekleniyor.
  - İntiharın medyada gösterimine dair yaygın rehberler yöntemin açıkça
    gösterilmesinden kaçınmayı öneriyor; oyun menüde içerik uyarısı gösterecek.
- **Eski yorumum geçersiz:** `ai/moral.js`'te "morali dibe vurmuş arkadaş
  'ölmek ister' değil, kendini korumayı bırakır" yazıyordu. Bu artık
  tasarımın tamamı değil; kod güncellenirken yorum da düzeltilecek.

## K-027 · 2026-09-18 · Sönmüş ateş, yanan ateşten aydınlıktı: sahnede iki ateş ışığı vardı

- **Tür:** hata (benim kodum, dilim adım 2'den beri) + ölçüm
- **Durum:** düzeltildi; kalıcı denetim ve sabotaj eklendi
- **Ne oldu:** Oyun sahnesi ışığı `isikKur` ile kuruyordu; o da önayardaki
  sabit ateş ışığını (40 cd, menzil SINIRSIZ) sahneye ekliyordu. Ateşin
  çizimi ise kendi ışığını (yakıta göre menzil ve şiddet) ayrıca ekliyordu.
  Sahnede iki ateş ışığı vardı ve biri ateş sönünce de yanıyordu. Simülasyon
  "karanlıkta" derken ekran aydınlıktı; oyunun temel gerilimi ("ateşi besle,
  yoksa karanlık") ekranda TERSİNE dönmüştü.
- **Nasıl bulundu:** Işığı saate bağlamak için `isik-kurucu.js`'i okurken. Sonra
  ölçüldü, tek değişkenle (§5.7): aynı kadrajlar, önayar ışığı açık / kapalı.

  | Kadraj | İki ışık (eski) | Tek ışık (yeni) |
  |---|---|---|
  | `ates-sonuk` (yakıt 0) | luma ort **19.13**, p95 48 | **8.68**, p95 9 |
  | `oyun-gece` (yakıt 2.5) | 17.46, p95 43 | 13.68, p95 29 |

  Eski hâlde sönmüş ateşli gece, ateşi yanan geceden aydınlıktı.
- **Düzeltme:** Oyun sahnesi önayardaki nokta ışıkları eklemiyor
  (`noktaIsiklar: false`); ateşin ışığı yalnızca ateşin çiziminden. Referans
  sahnesi (ateş çizimi yok) önayar ışığını kullanmaya devam ediyor.
- **Kalıcı denetim:** `ates-sonuk` kadrajı, `enFazlaLumaOrt: 12`. Sabotajı
  (`cift-ates-isigi`) eski davranışı geri koyuyor ve bak düşüyor.
- **Dokuz okunabilirlik hücresi** tek ışıkla da geçti (bak, 19 kadraj).
- **Ders:** Bu hata bütün gece ölçümlerinin içindeydi ve hiçbir ölçüm onu
  yakalamadı, çünkü hiçbir kadraj "karanlık olmalı" diye sormuyordu. Yalnızca
  "yeterince aydınlık mı" soruluyordu. Bir şeyin ekranda OLMAMASI da ölçülmeli.

## K-028 · 2026-09-18 · Sonların uygulanması: ekranda ve sayıda görülenler

- **Tür:** uygulama notları (K-026'nın kararları değişmedi)
- **Bulunan ve düzeltilenler:**
  - *Oyuncu ölünce arkadaş dal toplamaya gidiyordu.* Kendiliğinden iş ("sen
    söylemeden iş yapar") oyuncu için yapılan iş; oyuncu ölünce durdu. Korku
    tepkisi (ışığa dönmek) kaldı. Senaryo ölçümüyle bulundu: yüksek güvenli
    arkadaş bedene 6.5 m'de kalıyordu.
  - *Yığının başında duran oyuncu itilmiyordu.* Arkadaş yığına 2.5 m kala
    uzanıp alıyor, oyuncu ona 2 m'den uzak kalıyordu. Araya girmek iki türlü
    sayıldı: yolunu kesmek ya da yığını tutmak.
  - *Eski 'cekilme-kalici' senaryosu düştü* — hata değil, yeni kararın sonucu:
    arkadaş önce yiyip doyuyor, tok arkadaş şafağı bekliyordu. Senaryo gidişin
    KALICILIĞINI ölçtüğü için artık aç arkadaşla gece gidişi kuruyor.
  - *Kuru ağaç ilk hâlinde okunmuyordu.* Asılma dalı ateşe doğruydu: kamptan
    bakınca beden gövdenin önüne biniyor, "ağacın dibinde duran biri" gibi
    görünüyordu (bak, agac-safak görüntüsü). Dal kampa göre yana çevrildi ve
    3.3 m'ye yükseltildi; beden göğe karşı, ayakları yerden kesik okunuyor.
  - *Hesapla yakalanan iki işaret hatası* (render almadan önce): bedeni
    yere yatıran dönüş yüzüstü yatırıyordu (yüz −Z'ye bakar; sırtüstü, X
    etrafında ARTI dönüş); asılma dalı 0.08 rad kalkıktı ve ip dala değmiyordu.
- **Ölçüm:** 13 senaryo, 24 senaryo sabotajı; açılış testi uçtan uca (ölüm →
  yerdeki bakış → karartma → menü → yeni gece; şafak → karartma → menü);
  bak 19 kadraj (yerde beden %22, asılı beden %40–46 değişen piksel).
- **Açık:** Oyuncunun yarası yalnızca yavaşlıkla okunuyor; kamerada aksama
  yok. Aksak yürüyüşün ve düşüşlerin hissi Cursor kuyruğunda.

## K-029 · 2026-09-18 · İlk oyun testi: fare çalışmıyordu, yürüme yavaştı

- **Tür:** hata (benim kodum) + ölçüm + devir
- **Nasıl bulundu:** Kullanıcı `main`'deki sürümü oynadı: "yürüme çok yavaş ve
  mouse'la ekranı çeviremiyorsun". Hiçbir test bunu yakalamamıştı; açılış
  testi fareyi hiç denemiyordu.
- **Fare — sebep:** Oyun fareyi yalnızca imleç kilidi açıkken okuyordu; kilit
  yalnızca oyun ekranına TIKLANINCA isteniyordu. "Başla"ya basan oyuncu menüye
  tıklamış oluyor, kilit açılmıyor, fare hiçbir şey yapmıyordu. Menüde "önce
  ekrana tıkla" yazıyordu; kimse okumaz. Kilidi reddeden bir tarayıcıda
  (gömülü pencere) ise hiç yol yoktu.
- **Fare — düzeltme:** "Başla" tıklamasının içinde kilit istenir; kilit yoksa
  basılı tutup sürükleyerek bakılır. Açılış testi artık sürükleyip bakışın
  döndüğünü ölçüyor (0 → −0.44 rad); sabotajı `surukleme-yok`.
- **Yürüme — ölçüm:** 1.4 m/s (gerçek insan yürüyüşü) × başlangıç açlığı 0.95.
  Hız tek başına artırılamaz: oyuncu dairede yürürken arkadaşın medyan
  mesafesi —

  | Oyuncu | Yüksek güven (yetişmesiz → yetişmeli) | Orta güven |
  |---|---|---|
  | 1.4 m/s | 3.98 → 3.98 m | 8.05 m |
  | 2.0 m/s | 4.66 → **4.29** m | 7.75 m |
  | 2.5 m/s | 5.18 → 4.68 m | 7.19 m |
  | 3.0 m/s | 5.43 → 4.96 m | 7.26 m |

  Yetişme olmadan 2 m/s'de yüksek güven "yakında yürür" eşiğini (4.5 m) aşıyor
  ve orta güvene yaklaşıyor: oyunun kalbi (güveni davranıştan okumak) bozulur.
- **Yürüme — düzeltme:** Arkadaşa yetişme eklendi (gerisinde kalınca adımı
  2.2 kata kadar açılır; moralin temposu korunur, çizim de adımı hızlandırır).
  Yeni senaryo `yuruyen-oyuncu` hem gerçek hızı hem 2 m/s tavanını sınar;
  sabotajı `yetisme-yok`. Hızın kendisi his ayarı: Cursor kuyruğunda, tavan
  2.0 m/s. Daha hızlısı (koşma) bir tasarım kararı — kullanıcıya soruldu.
- **Açılış testinde bulunan ikinci hata:** Sonlar bölümü, menü geri gelmeyince
  kapalı menüdeki düğmeye tıklamaya çalışıp PATLIYORDU (çıkış 2). Üç sabotaj
  bu yüzden "yakalanmadı" göründü. Başarısız bir koşul 1 ile düşmeli; akış
  artık yakalanıp başarısız sayılıyor.

## K-030 · 2026-09-18 · Koşma eklendi

- **Tür:** tasarım kararı (kullanıcı)
- **Bağlam:** İlk oyun testinde yürüme yavaş bulundu (K-029). Yürüme en fazla
  ~2.0 m/s olabiliyor, yoksa yüksek güvenli arkadaş geride kalıp güven
  ekranda okunmuyor. Tasarım belgesi zaten "yaralı: yavaş yürür, KOŞAMAZ"
  diyordu, yani koşma var sayılmıştı ama oyunda yoktu.
- **Karar (kullanıcı, önerilen seçenek):** Shift basılıyken koşma, ~3 m/s.
  Yaralıyken ve çok açken koşulamaz. Koşunca arkadaşın geride kalması doğal:
  ondan uzaklaşan oyuncu.
- **Teknik liderin koyduğu şart (inşa değişmezi):** koşu hızı köpeğin
  koşusundan (3.2 m/s) düşük. Aksi hâlde köpekten koşarak kaçılır ve adillik
  zinciri (fark et → müdahale et: ateşi besle, yanına git) anlamını yitirir.

## K-031 · 2026-09-19 · Ne yaptığını görmek: oyuncunun eli ve arkadaşın bedeni

- **Tür:** uygulama (kullanıcının oyun testi) + görsel kontrolde bulunan hatalar
- **Neden:** Kullanıcı oyunda en çok üç eksik gördü: ses, ne yaptığını görmek,
  görünüm. Önce ikincisi: kararı açık bir yanı yoktu ve oyunun tezi (açken
  yiyeceğini vermek) ekranda hiçbir karşılık bulmuyordu.
- **Ne yapıldı:** Oyuncunun eli kameraya bağlı; yersen yiyecek ağzına gider,
  verirsen uzanır, dalı alır taşırsın, ateşe atarsın, çağırınca "gel" işareti.
  OLMAYAN eylemde el yarım uzanıp geri çekilir — neden olmadığını söylemez.
  Arkadaş verdiğin yiyeceği uzanıp alır ve yer; kendi yediğinde eli ağzına
  gider; sana verirken uzanır. Poz ve süreler oyun saatinden hesaplanan saf
  fonksiyonlarda (`el-hareketi.js`, `ai/beden.js`); çizim yalnızca uygular.
- **Görsel kontrolde bulunanlar** (donmuş dünyada oyuncunun gözünden kare,
  `.scratch/sonda/el-goruntu.mjs`):
  - arkadaşın "yeme" hareketinde el ağza değil başın YANINA kalkıyordu —
    uzaktan el sallamak gibi. Kol yalnızca öne-arkaya dönüyordu; omza içe
    dönüş eklendi (sağ kol +x'te, içe = z dönüşü eksi);
  - elde taşınan dal ekranda dimdik bir direk gibiydi: dalın ve elin eğimi
    toplanıp ~49° yukarı kalkıyordu;
  - yerken kol kameraya çok yakındı (z −0.27) ve ekranın dörtte birini kapattı.
- **Ölçüm:** senaryo `bedende-anlar` (verme → uzan → ye → boş; kendi yiyince
  ye); açılış testi gerçek tuşla (boş el görünmez, olmayan eylemde boşa uzanma,
  yiyince yiyecek ağza) — el durumu hesaplanan pozdan değil ÇİZİLEN nesneden
  ve sahneye bağlılıktan okunur, yoksa çizilmeyen el de "görünür" sayılırdı.
- **Ek:** malzeme ızgarası 5 → 6 sütun (oyuncunun kolu ve eli: 17 malzeme).

## K-032 · 2026-09-19 · Ölçüm SIRASINDA kalabalıklaşan makine "GEÇTİ" dedirtti

- **Tür:** hata (aracımda eksik denetim) — K-023'ün devamı
- **Ne oldu:** `claude/geri-bildirim` (a130514) için resmi kare süresi ölçümü
  **ortalama 10.43 ms · p95 15.7** verdi ve araç "GEÇTİ" dedi. Sabah aynı
  kadrajda `50a7e91` 2.65 ms'ti; aradaki değişiklikler (el, kol hareketleri)
  ölçülen kadrajda çizilmiyor, çağrı/üçgen de aynı (42 / 532). Sayı kabul
  edilmedi.
- **Nasıl bulundu:** Başta yük 0.49 (eşik 0.6) okunmuştu. Ölçümden hemen sonra
  makineye bakıldı: yük 7.19, **Logic Pro %25, coreaudiod %22** — ölçüm
  sırasında açılmış. Araç yükü YALNIZCA başta okuyordu.
- **Düzeltme:** Yük ölçüm bitince yeniden okunuyor. Bir dakikalık ortalama o
  anda tam 60 s'lik ölçüm penceresini yansıtır. Sonda meşgulse sonuç ne geçer
  ne düşer: 2 ile çıkılır ve en çok CPU kullananlar listelenir (kalabalık,
  oyunu bütçeyi aşmış da gösterebilirdi). Sabotajı `olcum-sirasinda-yuk`.
- **Borç:** Sabotaj ve `claude/geri-bildirim`'in geçerli ölçümü sessiz makine
  bekliyor (Logic Pro kapalıyken). Dal bu ölçüm olmadan birleşmez.
- **Güncelleme (aynı gün, kullanıcı yokken):** sessiz makinede, PİLDE bilgi
  amaçlı ölçüm (`claude/ses` 333ccb4, geri bildirimi de içerir): ortalama
  **2.7 ms**, p95 3.6 — sabahki resmi 2.65 ms ile aynı. 10.43 ms'yi ortam
  (Logic Pro) üretmişti; el, kol ve ses bütçeye iz bırakmadı. Yük başta 0.24,
  sonda 0.43 — sonda okuma çalışıyor. `kare-suresi` sabotajlarının dördü
  (yeni `olcum-sirasinda-yuk` dahil) ve `gpu-farki`'nın üçü yakalandı.
  Resmi ölçüm (şarjda) hâlâ borç: şarj takılı değildi.
- **Kapandı (2026-09-20):** kullanıcı şarjı taktı; üç dalın tamamı (c93e054:
  geri bildirim + ses + görünüm) resmi ölçüldü — ortalama **2.98 ms**, p95 3.7,
  en kötü 6.2; yük başta 0.27, sonda 0.32. Logic Pro arka planda açıktı ama
  boştaydı; iki yük okuması da eşiğin altında. Geri bildirim ve ses `main`'e
  birleşti (333ccb4).
- **Ders:** Koşul bir kez değil, ölçülen pencerenin iki ucunda denetlenmeli.

## K-033 · 2026-09-19 · Ses: arkadaşın nefesi, ortam, oyuncunun bedeni

- **Tür:** uygulama (kullanıcı kararlarıyla) + ölçüm
- **Kullanıcı kararları:** arkadaşın sesi gerçek kayıttan (CC0), ortam
  kodla; ses kimliği ele vermez (nefes, iç çekme, boğuk inilti — çığlık ve
  kelime yok); köpek gerçek kayıttan (henüz yok). Kayıtları kullanıcı
  DİNLEYEREK seçti (OwlishMedia CC0 paketi): sakin nefes `breath-female`,
  `breath-female2`; korku `scared-breathing`, `gasp1`; yeme
  `drink-sip-and-swallow`; dip `yawn2`. Ben ses duyamıyorum: adayları süre,
  düzey ve perdeli oran (%3–75) ile ölçüp daralttım, karar kulağındı.
- **Mimari:** karar saf modülde (`ses-sahnesi.js`, oyun saatinden; menüde
  karar yok), çalma `ses/motor.js`'te (Web Audio, HRTF yönlü ses, menüde
  askı). Nefesin hâli davranış tablosunun bir kanalı: sakin / yürürken sık /
  dip (seyrek + iç çekme) / korku / SESSİZ (ölünce). Kendini bırakma anı
  duyulmaz (K-026: görülmez, bulunur).
- **Hazırlık aracı:** `tools/ses-hazirla.mjs` — tek kanal, 32 kHz, düzey
  eşitleme, uzun kayıtları tek nefeslere bölme. İlk hâli nefeslerin sönüşünü
  kesiyordu (80 ms kuyruk; zarf ölçümüyle görüldü, 200 ms'ye çıktı) ve eski
  parçaları silmiyordu. 39 parça, 2.1 MB.
- **Ölçülen:** sessiz (headless) Chrome'da bağlam açılıyor, kayıtlar yükleniyor,
  çıkış −44 dB'den (fazla sessiz) sınırlayıcı ile −32…−38 dB'ye çıkarıldı;
  derlenmiş oyunda da çalışıyor. Menü açılınca bağlam askıya alınıyor.
- **Testler:** `tests/ses-senaryo.mjs` (5 senaryo, 7 sabotaj) + açılış testinde
  4 ses denetimi (3 sabotaj). Yapı damgası artık `public/`'i de özetliyor.
- **Köpek (aynı gün eklendi):** Commons'tan dal kırılması (CC0 + kamu malı) ve
  uluma (kamu malı); kullanıcı lisanslarını görüp onayladı. Dal kırılması
  köpek sana YA DA hedefine yakınken — karanlıkta arkadaşa yaklaşan köpek de
  duyulsun. Hırıltı YOK: bulunanlar CC BY / BY-SA'ydı, kullanıcı eklemedi.
- **Açık:** karışım dengesi kulakla (Cursor kuyruğu); kare süresi ölçümü sessiz
  makine bekliyor (K-032).

## K-034 · 2026-09-19 · Görünüm: açıklık bir yer oldu — ağaç sırası, çalılık, zemin

- **Tür:** uygulama (kullanıcının oyun testi: "deneme sahnesi gibi")
- **Önce:** 22 koyu kutu (çalı), 30 m'de biten düz disk, ötesi simsiyah.
- **Şimdi:** açıklığın çevresinde iki sıra halinde 100 çam (15–25 m, taç/boy
  0.25–0.35, gövde çapı/boy 0.012–0.020 — değişmez kuralın oranları, veri
  yüklenirken denetleniyor), kenarda 60 çalı öbeği, açıklıkta 26 taş ve 148
  ot öbeği, 80 m'ye kadar orman zemini. Patika ağzı açık.
- **Elle tasarım kuralı:** konumlar oyun çalışırken üretilmiyor; bir kez
  tohumlu betikle çıkarıldı, SABİT liste olarak veri dosyasında
  (`veri/aciklik-cevresi.js`), haritada gözden geçiriliyor, elle düzeltilebilir.
  Değişmezler ilk yüklemede bir ot öbeğini dal yığınının üstünde yakaladı.
- **Bütçe:** örnekli çizim; her tür tek çağrı. Üçgen 544 → ~13 bin (sınır
  250 bin), çağrı sayısı neredeyse aynı.
- **Görsel kontrolde:** çalılar ilk hâlinde kaya gibi okundu (tek parça, koyu,
  yarı gömülü) → iki parçalı yeşil öbek. Gece yalnızca yakın ağaçlar silüet
  olarak seçiliyor: karanlığın ortasında bir ışık adası (sis 8–45 m); şafakta
  orman duvarı. Asılı beden şafakta ağaçların önünde: görünürlük %45.6 → %30.9
  (eşik %5).
- **Ölçüm:** kadraj aracı çevreyi gizleyip farkı ölçüyor (gündüz %14.5, şafak
  %14.8; eşik %10) — sabotajı `cevre-cizilmiyor`. Harita artık ağaçları,
  çalıları, kuru ağacı, yığınları ve çıkışı gösteriyor; kural dışı ağaç
  sabotajı `agac-orani-bozuk`.

## K-035 · 2026-09-20 · Ağaç kuralı netleşti: kenar ve genç ağaç; ses fazla yüksekti

- **Tür:** değişmez kural netleştirmesi (kullanıcı onayı) + oyun testi bulguları
- **Oyun testi (kullanıcı):** "her şey biraz fazla sesli", "ağaçlar çok uzun,
  gerçek ağaç hissiyatı yaratmıyor", "sadece dışlarda ağaç var".
- **Ses — benim hatam:** ilk ölçümde ana çıkış −44 dB'di; "oyunlar −25/−30 dB
  olur" diye DUYMADAN ana kazancı iki katına çıkardım (K-033). Kulak tersini
  söyledi. Karar: ana ses yarıya (eski düzey), menüde ses ayarı.
- **Ağaç — neden gerçek dışıydı:** kuraldaki "taç/boy 0.25–0.35" ormancılıktaki
  taç oranıdır ve SIK ORMAN İÇİ ağacını anlatır (alt dallar ışıksızlıktan
  kurur). Açıklık kenarındaki ağaçta ışık yandan gelir, dallar yere iner
  (taç/boy 0.5–0.8); kenarda genç ağaçlar ve çalılık basamaklanır. Ben bütün
  ağaçları orman içi kalıbıyla, tek biçimde dizdim: direk gibi okundular.
- **Kural değişikliği (kullanıcı onayladı):** AGENTS.md §2 = OYUN-TASARIMI §6:
  sayılar sık orman içi ağaç için; kenar ve tek duran ağaçta taç/boy 0.5–0.8;
  genç ağaç 3–12 m. İlke ("oranlar gerçek") aynı.
- **Açıklığın içi (kullanıcı kararı):** ateşin çevresi açık kalır (arkadaşın
  mesafesi orada okunuyor); dış halkaya tek ağaç, kütük, devrik gövde.
- **Sıradaki büyük adım (kullanıcı kararı):** elle tasarlanmış ada. Önce harita
  ve önemli yerler seçeneklerle sunulacak.

## K-036 · 2026-09-20 · Ses ayarı: varsayılan kararın kendisi; kaçan bir sabotaj

- **Tür:** uygulama (K-035 kararı) + üç hatam + bir araç hatası
- **Ne:** menüde "Ses" kaydırıcısı; sayı göstermez. Ana kazanç = kaydırıcı
  oranı × 1.8. Sonuna kadar = eski, "fazla sesli" bulunan düzey; varsayılan
  0.5 → 0.9 = K-035 kararı ("yarıya"). Tarayıcıda hatırlanır
  (`src/ses-ayari.js`); bu bir ayar, oyun kaydı değil — K-006'ya dokunmaz.
- **Hata 1 — kararı yanlış uygulamıştım.** İlk hâlde taban 0.9 × varsayılan
  kaydırıcı 0.8 = 0.72: kararın ~2 dB altı. Nasıl bulundu: test kazanç
  düğümünü okumaya başlayınca raporda 0.72 göründü.
- **Hata 2 — denetim hiç koşmuyordu.** Açılış testindeki ses ayarı denetimi
  yalnızca İKİNCİ dilde çalışıyordu. Negatif kontrol açılış testini hız için
  tek dilde koşar (`--yerel tr`); tek dilde o dil "ilk dil" sayılır, denetim
  atlanır. Sabotaj KAÇTI. Nasıl bulundu: aynı sabotajı elle kurduğum kopyada
  (iki dil) test yakaladı, araçta kaçtı; fark koşucunun argümanıydı. Ders:
  denetimi dil sırasına bağlama — negatif kontrolün geçmediği yoldaki denetim
  ölçülmemiş bir denetimdir (§5.9).
- **Hata 3 — değişkeni ölçüyordum, sesi değil.** İlk denetim motorun `duzey`
  değişkenine bakıyordu; kazanç düğümü eski değerde kalsa kulak fark duymaz,
  test yine geçerdi. Şimdi düğümün kendisi okunuyor, iki ayrı yol ayrı
  ölçülüyor: motor kurulmadan önce (ilk "Başla") ve kurulduktan sonra (ölüm
  sonrası menü). Üç sabotaj: kaydırıcı motora bağlı değil / motor düğüme
  uygulamıyor / oyun sırasındaki yol kopuk — üçü de yakalandı.
- **Araç hatası:** `negatif-kontrol.mjs --sabotaj <ad>` tek başına verilince
  sabotajı bulan modülde koşup sonraki modülde "yok" diyerek 2 ile çıkıyordu;
  belgelenen kullanım hiç çalışmamıştı. Artık adı taşıyan modül(ler) koşar,
  hiçbirinde yoksa 2.
- **Koşu denetimi (Cursor'un bulgusu):** açılış testi "koşu ≥ 1.8 × yürüme"
  istiyordu; `kosu.js` inşa değişmezi 1.4× diyor ve koşu köpekten (3.2 m/s)
  yavaş olmak zorunda. Cursor yürümeyi 2.0 m/s yapınca 1.8× imkânsız oldu.
  Testteki sabit sayı veriyle yarışan ikinci bir kaynaktı (§5.2). Artık oran
  veriden okunur: ölçülen koşu/yürüme ≥ 0.9 × (`KOSU.hizMS` / `yurumeHiziMS`).

## K-037 · 2026-09-20 · Cursor'un his ayarları ölçüldü; kare süresi borçlandı

- **Tür:** doğrulama (AGENTS.md §6.6) + bilinçli kural sapması (kullanıcı kararı)
- **Cursor'un üç maddesi ölçüldü** (birleşik kopyada: `cursor/ilk` + `claude/kenar`):
  - **Yürüme 2.0 m/s + yetişme çarpanı `arkadas-ayar.js`'e taşındı.**
    `[yuruyen-oyuncu]`: yüksek güven medyan 4.29 m (≤ 4.5), orta 7.75 m (≥ 6) —
    hız arttı, güven bantları ekranda ayrışmaya devam ediyor.
  - **El ve kol:** `[bedende-anlar]` uzan → ye → null; açılış testinin el
    denetimleri geçti.
  - **Yara ve düşüş:** sonda (`.scratch/sonda/yara-aksama.mjs`, tarayıcısız):
    sağlam bedende kalça düşüşü 0 ve iki adım eşit; yaralıda kalça 0.09 m
    düşüyor, sağ adım solun 0.22'si, tempo 0.60.
- **Sondanın kendi hatası — ve dersi:** aksamayı GÖRÜNTÜ ile doğrulamak için
  yazdığım ilk sonda menü altında (dünya donuk) kare çekiyordu; arkadaş
  yürümediği için yaralı ve sağlam kareler AYNI çıktı. Aksama bir hareket;
  donmuş bedende yoktur. Sonda oyunu gerçekten oynatacak biçimde yeniden
  yazıldı (menü gerçek tıklamayla kapanır, arkadaş 12 m'den yaklaşır, mesafe
  8 m'nin altına inince kareler çekilir). §5.8'in aynı ailesi: ölçtüğümü
  sandığım şey ölçmek istediğim şey değildi.
- **Araç tuzağı:** doğrulama worktree'sinde `node_modules` sembolik bağ olunca
  negatif kontrol 2 ile çıktı — `.gitignore`'daki `node_modules/` kalıbı
  yalnızca DİZİNLE eşleşir, bağ "izlenmeyen dosya" sayılır. Gerçek dizin +
  paket bağları ile çözüldü.
- **Kural sapması (kullanıcı kararı):** K-008 her kod dalının `main`'e
  girmeden önce kare süresi ölçümü ister. Kullanıcı şarjı çıkarmıştı; araç
  pilde ölçmeyi reddeder (K-016) ve kullanıcı "ölçümsüz devam et" dedi. İki dal
  ölçümsüz birleşti. Ölçülen kısım geçti (çizim çağrısı 21–22, üçgen 12.9k);
  ölçülmeyen kare süresi **borç olarak panoda** duruyor, şarj takılınca ilk iş.

## K-038 · 2026-09-20 · Açıklığın kenarı: dört ağaç sınıfı, dış halka, bir eksen hatası

- **Tür:** uygulama (K-035 kuralı) + ilginç hata
- **Sorun (kullanıcı, K-035):** "ağaçlar çok uzun, gerçek ağaç hissiyatı
  yaratmıyor", "sadece dışlarda ağaç var". Ölçüldü: 84 ağacın **hepsi** tek
  kalıptaydı — taç/boy 0.26–0.33, yani SIK ORMAN İÇİ oranı. Açıklığın ilk
  sırası da öyleydi; ışığı yandan alan bir ağacı ışıksız ormanın oranıyla
  dizmek, ekranda direk üretir.
- **Yapılan:** ağaç artık dört sınıf, her biri kendi bandında inşa anında
  denetleniyor (`src/veri/aciklik-cevresi.js`):
  - `orman` r ≥ 42 m, taç/boy 0.25–0.35 (58 ağaç)
  - `kenar` r 32–42 m, taç/boy 0.5–0.8 (42 ağaç)
  - `genc` r 30–36 m, boy 3–12 m, taç/boy 0.5–0.9 (31 ağaç)
  - `tek` açıklığın İÇİNDE, r 16–28 m, kenar bandıyla aynı ışık (2 ağaç)
  Ayrıca dış halkaya 5 kütük ve 3 devrik gövde (elle yerleştirildi). Ateşin
  çevresi açık: dış halka nesneleri merkeze 16 m'den yakın olamaz — arkadaşın
  mesafe bantları (yüksek ~4 m, orta ~8 m) orada okunuyor.
- **Sınıflar arası değişmez:** tek tek bantlar yetmez; sınıfların SIRASI da
  denetleniyor (genç < kenar < orman) ve kenar tacının ortalaması orman
  tacının 1.5 katından geniş olmalı. Kural bunun için değişti; sayı tek tek
  doğruyken sıralama bozuksa basamak yok demektir.
- **Eksen hatası (§5.3, sessiz tür):** devrik gövdenin yönünü veride
  `(cos aci, sin aci)` tuttum; Three'de Y ekseni etrafında θ dönüşü +Z'yi
  `(sin θ, cos θ)`'ye taşır. Doğrudan `aci` verince gövdeler 90° yanlış
  yatıyordu. Bu hata hiçbir konsol hatası vermez, haritada doğru görünür —
  yalnızca ekranda yanlış durur. Doğrusu θ = π/2 − aci.
- **Yeni test (bu yüzden var):** `tests/cevre-yerlesimi.mjs` — tarayıcısız,
  sahneyi node'da kurup ÖRNEK MATRİSLERİNİ okuyor: ağaçlar verideki yerinde ve
  tabanları yerde mi, kütükler dik mi, devrik gövdeler yatık, yere oturmuş ve
  yönü veriyle aynı mı, basamak sırası duruyor mu. Beş sabotajın beşi de
  yakalandı (eksen 90°, gövde havada, kütük havada, kenar ağacına orman
  kalıbı, tek ağaç ateşin dibinde).
- **Ölçülen:** çizim çağrısı 24 (+2: kütük, devrik), üçgen 15.350 — bütçe
  150 / 250.000. Kadrajlar geçti; iki yeni kadraj eklendi: `kenar-safak`
  (ateşin yanından kenara bakış) ve `dis-halka-safak` (gövde yerde mi).
- **İki ayar turu (her turda TEK değişken, §5.7):** (1) taç oranı halkanın
  iç kenarında bandın üstüne çekildi — ilk sıra 0.77 ort, dış sıra 0.64;
  (2) kenar halkası 33–40.5 m'den 32.5–38 m'ye alındı, genç sıra 34 → 42
  denemeden 33 ağaca çıktı. Sebep: ilk turdan sonra render'a baktığımda
  görülen ağaçların çoğu hâlâ bandın DIŞ ucundaydı; oradaki ağaç uzaktan
  yine direk okunuyor. Son sayılar: 45 kenar, 59 orman, 33 genç, 2 tek.
- **Açık:** görünümün "gerçek ağaç hissi" verip vermediği KULLANICININ gözüyle
  karara bağlı; kare süresi borcu (K-037) duruyor.

## K-039 · 2026-09-20 · Oyuncunun bedeni: yere bakınca kollar ve eller

- **Tür:** kullanıcı isteği + uygulama + iki işaret/uzay hatası
- **Kullanıcı (oyun testi):** "yürürken ve yere doğru baktığımızda kollarımızı
  ve ellerimizi görsek güzel olur, biraz daha gerçekçi olur." O güne kadar
  ekranda yalnızca EYLEM eli vardı (K-031): yeme, verme, dal taşıma. O el
  kameraya bağlı; aşağı bakınca beden yoktu.
- **Karar:** beden **sahne uzayında** çizilir, kameranın çocuğu olarak değil.
  Kameraya bağlı bir beden, kamera eğildiğinde onunla eğilir; aşağı bakmak
  onu ORTAYA ÇIKARMAZ, ekranın aynı yerinde duran bir çıkartma olur. Eylem eli
  kamerada kalmaya devam ediyor; o görünürken bedenin sağ kolu gizleniyor
  (yoksa iki sağ kol).
- **Ölçülen tasarım sorusu:** "kol görünüyor mu" değil, **"el görüş konisinin
  içinde mi"**. Yanda dümdüz sarkan kolun eli, 50° aşağı bakışta görüş
  ekseninden 53° uzakta kalıyordu (koninin köşegen yarı açısı ~55°): yalnızca
  ekranın köşesinde, yanıp sönen bir leke. Duruşa hafif öne açı verildi
  (omuz 22°, dirsek 28°) → 31°, yani çerçevenin içinde.
- **İki hata, ikisi de sessiz:**
  1. **İşaret (§5.3):** bedenin ileri yönü −Z; sarkan uzuv X ekseninde
     POZİTİF dönünce öne gider. Eksi yazdım, kollar arkaya sarktı — beden
     sahnedeydi, hiçbir test düşmedi, oyuncu elini hiç görmedi.
  2. **Kadraj açısı:** ilk "aşağı bakış" kadrajını 60°'ye koydum ve beden
     görünmeyince "beden çizilmiyor" sandım. Ölçünce görüldü: 60°'de göğüs
     58°'de, yani koninin dışında. Ölçmeden önce kadraja güvenmek, ölçtüğünü
     sandığın şeyi ölçmemektir (§5.8).
- **Yeni test:** `tests/oyuncu-bedeni.mjs` — tarayıcısız. Beden oyuncunun
  ayağının dibinde mi, bakış yönüne dönük mü, omuz gözün altında mı, **iki el
  de 50° aşağı bakışta görüş konisinde mi**, eller önde mi, yürürken salınıyor
  ve dururken duruyor mu, oyun saati durunca duruyor mu, eylem elindeyken sağ
  kol gizleniyor mu. Altı sabotajın altısı da yakalandı.
- **Durum sürümü 3 → 4:** oyuncunun anlık hızı (`hizMS`) duruma eklendi;
  bedenin yürüyüş fazı bundan hesaplanıyor (kare sayısından değil).
- **Ölçülen:** çizim çağrısı 23–24, üçgen 15.746 — bütçe 150 / 250.000.
- **Cursor'a:** duruş ve salınım sayıları HİS değeridir (kuyrukta).

## K-040 · 2026-09-20 · Ada seçildi: SIRT + FALEZ (A × E)

- **Tür:** kullanıcı kararı (harita seçeneklerinden)
- **Seçilen:** `.scratch/ada-secenekleri/F-sirt-falez.png` — 440 × 340 m.
  Doğu–batı bir sırt adayı ikiye böler; sırtın KUZEY yüzü 20–25 m'lik falez
  olarak denize düşer. Güney yamaç yumuşak: açıklık (dilimin ateşi), dere,
  kumsal. Falezden inen TEK bir yarık var; sal falezin dibindeki kaya
  sahanlığına sıkışır.
- **Neden bu:** tek coğrafya iki iş yapıyor. Sırt bir GÖRÜŞ duvarı (arkadaş
  öbür yüze geçince gerçekten kaybolur), falez ise "görüyorum ama
  ulaşamıyorum" ayrımını verir — ikisi de oyunun kalbine (kaybetmek,
  aramak) doğrudan hizmet ediyor ve yeni bir sistem gerektirmiyor.
- **Enkaz (kullanıcı kararı):** güney kumsalda, yarısı suda. Üç işi var:
  oyunun başladığı yer, ilk aletlerin kaynağı, "deniz bir şey getirir"
  fikrini kuran ilk nesne (sal da denizden gelecek).
- **Arkadaşın çekilme yeri (kullanıcı kararı):** her küsmede aynı yer DEĞİL.
  Üç yer işaretlendi (falezin batı ucu, doğu burnu, dere ağzı); seçim duruma
  bağlı olacak ve son seçilen arka arkaya tekrarlanmayacak.
- **Açık:** denizin açıklıktan görünüp görünmeyeceği — ada kurulduktan sonra
  iki render karşılaştırılarak kullanıcı gözüyle karara bağlanacak.

## K-041 · 2026-09-20 · Oyun öğretmez ama ANLATIR: kural değişti

- **Tür:** değişmez kural değişikliği (kullanıcı kararı)
- **Eski kural:** "Oyun hiçbir şey anlatmaz. Öğretici yok, görev listesi yok,
  ekranda 'şunu yap' yazmaz. Anlamı oyuncu kurar."
- **Yeni kural:** öğretici/görev listesi/HUD yine YOK; yönlendirme dünyadan
  gelir (arkadaş yapar ve bakar, yarım iş yarım durur). Ama oyun bir hikâye
  anlatır: **sayılı ve kısa cutscene'ler** ile **ekranda nadiren beliren kısa
  satırlar** olabilir. Ölçüt: satır oyuncuya *ne yapacağını* değil, o anda *ne
  yaşadığını* söylüyorsa doğrudur.
- **Kullanıcı:** "hem anlar hem cutscene'ler olsun, böylece bir hikâye elimizde
  olur. Ekranda çok olmasa da yazılar olsun ama oyunu bir oyun gibi değil o an
  bir hikâyeyi yaşıyormuş gibi hissettirsin."
- **Benim uyarım (kayda geçsin):** arkadaş YÖNLENDİREN olursa akıl hocasına
  dönüşür; ilişki eşitliğini, kimliğinin belirsizliğini ve ölümünün duygusal
  ağırlığını kaybeder. Bu yüzden yönlendirme arkadaşın AĞZINDAN değil,
  ELİNDEN gelir: yapar, durur, bakar. Kelimesizlik kuralı (K-005) duruyor.
- **Craft (kullanıcı kararı):** Minecraft tarzı envanter/tarif DEĞİL; fiziksel
  — odunu taşı, yerine koy, bağla. Ölçüt aynı kalıyor: bir craft arkadaşla
  yakın olmak için sebep üretmiyorsa listeye girmez (iki el gerektirsin).
- **Sıra (kullanıcı onayladı):** önce ada ve enkazın 3B'si, sonra craft.


## K-042 · 2026-09-20 · Ada ve enkazın ilk çizim doğrulaması (Codex devir)

- Kullanıcı Claude kotası bittikten sonra mevcut işi Codex'e devretti;
  beş kaydedilmemiş dosya korunarak `codex/ada-enkaz` açıldı.
- İlk çizimde enkaz malzemesi eksikti, ada uygulamaya bağlı değildi.
  Ayrı inceleme sahnesi ve dört kadraj eklendi; oynanış dilimi korunuyor.
- Kaya sahanlığının eski işareti (140, -112) su altındaydı. İşaret artık
  yarık yolunun hesaplanan sonundan geliyor; iki ayrı konum kaynağı yok.
- Silindir enkaz boru gibi görünüyordu. Sabit yüzey verisiyle daralan kuyruk,
  kırık uç, iç taban ve ayrı kanat kuruldu. İlk pencere boşlukları büyük
  göründüğü için çerçeveler daraltıldı. Henüz nihai model değildir.
- Enkaz testi çizilen köşelerin dünya dönüşümünü ve gerçek pencere
  boşluklarını sınar. Ters yön, sıfır eğim ve kapalı pencere sabotajlarının
  üçü de yakalandı. Kamera zemin kontrolü ada kadrajlarına da genişletildi.
- Katman, derlenmiş TR/EN açılış ve beş görsel kadraj geçti. Chrome
  153.0.8010.48 / ANGLE Metal Apple M2 / 2880×1800 / hızlı mod;
  yapı 992deb6+ / 53ba2e87, ada 8 çağrı ve 12062 üçgen. Kare süresi
  ölçülmedi (kullanıcının önceki izni); görsel çevre ve dolaşım işi sürüyor.


## K-043 · 2026-09-20 · Etkileşimli enkaz sahnesi fikri

- Kullanıcı uçak camını zorlayarak açılan bir etkileşimli sahne istedi;
  acil çıkış penceresi veya kazada gevşeyen çerçeve önerisini kabul etti.
- Niyet: oyuncunun eliyle uğraştığı, ses ve hareketle geri bildirim veren
  kısa bir sahne. Arkadaşın yardımı ilişkiyi davranışla hissettirebilir.
- Henüz uygulanmadı. Ada/enkaz çalışmasının ardından prototiplenecek;
  tekrar tekrar tuş isteyen bir görev ekranı amaçlanmıyor.

## K-044 · 2026-09-20 · Görsel hedef yarı gerçekçilik

- Kullanıcı: "olabildiğince semi realistic ve gerçekçi görüntülü güzel
  shaderları olan" bir oyun istiyor. Eski düz gölgeli low-poly tarifi
  nihai kalite sınırı olarak kullanılmayacak. Gerçek oran ilkesi korunuyor.
- Ortak görsel yön AGENTS ve tasarım belgesinde birlikte güncellendi.
  Güncel sahne yerleşim taslağıdır; shader/ışık/malzeme çalışması tamamlanmadı.
- Uygulama öncelikleri: deniz yüzeyi, ıslak/kuru kıyı ayrımı, aşınmış enkaz
  metali ve doğal bitki örtüsü. M2 performans bütçesi geçerliliğini koruyor.

## K-045 · 2026-09-20 · Geçidin ortasını ölçmek yetmedi

- 2 m arazi örgüsünün tamamında geçit örneklendiğinde en dik yüzey 1.627
  çıktı (sınır .85). Eski inşa değişmezi yalnızca yolun ortasına bakıyordu.
- Sebep: geçidin düz enine kesiti yoktu; yakın örgü köşeleri duvarın
  yüksekliğiyle karışıyordu. 5 m merkez bandı ile en dik yüzey .398 oldu.
- Eski .85 sırt oranındaki "duvar" örneği tanımlı 11 m geçit bandının
  içindeydi. Duvar kontrolü geçit dışındaki .15/.25/.45/.65 noktalarına alındı.
- Arazi yüzeyleri saf veriye taşındı; yükseklik ve eğim artık çizilen
  üçgenin enterpolasyonuyla okunabilir. Henüz oyun dolaşımına bağlanmadı.
- 676 örnekte bağımsız ışın testi: fark < .000001 m. Ham yüksekliğe dönüş
  ve dar geçit sabotajları yakalandı. Enkaz testi ve katman kuralları geçti.
- Görsel kontrol: 9f67a1e+ / a28d8111, hızlı mod, Chrome 153.0.8010.48,
  ANGLE Metal Apple M2, 2880×1800; üç kadraj temiz, 8 çağrı / 45994 üçgen.
  Resmi kare süresi ölçülmedi.


## K-046 · 2026-09-20 · Kumsalda uyanma ve büyük enkaz yerleşimi

- Kullanıcı kumsalda kendine gelip enkazı dışarıdan keşfetmeyi seçti.
  Kumsalın gizemi ve korkusu sakinliği/ıssızlığıyla bağlantılı. Hafif
  esinti ve yaşam isteniyor. Büyük gövde ileride iç sahnelere yer bırakacak.
- Cutscene konuşmaları yalnızca fikir. K-043 uygulanacak kesin sahne olarak
  okunmamalı; iç sahneler ve ihtiyaç duyulacak malzemeler birlikte seçilecek.
- 24 × 4.2 m ilk gövde denemesi çizildi. Şablondaki bütün gövde köşeleri,
  iç taban ve pencere merkezleri aynı ölçü dönüşümünden geliyor. Test artık
  yalnız veri boyunu değil çizilen gerçek boyu da denetliyor.
- İlk bakış 22/122 m konumunda, kuru kumda ve enkaz merkezinden yaklaşık
  33 m uzakta. İlk 22/118 noktası kum/toprak sınırında kaldığı görüntüde
  görüldü; dört metre kıyıya alındı. Alçak/ayakta iki kadraj eklendi.
- Enkaz testi ve dört negatif kontrol geçti; katman kuralları temiz.
  Görseller: d717940+ / c980b563, Chrome 153.0.8010.48, ANGLE Metal M2,
  2880×1800, hızlı mod; 8 çağrı / 45994 üçgen. Kare süresi ölçülmedi.
- Bu yalnızca yerleşim/ölçek çalışmasıdır. Nihai model, shader, iç mekân,
  cutscene veya yeni oyun başlangıcı tamamlandığı iddia edilmez.

## K-047 · 2026-09-20 · Bütçe görselden önce gelir

- **Tür:** değişmez kural eklendi (kullanıcı kararı)
- **Neden:** K-044 görsel hedefi yarı gerçekçiliğe taşıdı ama iki şey aynı
  kaldı: fansız M2 (K-001) ve kare süresi bütçesi (ort ≤ 16.7 ms, p95 ≤ 20).
  Su yüzeyi, şeffaflık/yansıma ve ağır shader bütçeyi en çok zorlayan üçlüdür.
  Kural yazılmasaydı "güzel görünsün" ile "60 fps" çarpıştığında hangisinin
  kazandığı her seferinde yeniden tartışılırdı.
- **Kural:** çakışmada bütçe kazanır. Görsel özellik `kare-suresi.mjs`'ten
  geçmeden "bitti" sayılmaz; geçmiyorsa ucuzlatılır ya da geri alınır. Bütçe
  gevşetilmez. Yarı gerçekçilik bir HEDEF, 60 fps bir SINIR.
- **Durum:** kare süresi borcu DURUYOR (K-037). Kullanıcı "testi sonra
  yaparsın" dedi; şarj takıldığında ilk iş o ölçüm — ve artık yalnızca eski
  borç değil, yeni görsel yönün ilk sınavı.

## K-048 · 2026-09-20 · Codex'in işi gözden geçirildi ve `main`'e alındı

- **Tür:** inceleme (AGENTS.md §6.6) + birleştirme (kullanıcı onayı)
- **Ölçtüm:** katman/çevre/beden 23 OK, ada yüzeyi + enkaz 11 OK, arkadaş ve
  ses senaryoları 109 OK, açılış testi (TR+EN) ve harita geçti, yeni negatif
  kontrollerin altı sabotajı da yakalandı. Kadrajları kendim render edip baktım.
- **İyi bulduklarım:** (1) `ada-yuzeyi.js` tasarım yüksekliği ile ÇİZİLEN
  üçgenin yüksekliğini ayırdı — benim "tek kaynak" dediğim yer aslında
  yanlıştı, enterpolasyon farkı falezde oyuncuyu havaya kaldırırdı; (2) test
  fonksiyonu kendisiyle değil, gerçek ağlara ışın atarak doğruluyor (676
  örnek, 0.0000008 m); (3) yarığın TAMAMI örneklenince benim geçidimin
  aslında inilemez olduğu ortaya çıktı (1.627 > 0.85), 5 m düz çekirdekle
  0.398'e indi; (4) kaya sahanlığının elle yazdığım ikinci kaynağı (su
  altındaydı) yarık yolunun ucundan türetilerek kaldırıldı.
- **Açık bıraktıklarım (kod bozuk değil, borç):**
  1. İki zemin kaynağı yan yana duruyor: adada `adaYuzeyiM`, dilimde eski düz
     `zeminYuksekligiM` (+ `ana.js`'te adsız `-8`). Dilim adaya taşınınca eski
     fonksiyon SİLİNMELİ.
  2. Üç ajan var, kurallar iki ajan anlatıyor: Codex'in commit'leri `claude:`
     önekiyle atılmış ve dal `codex/ada-enkaz`. §6.3'ün amacı kimin ne yaptığı
     görünsün; AGENTS §6'ya üçüncü ajan (önek, port, iş alanı) eklenmeli.
  3. Üslup kayması: `ada-yuzeyi.js` ve `enkaz.js` sıkışık yazılmış; `aralikM`
     → `adim` gibi BİRİM EKİ düşüren adlandırmalar var (§5.3 tam bunun için).
  4. Enkaz kabuğu 14×3.2 şablonundan 24×4.2'ye ölçekleniyor (boyuna 1.71,
     enine 1.31): pencereler uzuyor. Nihai model doğrudan 24 m'de çizilmeli.
  5. Karar olmayan fikirler `OYUN-TASARIMI.md`'ye girdi; tasarım belgesi
     kararların tek kaynağı olmalı, fikirler günlükte/panoda beklemeli.

## K-049 · 2026-09-20 · Tür kararı: yazılmış omurga + yaşayan et (Model 2)

- **Tür:** tasarım kararı (kullanıcı) + üç değişmez kural değişikliği
- **Kullanıcı:** "biraz türü yanlış seçtim sanırım, daha çok hikâye oyunu
  bazlı olsa daha iyi olurdu." Üç model sunuldu; **Model 2** seçildi:
  günlerin sabit kırılma anları yazılır (fırtına, sal, kriz, 8–12 sahne),
  o anların NASIL geçeceği ilişkiden gelir. Model 3 (tam anlatı) reddedildi:
  arkadaşın kendi kararları süse dönerdi ve yazılan AI anlamsızlaşırdı.
- **Kalıcı ölüm DURUYOR** (kullanıcı: "bu oyunu unique yapan bu").
  Hikâye oyunu + kalıcı ölüm gerilimi bilerek kabul edildi.
- **Kural 1 değişti — kimlik.** Eski: "kim olduğu asla öğrenilmez, ipuçları
  çelişir." Yeni: geçmişi öğrenilmez ama KENDİSİ öğrenilir; çelişen ipucu
  yok, hiç ipucu yok. Sebep (kullanıcı): "onun o gizli kişiliği, fakat arada
  olan samimiyet ve aramızda yaşanan olaylar ona bağlanmamızı sağlar."
  Çelişen ipuçları insanı bulmaca kutusu yapar; bağlanmayı zorlaştırır.
- **Kural 2 değişti — izler kalktı.** 6. günün "kaynağı belirsiz izleri"
  çıkarıldı (kullanıcı: "boşverelim"). Ek gerekçe: adada koca bir enkaz
  varken her iz "kazadandır" diye açıklanıyor, gerilim doğmadan sönüyordu.
- **Kural 3 değişti — ölümün kaynağı.** Arkadaş artık tehditten ÖLMEZ;
  hayvan ve doğa yaralar, yıpratır. Ölüm ancak oyuncunun BİRİKMİŞ
  davranışının sonucudur ve ani değildir: günlerce görünür çöküş, defalarca
  müdahale fırsağı. Sebep (kullanıcı): "bizim bilmediğimiz bir şekilde
  ölmesin; bizim hareketlerimiz yüzünden, uzun birikimler üstüne olsun."
- **Ortadaki gerilim (3–7. gün) için öneri kabul edildi:** arkadaşın kendi
  krizi omurga, kıtlık basınç, hava saat. Dönen köpek gündelik tehdit olarak
  kalır, kavis taşımaz.
- **Çıktı:** `docs/HIKAYE-OMURGASI.md` — 12 günün gün gün taslağı, dokuz
  yazılmış sahne, sahne sözleşmesi (tetik/kontrol/süre/varyant/kalıcı iz/
  kaçırılırsa) ve altı açık soru. Taslaktır; karar verilen maddeler
  `OYUN-TASARIMI.md`'ye taşınacak.

---

## K-050 · 2026-09-20 · Hikâye omurgasının dört kararı (altı sorudan beşi)

- **Tür:** tasarım kararı (kullanıcı). K-049'un bıraktığı altı açık sorudan
  beşi yanıtlandı; biri açık kaldı.
- **Cutscene sayısı: 3, şimdilik.** Kullanıcı: "bence daha çok olmalı ama
  şimdilik 3 diyelim sonra ekleriz." Uyanış (1. gün, 30–40 sn) · fırtınada
  UYANMA ANI (8. gece, 15–20 sn) · kapanış (12. gün, seçimden SONRA).
  Sayı bilinçli olarak açık uçlu: değişmez kural "sayılı ve kısa" diyor,
  "üç" demiyor (AGENTS.md §2).
- **Fırtınada kontrol uyanma anında alınır ve hemen bırakılır.** Ben
  kaçışın tamamını cutscene yapmanın bedelini söyledim: arkadaşın o gecedeki
  varyantı (kolundan çeker / bekler / tek gider) oyunun en okunur davranış
  anıdır — kontrol alınırsa oyuncu bir KARAR okumaz, bir SAHNE izler.
  Kullanıcı uyanma anını seçti; varyant oyuncunun elindeyken oynanacak.
- **İlk ateş 2. gün; ilk gece ateşsiz.** Sebep: "bedeli olan" ilk an
  burada doğuyor. Ateş ilk akşam hediye edilirse hayatta kalma basıncı
  başlangıçta sıfırlanır ve "ilk geceyi yalnız mı geçirdin" diye
  hafızaya yazılacak bir şey kalmaz.
- **9. günün çöküşü her oyunda olur, şiddeti fırtınadaki davranışa göre
  değişir.** Reddedilen seçenek: "yalnızca kötü davranıldıysa" — iyi oynayan
  oyuncu için 8–12. günlerin gerilimi tamamen düşerdi. Bu biçimiyle omurga
  yazılı kalır (Model 2) ama sonuç oyuncunun hikâyesi olur.
- **Ekrandaki satırlar duyum/durum cümleleridir** ("üşüyorsun", "o hâlâ
  orada"), oyuncunun iç sesi değil. Sebep: iç ses oyuncuya ne hissettiğini
  söyler ve tasarım pusulasını (tutumunu kendin belirlersin) kısar.
- **AÇIK KALDI:** 11. gün (sessiz gün) gerçekten boş mu kalsın? Kullanıcı:
  "şu an bundan emin değilim, daha sonra konuşuruz." Seçenekler duruyor:
  tam boş + gece sahnesi · kısa gün (~10 dk) · küçük bir dürtü.
- **Yan bulgu (aynı oturumda ölçüldü):** `OYUN-TASARIMI.md` §3 takviminde
  K-049 ile kaldırılan "6+ kaynağı belirsiz izler" satırı duruyordu —
  kural değişmiş, tablo değişmemişti. Düzeltildi. Aynı türden bir tutarsızlık
  iki yerde aynı kuralı tutan her belgede olabilir; §6 bloğunu bir test
  denetliyor ama takvim tablosunu hiçbir şey denetlemiyor.

---

## K-051 · 2026-09-21 · Kod K-049'u çiğniyordu: arkadaş köpekten ölüyordu

- **Tür:** hata (kural ihlali), ölçülerek bulundu. Karar yeni değil — K-049
  zaten "arkadaş tehditten ÖLMEZ" diyordu; kod o karara göre güncellenmemişti.
- **Nasıl bulundu:** oyun omurga kipine geçtikten sonra arkadaşın adadaki
  davranışını ölçmek için 10 dakikalık bir koşu yaptım (tarayıcısız, saf sim).
  Arkadaş 5. dakikadan sonra donmuş görünüyordu: karar `isiga-don`, hiç
  hareket yok. Donmanın sebebi hareket değildi — **arkadaş 4.7. dakikada
  ölmüştü**: `durum 'oldu'`, `olumSebebi 'tehdit'`, üç ısırık. Ölü arkadaşın
  güncelleme bloğu hiç çalışmadığı için "donmuş" görünüyordu.
- **Neden kimse görmedi:** senaryo testi (`moral-dip-olum`) tam tersini
  ölçüyordu — "müdahale yoksa arkadaş öldü" ve "ölüm ikinci saldırıda".
  Yani test, kural değişmeden önceki davranışı koruyordu. K-049 belgelere
  işlenmiş, koda ve teste işlenmemişti.
- **Düzeltme üç yerde:**
  1. `sim/tehdit.js`: ısırık yalnızca OYUNCU için ölümcül.
  2. `sim/dunya.js`: arkadaşın ısırığı yaraya çevrilir, ölüm yolu kapandı.
  3. `sim/son.js`: `arkadasOldu(durum, 'tehdit')` artık **hata fırlatır**.
     Kural kodda duruyor; biri yeniden bağlarsa oyun sessizce değil görünür
     biçimde patlar (§5.4). Bu değişmez hemen işe yaradı: `arkadas-beden-gece`
     kadrajının `arkadasOlsun: 'tehdit'` ayarını yakaladı.
- **Yeni ölüm sebebi adı: `'cokus'`** — K-049'un "birikmiş çöküş" ölümü.
  `bedenHali` onu YERDE gösterir ('kendi' ağaçta asılıdır). Çöküşün kendisi
  (9. gün krizi, günlerce görünür bozulma) henüz YAZILMADI; sebep adı ve
  bedenin görünüşü hazır.
- **Senaryo yeniden yazıldı** (`tehdit-olduremez`): umursamaz arkadaş
  ısırılır, yaralanır ve YAŞAR; oyuncu yanına gidince hiç ısırılmaz (5 → 0)
  ve bu bedelli davranış güveni yükseltir (+0.18). Sabotajı da yeni kurala
  göre: ısırığı ölüme çeviren değişiklik YAKALANIYOR.
- **Ders (§5.9 için):** bir kural değiştiğinde onu KORUYAN testler de
  değişmelidir; yoksa test eski kuralın bekçisi olur ve yeni kuralın
  ihlalini "geçti" diye onaylar.

---

## K-052 · 2026-09-21 · Zaman sistemi: melez (takvim akar, hikâye önkoşulla ilerler)

- **Tür:** tasarım kararı (kullanıcı). K-005'teki "12 gün / 4 saat" kararını
  ve sahne sözleşmesinin "kaçırılırsa" maddesini değiştirir.
- **Kullanıcı:** "Acaba oyunda zaman sistemi günler üstünden değil de önemli
  anlar üzerinden mi olsa, böylece cutscene kaçırılmaz, gelişmeler oldukça
  ilerler oyun, belli bir sınır zaman içinde sıkışmaz."
- **Ölçüm kararı destekledi:** sabit takvimde 12 günlük koşu yapıldı
  (`tests/uzun-kosu.mjs`). Oyuncu yerinde durunca **11 sahnenin 9'u
  kaçıyordu** — hikâye oyuncuya rağmen akıyor ve kimse görmüyordu.
- **Seçilen model (üç seçenekten):** MELEZ.
  - Gün/gece ve hayatta kalma ZAMANA bağlı kalır (açlık, ateş, köpek).
  - Sahnenin tetiği "8. gün" değil, **önkoşul + en erken gün**. Önkoşul bir
    ÖNCEKİ sahnenin kalıcı izidir; zincir böyle kurulur.
  - Koşullar sağlanınca sahne **ÇAĞIRIR**: dünya oyuncuyu bekler, arkadaş
    oraya gider ve durur, iş yarım kalır. Ekranda ok, işaret ya da yazı YOK
    (K-041).
  - Oyuncu bir GÜN içinde gelmezse sahne **'sensiz'** olur: izi yine dünyada
    kalır, zincir ilerler. (Kullanıcı: "bir gün bekler, sonra sensiz olur".)
  - **Oyunun sonu takvimden değil HİKÂYEDEN gelir:** kapanış sahnesinin izi
    düşünce oyun biter. Takvimde yalnızca güvenlik tavanı kaldı (20. gün) ki
    hiç katılmayan bir oyuncuda dünya sonsuza kadar akmasın.
- **Ölçüldü (yeni modelde):** hiç katılmayan oyuncuda bütün zincir çözülüyor,
  dokuz sahne 'sensiz' geçiyor ve oyun 281.8 dakikada HİKÂYENİN sonunda
  bitiyor (hedef tempo 240 dk). Çağrıları izleyen oyuncuda 11 sahnenin 11'i
  sırayla oynuyor.
- **İnşa değişmezi eklendi:** `izGerekli` daha ÖNCEKİ bir sahnenin izi olmalı.
  Kendi izini ya da sonraki bir sahnenin izini bekleyen sahne HİÇ açılmaz;
  oyun sessizce yarıda kalır ve hiçbir hata vermez. Artık oyun yüklenmez.
- **Bedeli (kullanıcıya söylendi):** bir sahnenin "ne zaman" olduğu artık
  oyuncunun hızına bağlı; süre garantisi yok (hedef tempo var). Test yükü de
  arttı: zincirin kilitlenmediği her koşuda ölçülmeli.

## K-053 · 2026-09-23 · Görsel yön: yarı gerçekçilik bırakıldı, tutarlı stilize seçildi

- **Tür:** tasarım kararı (kullanıcı). K-044'ü değiştirir.
- **Kullanıcı:** "olabildiğince stres ve gerilim faktöründen vazgeçmeyip
  hikâyeyi hissettirebilirsek uygun."
- **Karar:** doğal, kasvetli ve **tutarlı stilize**. Gerçekçilik kovalanmaz.
- **Gerekçe:** bütçe sıfır (yalnızca CC0/ücretsiz varlık) ve hedef makine
  fansız. Yarı gerçekçilik bu iki sınırla birlikte tek kişilik üretimde
  ulaşılabilir değil. Daha önemlisi: ikinci denemede elde **tek bir 3B model
  yoktu** — "yarı gerçekçi" hedefi kodla üretilen geometriyle kovalanıyordu.
- **Karşılığında ne kaybedilmedi:** gerilim. Gerilim ışıktan, karanlıktan,
  sesten, bedenin zamanlamasından ve gösterilmeyenden kurulur. Beşinin hiçbiri
  doku çözünürlüğüne bağlı değil.
- **Stil birliği tek tek varlıkların kalitesinden önemlidir:** farklı ellerden
  çıkmış ama aynı dilde konuşan bir dünya, tutarsız bir gerçekçilikten iyidir.
  CC0 karışımıyla çalışırken asıl risk budur.
- **Blok eşitliği artık denetleniyor:** `AGENTS.md` §2 ile
  `belge/OYUN-TASARIMI.md` §6'daki görsel yön bloğunun birebir aynı olması
  ikinci denemeden beri kuraldı ama test edilmiyordu ("ileride bir test bu
  eşitliği denetleyecek" diye borç bırakılmıştı). `testler/degismez-esitlik.sh`
  yazıldı; iki sabotajla sınandı.

## K-054 · 2026-09-23 · Zemin değişti: Godot 4.7 · masaüstü · tarayıcı bırakıldı

- **Tür:** teknik karar (kullanıcı, seçenekler sunulduktan sonra).
- **Ölçüm — kararın sebebi bu:** ikinci denemenin kodu 15.028 satır.
  Arkadaş (`src/ai/`) **748 satır = %5**. Test + araç 6.634 satır (%44);
  arazi, deniz, ışık, ağaç, beden, ses, kayıt, menü 7.646 satır (%51).
  3B model varlığı: **0 dosya**. Birinci deneme (`~/Projects/yeni-oyun`) aynı
  yığındaydı ve aynı yerde takıldı.
- **Teşhis:** sebep disiplinsizlik DEĞİLDİ. Disiplin olağanüstüydü — negatif
  kontrol, çıkış kodu 2, yapı damgası, "ölçtüğünü doğrula". Sebep araçtı:
  Three.js'te oyun yapmak, önce oyun motoru yazmak demek. 52 karar kaydının
  **9'u** ("ölçüm aracım yalan söyledi": K-003, K-012, K-013, K-014, K-015,
  K-016, K-019, K-023, K-032) motorun kendisiyle değil, motoru ölçen ev yapımı
  aletle ilgiliydi. Bir motorda bu dokuz kayıt hiç yazılmazdı.
- **Neden Godot, neden Unity değil:** `.tscn` ve `.tres` **düz metindir** —
  ajanlar sahneyi okuyup diff'leyebilir. Unity'de sahne YAML'dır ve iş
  editörde yapılır; ajan oraya bakamaz. Bu, §6.2'nin (iki ajan, diff'lenebilir
  kod) doğrudan gereği.
- **GDScript, C# değil:** .NET derleme adımı ajanların turunu yavaşlatır.
- **Tarayıcı bırakıldı:** tek kişilik, kalıcı ölümlü, kayıtsız bir oyuna
  paylaşım kolaylığı dışında hiçbir şey kazandırmıyordu; karşılığında fansız
  M2'de dar bir bütçe ve zayıf varlık boru hattı getiriyordu.
- **Taşınanlar:** bütün tasarım kararları (K-001…K-052), 48 ses dosyası (CC0,
  lisans defteriyle), mühendislik disiplininin özü.
  **Taşınmayanlar:** ~9.000 satır motor kodu — karşılıkları Godot'da hazır.
- **Ölçüldü (kurulum):** Godot 4.7.2.stable.official · Blender 5.2.2 LTS ·
  git-lfs 3.8.0 · ffmpeg 9.0.2. Boş proje `--headless --quit` ile 0 döndü.
  `testler/katman-kurallari.gd` ve `testler/degismez-esitlik.sh` yazıldı;
  dokuz negatif kontrolün dokuzu geçti.
- **Kurulumda bir hatam düzeltildi:** plan `sudo ln -s` ile `godot` komutunu
  elle bağlamayı söylüyordu; kurulum çıktısı brew'un ikiliyi zaten bağladığını
  gösterdi ("Linking Binary 'Godot' to '/opt/homebrew/bin/godot'"). Adım
  kaldırıldı.

## K-055 · 2026-09-23 · Tasarım gözden geçirmesi, tur 1: kapsam, zincir, gidiş, su

> Kullanıcı kod yazmadan önce mekanikleri baştan gözden geçirmek istedi:
> "her böyle aceleyle oyuna geçtiğimde çokça hata oldu ve yazılım sırasında
> fikir değişikliklerine gittik, bunu minimalleştirmemiz lazım." Haklı:
> K-049, K-050, K-051 ve K-052'nin dördü de kod yazıldıktan SONRA gelen
> tasarım değişiklikleriydi ve her biri yazılmışı sildi.

### Kapsam: 12 gün → 6 gün, 4 saat → 120 dakika (kullanıcı kararı)

- Gün uzunluğu değişmedi (~20 dk: gündüz ~13, alacakaranlık ~2, gece ~5).
  6 × 20 = 120. Üç perde duruyor: I (1–2), II (3–4), III (5–6).
- **Gerekçe:** iki deneme de 1. gün çalışmadan öldü. Tek kişi + AI ajanlarıyla
  4 saatlik anlatı üretmek aynı duvara üçüncü kez koşmak olurdu. Kaybedilen
  "uzunluk", kazanılan "bitme ihtimali".
- **Yan faydalar:** kalıcı ölüm 120 dakikada adil, 4 saatte zalim · oyuncu
  "arkadaş köpekten ölmüyormuş" kalıbını 6 günde öğrenemez · ada gerçekten
  elle tasarlanabilir boyutta kalır.
- **Yeni omurga:** (1) Uyanış · (2) Ateş ve yer · (3) Ayrılık ve köpek ·
  (4) Yaralı gün ve fırtına · (5) Çöküş ve sal · (6) Seçim.
  Kıtlık artık kendi günü değil, ayrılığın SEBEBİ. Yara ve fırtına aynı güne
  geldi — yorgun ve eksik halde sınava girmek eskisinden güçlü.
- **11. günün boşluğu (K-050'de açık kalan tek soru) kendiliğinden kapandı:**
  sıkıştırmada boş gün kalmadı.

### A1 · Zincir kırılabiliyordu — koşullu/koşulsuz iz ayrımı (düzeltme)

- **Bulgu:** fırtınanın izi `barinak-hasari` idi ve kriz + sal buna bağlıydı.
  Ama barınak ZORUNLU DEĞİL (3. gün "tek başına yapılabilir"). Barınak yoksa
  iz yok, iz yoksa kriz ve sal hiç tetiklenmiyor — **oyun kapanış sahnesine
  hiç ulaşamıyor**, 20 günlük güvenlik tavanına kadar boş akıyordu. Aynı
  kırılma 6. günde de vardı (`yara-ve-o-gecenin-hafizasi`, ama köpek
  sahnesinin üç sonucundan biri yarasız).
- **Düzeltme:** her sahne iki tür iz bırakır.
  - **Koşulsuz iz:** sahne oldu. Oyuncu ne yaparsa yapsın, orada olmasa bile
    düşer (`firtina-gecti`).
  - **Koşullu iz:** o sahnede ne yapıldı (`barinak-hasarli`, `yara-oyuncuda`).
- **Yeni değişmez:** zincirin önkoşulu YALNIZCA koşulsuz iz olabilir. Koşullu
  izler zinciri değil VARYANTLARI besler. K-052'deki "izGerekli daha önceki
  bir sahnenin izi olmalı" değişmezinin eksik kalan yarısıdır; aynı yerde
  denetlenecek — koşullu iz önkoşul olarak kullanılırsa oyun hiç yüklenmez.
- **Sonuç:** oyuncu hiçbir şey yapmasa bile oyun sonuna varır; ama bambaşka
  bir oyun olur.

### Gidiş: kalıyor, ama 5. günden önce olmuyor (kullanıcı kararı)

- Güven dibe vursa bile arkadaş 5. güne kadar gitmez: uzaklaşır, konuşmaz,
  ateşin karşı tarafında uyur — ama ORADADIR.
- **Gerekçe:** 12 günde bulup geri kazanmaya vakit vardı; 6 günde 3. gün
  giderse oyunun yarısı boş bir adada geçerdi. Gidiş 5–6. güne saklanınca
  tehdit bütün oyun boyunca ASILI kalır ve salın yanında ikinci bir son olur:
  kalkıp gittiği için seçimi o yapmış olur.
- **Geri kazanma mekaniği kaldırıldı** (bulmak, uzaktan bedelli jestle mesafe
  kapatmak). 6 güne sığmıyordu. `OYUN-TASARIMI.md` §4'teki "Gidiş ve geri
  kazanma" bölümü buna göre yeniden yazılacak.

### Su: tam ihtiyaç oluyor (kullanıcı kararı, B2)

- Susuzluk ikinci bir sayaç; hem oyuncuda hem arkadaşta işler.
- **Gerekçe (kullanıcı seçimi):** fedakârlık FIRSATI sayısını artırır. A3'te
  saptanan kırılganlık buydu — tez "sen açken vermek"e dayanıyor ama 120
  dakikada o durumun kaç kez oluşacağı belirsizdi. İkinci ihtiyaç fırsatı
  ikiye katlar.
- **Kabul edilen bedel:** ikinci sayaç, ikinci kaynak, kap sistemi, ikinci
  "aç mıyım / susadım mı" okunabilirlik sorunu. Tasarımın ucuz ve keskin
  kalması şart — birinci denemede yedi ihtiyaç vardı ve kalabalıktı.

## K-056 · 2026-09-24 · Tasarım gözden geçirmesi, tur 2: su, fiiller, moral, insan hissi

### İnsan hissi kural seviyesine çıktı (kullanıcı kararı)

> Kullanıcı: "yanımızdaki arkadaşı gerçek bir insan hissiyatı vermesini
> istiyorum."

Bu bir üslup tercihi değil, **kabul kriteridir**. LLM yok (değişmez kural),
geçmiş ipucu yok (K-049) — yani insanlık YALNIZCA davranıştan gelmek zorunda.
Kaynakları:

1. **Kendi gündemi var.** Sen olmasan da bir şey yapar: su içmeye gider, ateşe
   odun atar, oturup dinlenir. *Tepki veren şey evcil hayvandır; kendi işi olan
   şey insandır.* En önemli madde budur.
2. **Gecikme ve tereddüt.** Anında karar vermez (çağırınca 0.4–1.2 sn).
   Bazen başlar, durur, geri döner.
3. **Eksik dikkat.** Her şeyi görmez; arkası dönükken olanı bilmez.
4. **Seçici hafıza.** Belirli anları hatırlar (ilk gece yalnız mıydı, yaralıyken
   yanında mıydın), ayrıntıyı unutur.
5. **Tutarsızlık.** Aynı durumda hep aynı şeyi yapmaz.
6. **Beceriksizlik.** Bazen başaramaz: ateşi tutturamaz, düşürür, geç kalır.
   *Kusursuz olan şey insan değildir.*
7. **Bedensel süreklilik.** Yorulur, üşür, ıslanır, aksar — ertesi gün de sürer.
8. **Bakış.** En ucuz ve en güçlü kanal: ne zaman baktığı, ne kadar tuttuğu.

**Kişilik geçmişten değil ALIŞKANLIKTAN gelir.** "Hiç ipucu yok" kuralıyla
"gerçek insan" hedefi ancak böyle uzlaşır: hep ateşin aynı tarafına oturması,
yakıtı atmadan önce yoklaması, yürürken bir kez geriye bakması. Alışkanlık,
geçmiş anlatmadan kişilik verir.

**İllüzyon kırıcılar (kapalı liste, denetlenir).** Bu liste pozitif listeden
daha kıymetlidir çünkü her maddesi 3 dakikalık kayıtta gözle görülür:
anında tepki · kusursuz yol bulma (hiç takılmamak) · aynı animasyonun birebir
tekrarı · **görmediği şeye tepki vermek** (en çok kıran) · hiç boşta kalmamak ·
sürekli oyuncuya bakmak · hiçbir şeyi kendi başlatmamak · her zaman müsait
olmak · hiç yanılmamak · derdini kusursuz jestle anlatmak.

### Su: tasarımı (B2'nin uygulaması)

- **Dere açıklığın İÇİNDEDİR.** Evde su bedava; susuzluk yalnızca iki yerde
  ısırır: (1) 3. gün uzak yiyecek yolculuğunda, (2) 5. gün arkadaş kalkamazken.
  İkisi de oyunun zaten basınç istediği anlar.
- **Tek kap** (enkazdan, 1. gün). Bir dolum bir kişilik. Fedakârlık yeni bir
  sisteme değil **nesnenin kendisine** gömülü: bir kap, iki insan.
- Simetri: **yiyecek uzakta ve az; su yakında ama taşınmak zorunda.**
- Okunabilirlik iki kanal: açlık = ağırlaşma + derin nefes + "açsın";
  susuzluk = görüşün kenarında kuruluk + yutkunma + "susadın". Arkadaşta ihtiyaç
  **bakış yönünden** okunur (yiyeceğe mi, dereye/kaba mı bakıyor) — bu,
  animasyon setinin şartıdır.

### Fiil listesi: dört tuş (B3)

- **E** — bağlama göre etkileş. Elinde bir şey varsa **kendine kullan** (ye, iç).
  Dünyada: al, kabı doldur, ateşe yakıt at, barınağı kur/onar, salı it.
- **F** — elindekini **ona ver**.
- **Q** — çağır.  · **Shift** — koş.

Oyunun bütün ahlaki seçimi **tek tuş aralığına** iner: E kendine, F ona. Aynı
nesne, aynı an, iki tuş. Menü yok, çark yok.

### Günün ritmi (B4)

| Parça | Süre | İş |
|---|---|---|
| Gündüz | ~13 dk | Yiyecek, yakıt, su, barınak, yolculuk — **fırsatlar burada doğar** |
| Alacakaranlık | ~2 dk | Dönüş baskısı: karanlık basmadan kampta olmak |
| Gece | ~5 dk | Ateş başında. Az eylem, çok dikkat — **arkadaşı burada okursun** |

Gecenin "az eylem" olması kusur değil tasarımın kendisi: davranış tablosunun
görünür olduğu tek yer orası. Kabul kriteri olan 3 dakikalık kayıt da bir gece
sahnesi olacak. Gün içi döngü dört basınçtan doğar (yiyecek biter, yakıt biter,
kap boşalır, karanlık gelir) ve hepsi tek yöne bakar: **ışığın kenarına gitmek.**

### Tezin sağlamlığı — sayıya bağlandı

Endişe şuydu: "sen açken ver" görünmez bir değişkene bağlı ve 120 dakikada kaç
kez gerçekleşeceği belirsiz. Hedefler:

- 6 günde **12–16 bedelli fırsat** doğsun (ikinizin de ihtiyacı var, elde tek
  kaynak var, **ve arkadaş görebiliyor**).
- Yüksek güvene çıkmak için **5–6 tanesini** almak yetsin.
- Hiç almayan oyuncuda güven 3. gün ortaya, 5. gün dibe insin.
- **Saf simülasyon bunu ölçsün:** penceresiz koşan test
  `6 gün · 14 fırsat doğdu · 6'sı alındı · güven: yüksek` bassın. Tez, grafik
  yapılmadan önce doğrulanır.

### D2 · Cutscene sayısı kilitlendi

Üç tam cutscene (uyanış · fırtınanın uyanma anı · kapanış). Dördüncüsü bu
sürümde eklenmez. Sebep: "sonra ekleriz" en pahalı yol — cutscene kamera
sistemi, kontrol devri ve iskelet animasyonu demektir.
