#!/usr/bin/env python3
"""Ada yerleşimi ölçümü — belge/ADA-YERLESIMI.md'deki tabloları üretir.

Sayılar elle yazılmaz. Konum değişince tablo da ölçüt denetimi de
buradan yeniden alınır (§5.8: ölçtüğünü doğrula).
"""
import math

HIZ_YURU = 2.0        # betik/cizim/oyuncu.gd · yurume_hiz_ms
HIZ_KOS = 3.4         # kosu_hiz_ms
GUN_SN = 1200.0       # 20 dakikalık gün

# betik/veri/ayarlar.gd'den
UYARI_GUN = 0.015 + 0.020          # KOPEK_ULUMA_SURESI + KOPEK_KENAR_SURESI
SALDIRI_PENCERESI_GUN = 0.005      # KOPEK_SALDIRI_PENCERESI
SOZ_GUN = 0.08                     # SOZ_SURESI_GUN
KURTARMA_M = 3.0                   # KURTARMA_MESAFESI_M
ATES_ISIK_M = 6.0                  # ATES_ISIK_YARICAPI_M

YER = {
    "KAMP":            (0, 0),
    "DERE":            (18, -12),
    "ODUN-yakin":      (-28, 15),
    "ODUN-dogu":       (22, 28),
    "ODUN-uzak":       (-44, -30),
    "ENKAZ":           (-95, -120),
    "KAYALIK":         (120, 75),
    "YIYECEK-kuzey":   (85, -95),
    "YIYECEK-bati":    (-130, 60),
    "SAL":             (-40, 255),
}

OLCUTLER = [
    ("kamp ↔ dere",              ["DERE"],                          0,   60),
    ("kamp ↔ en yakın odun",     ["ODUN-yakin", "ODUN-dogu"],      30,   80),
    ("kamp ↔ en yakın yiyecek",  ["YIYECEK-kuzey", "YIYECEK-bati"], 120, 240),
    ("kamp ↔ sal",               ["SAL"],                         240, 10**9),
    ("enkaz ↔ kamp",             ["ENKAZ"],                         0,  180),
    ("kamp ↔ kayalık",           ["KAYALIK"],                       0,  200),
]


def mesafe(a, b):
    ax, az = YER[a]
    bx, bz = YER[b]
    return math.hypot(bx - ax, bz - az)


def main():
    print("KAMPTAN MESAFELER")
    print("%-16s %8s %8s" % ("yer", "metre", "saniye"))
    for k in YER:
        if k == "KAMP":
            continue
        m = mesafe("KAMP", k)
        print("%-16s %8.0f %8.0f" % (k, m, m / HIZ_YURU))

    print("\nÖLÇÜT DENETİMİ")
    kalan = 0
    for ad, yerler, alt, ust in OLCUTLER:
        m = min(mesafe("KAMP", y) for y in yerler)
        ok = alt <= m <= ust
        if not ok:
            kalan += 1
        print("  %s %-26s %6.0f m (%3.0f sn) · hedef %.0f–%s m"
              % ("✓" if ok else "✗", ad, m, m / HIZ_YURU, alt,
                 "∞" if ust > 10**8 else "%.0f" % ust))

    uyari = UYARI_GUN * GUN_SN
    pencere = SALDIRI_PENCERESI_GUN * GUN_SN
    toplam = uyari + pencere
    print("\nKÖPEK UYARISINA YETİŞİLİYOR MU (tepki süresi %.0f sn)" % toplam)
    for ad in ("ODUN-yakin", "ODUN-dogu", "ODUN-uzak"):
        m = mesafe("KAMP", ad)
        yuru = (m - KURTARMA_M) / HIZ_YURU
        kos = (m - KURTARMA_M) / HIZ_KOS
        if yuru > toplam:
            kalan += 1
        print("  %s %-12s %5.0f m · dönüş %3.0f sn yürüyerek · %3.0f sn koşarak"
              % ("✓" if yuru <= toplam else "✗", ad, m, yuru, kos))

    soz = SOZ_GUN * GUN_SN
    print("\n'BEKLE' SÖZÜ TUTULABİLİR Mİ (ömür %.0f sn)" % soz)
    for ad in ("ODUN-uzak", "YIYECEK-kuzey", "SAL"):
        m = mesafe("KAMP", ad)
        gd = 2 * m / HIZ_YURU
        print("  %-14s %5.0f m · gidiş-dönüş %4.0f sn → %s"
              % (ad, m, gd, "tutulabilir" if gd <= soz else "TUTULAMAZ"))

    xs = [p[0] for p in YER.values()]
    zs = [p[1] for p in YER.values()]
    print("\nADA KABACA %.0f m × %.0f m (kıyı payı 120 m ile)"
          % (max(xs) - min(xs) + 120, max(zs) - min(zs) + 120))
    print("EN YAKIN ODUN, ateş çemberinin %.1f KATI uzağında"
          % (mesafe("KAMP", "ODUN-yakin") / ATES_ISIK_M))
    return 1 if kalan else 0


if __name__ == "__main__":
    raise SystemExit(main())
