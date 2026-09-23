# Seslerin kaynağı ve lisansı

Bu klasördeki `.wav` dosyaları `tools/ses-hazirla.mjs` ile üretildi:
tek kanal, 32 kHz, 16 bit; uzun kayıtlar tek tek olaylara bölündü, düzeyleri
eşitlendi. Elle düzenlenmedi — yeniden üretmek için:

```
node tools/ses-hazirla.mjs <kaynak-dizini>
```

## Kaynak

**Owlish Media — "Sound Effects Pack"** · OpenGameArt.org
<https://opengameart.org/content/sound-effects-pack> · Lisans: **CC0** (kamu malı).
Atıf zorunlu değil; kaynak izlenebilsin diye yazılıyor.

İndirildi: 2026-09-19 (`Owlish Media Sound Effects.zip`, 142.4 MB — zip depoya
girmez, yalnızca aşağıdaki dosyalar kullanıldı).

| Rol (oyundaki an) | Kaynak dosya(lar) | Seçen |
|---|---|---|
| `nefes-sakin` — arkadaş iyiyken | `Human/breath-female.wav`, `Human/breath-female2.wav` | kullanıcı, dinleyerek |
| `nefes-korku` — köpek yaklaşınca | `Human/scared-breathing.wav` | kullanıcı |
| `aci` — ısırılınca | `Human/gasp1.wav` | kullanıcı |
| `yeme` — verdiğini yerken | `Human/drink-sip-and-swallow.wav` | kullanıcı |
| `dip` — morali dibe vurunca | `Human/yawn2.wav` | kullanıcı |

Seçim ölçütü (kullanıcı kararı, 2026-09-19): arkadaşın sesi kim olduğunu
ele vermez — nefes, iç çekme, boğuk inilti; çığlık ve kelime yok. Dosya
adlarındaki "female" kaynaktaki etiket; seçilenler büyük ölçüde perdesiz
(%3–9 perdeli), yani sesi değil havayı taşıyor.

## Köpek — Wikimedia Commons

İndirildi: 2026-09-19. Lisanslar Commons API'sinden (`extmetadata`) okundu;
kullanıcı her dosyayı lisansıyla birlikte görüp onayladı.

| Rol | Kaynak | Lisans |
|---|---|---|
| `dal-kirilmasi` | [Snapping twig (single).ogg](https://commons.wikimedia.org/wiki/File:Snapping_twig_(single).ogg) — stephan | **CC0** |
| `dal-kirilmasi` | [Snapping twig.ogg](https://commons.wikimedia.org/wiki/File:Snapping_twig.ogg) — stephan, pdsounds.org | **Kamu malı** |
| `uluma` | [Wolf howls.ogg](https://commons.wikimedia.org/wiki/File:Wolf_howls.ogg) — U.S. Fish and Wildlife Service | **Kamu malı** |

Köpeğin hırıltısı YOK: bulunan gerçek hırıltılar CC BY 2.5 (atıf zorunlu) ya
da BY-SA idi; kullanıcı eklemedi (2026-09-19). Uluma kaydı bir kurda ait;
dilimdeki yaban köpeğinin sesi olarak kullanılıyor (tür adı oyunda geçmez).
