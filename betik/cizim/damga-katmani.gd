extends CanvasLayer

# Damga ve HATA katmanı (AGENTS.md §5.4, §5.5).
#
# §5.4: hata konsola DEĞİL EKRANA DA basılır. Mantık ölse bile dünya çizilmeye
#       devam eder ve ikisi gözle ayırt edilebilir.
# §5.5: yapı damgası ilk günden görünür.
#
# §4: "Bütçe ölçümü TÖREN DEĞİLDİR: geliştirme derlemesinde kare süresi ve
#     çizim sayacı SÜREKLİ AÇIK bir HUD'da durur." İkinci denemede ölçüm 3,5
#     dakika sürüyor, şarj ve sessiz makine istiyordu; sonuç üç dalın
#     ölçülmeden birleşmesi oldu. Sürekli açık bir sayaç o kapıyı kapatıyor:
#     bütçe aşımı "ölçüm gününe" kalmaz, aşıldığı an görünür.
#
# Üçü de YALNIZCA hata ayıklama yapısında görünür — yayımlanan oyunda HUD yok.

const S := preload("res://betik/veri/surum.gd")

## Kare süresi bu kadar saniyede bir ekrana yazılır. Her karede yazmak
## sayıyı okunamaz hâle getiriyor — ve ölçümün kendisi maliyet oluyor.
@export_range(0.1, 2.0, 0.1) var butce_yenileme_sn: float = 0.5

var _damga: Label
var _hata: Label
var _butce: Label
var _hatalar: Array[String] = []
var _butce_sayaci := 0.0
var _kare_toplam := 0.0
var _kare_sayisi := 0
var _en_kotu := 0.0

func _ready() -> void:
	layer = 100
	# Çizicinin GERÇEK süresini ölçmek için açılması gerekiyor; kapalıyken
	# viewport_get_measured_render_time_* hep 0 döner.
	if OS.is_debug_build():
		RenderingServer.viewport_set_measure_render_time(get_viewport().get_viewport_rid(), true)
	visible = OS.is_debug_build()
	_damga = Label.new()
	_damga.text = S.tam_damga()
	_damga.position = Vector2(8, 4)
	_damga.add_theme_color_override("font_color", Color(1, 1, 1, 0.45))
	_damga.add_theme_font_size_override("font_size", 12)
	add_child(_damga)

	_hata = Label.new()
	_hata.position = Vector2(8, 24)
	_hata.add_theme_color_override("font_color", Color(1, 0.35, 0.25))
	_hata.add_theme_font_size_override("font_size", 13)
	add_child(_hata)

	_butce = Label.new()
	_butce.anchor_left = 1.0
	_butce.anchor_right = 1.0
	_butce.position = Vector2(-300, 4)
	_butce.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_butce.add_theme_font_size_override("font_size", 12)
	add_child(_butce)

func hata_bildir(metin: String) -> void:
	# Aynı hata imzası tekrar basılmaz; imza DEĞİŞİNCE yeniden bildirilir.
	if metin in _hatalar:
		return
	_hatalar.append(metin)
	push_error(metin)
	_hata.text = "\n".join(_hatalar)


func _process(delta: float) -> void:
	if not visible:
		return
	# DUVAR SAATİ YETMEZ. Vsync açıkken kare süresi ekran yenilemesine
	# kilitlenir ve HER ŞEY 16.7 ms çıkar — ilk yazışımda HUD tam olarak bunu
	# gösterdi, yani hiçbir şey göstermedi. İkinci denemenin "rAF aralığından
	# ölçme" hatasının Godot'daki karşılığı bu (§5.8).
	#
	# Bu yüzden asıl sayı ÇİZİCİNİN ÖLÇÜLEN SÜRESİdir: CPU + GPU. Bütçede
	# kalıp kalmadığımızı söyleyen o; duvar saati yalnızca takılmayı gösterir.
	_kare_toplam += delta
	_kare_sayisi += 1
	_en_kotu = maxf(_en_kotu, delta)
	_butce_sayaci += delta
	if _butce_sayaci < butce_yenileme_sn:
		return
	var vp := get_viewport().get_viewport_rid()
	# GPU SAYACI BU MAKİNEDE ÇALIŞMIYOR. Ölçüldü (2026-09-24, Apple M2 /
	# Metal, Godot 4.7.2): viewport_get_measured_render_time_gpu 960 kare
	# boyunca 0.000 döndü, CPU tarafı ise düzgün çalışıyor (0.34 ms).
	# "cpu + gpu" diye bir başlık yazsaydım GPU dolu olsa bile sayı temiz
	# görünürdü — ölçtüğümü sandığım şey ölçmek istediğim şey olmazdı (§5.8).
	# Bu yüzden GPU hiç yazılmıyor ve BÜTÇE HÜKMÜ BURADAN VERİLMİYOR:
	# hükmü `araclar/butce.gd` verir, vsync KAPALI koşturarak.
	var cpu_ms := RenderingServer.viewport_get_measured_render_time_cpu(vp)
	var duvar_ms := (_kare_toplam / float(_kare_sayisi)) * 1000.0
	var kotu_ms := _en_kotu * 1000.0
	var cizim := int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
	var ucgen := int(Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME))

	# Kırmızı ölçütü TAKILMA: duvar saati vsync'e kilitli olduğu için ortalama
	# hiçbir şey söylemez, ama en kötü kare takılmayı dürüstçe gösterir.
	_butce.add_theme_color_override("font_color",
		Color(1, 0.35, 0.25) if kotu_ms > 20.0 else Color(1, 1, 1, 0.45))
	_butce.text = "duvar %.1f ms · en kötü %.1f ms\nçizici cpu %.2f ms · gpu ölçülemiyor\n%d çizim · %d üçgen" % [
		duvar_ms, kotu_ms, cpu_ms, cizim, ucgen]
	_butce_sayaci = 0.0
	_kare_toplam = 0.0
	_kare_sayisi = 0
	_en_kotu = 0.0
