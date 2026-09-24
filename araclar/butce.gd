extends SceneTree

# PERFORMANS TABAN ÇİZGİSİ (AGENTS.md §4).
#
# Çizim çağrısı ve üçgen sınırları "Faz 1'de Godot sayaçlarıyla yeniden taban
# çizgisi alınarak konur" deniyordu — ikinci denemenin 150/250k sayıları
# Three.js dönemine aitti ve taşınamazdı. Bu araç o tabanı ölçer.
#
# VSYNC KAPATILIR. Açıkken kare süresi ekran yenilemesine kilitlenir ve HER
# ŞEY 16.7 ms çıkar: bütçe hiç aşılmıyor görünür, boşluk (headroom) hiç
# ölçülemez. İkinci denemenin "rAF aralığından ölçme" hatasının Godot'daki
# karşılığı tam olarak budur (§5.8).
#
# --headless ile ÇALIŞMAZ: çizici yok, sayaçlar boş gelir.
# Çıkış: 0 · 1 · 2.

const ISINMA_SN := 2.0     # ilk kareler derleme/yükleme yüzünden anlamsız
const OLCUM_SN := 10.0

var _isinma := 0.0
var _gecti := 0.0
var _kareler: Array[float] = []
var _cizim := 0
var _ucgen := 0
var _nesne := 0

func _initialize() -> void:
	var sahne := load("res://sahne/dunya.tscn")
	if sahne == null:
		printerr("ÇALIŞTIRILAMADI: sahne yüklenemedi"); quit(2); return
	root.add_child(sahne.instantiate())
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = 0

func _process(dt: float) -> bool:
	if _isinma < ISINMA_SN:
		_isinma += dt
		return false
	_gecti += dt
	_kareler.append(dt)
	_cizim = maxi(_cizim, int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)))
	_ucgen = maxi(_ucgen, int(Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME)))
	_nesne = maxi(_nesne, int(Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME)))
	if _gecti < OLCUM_SN:
		return false

	if _kareler.size() < 60:
		printerr("ÇALIŞTIRILAMADI: %d kare ölçüldü — çok az" % _kareler.size())
		quit(2); return true
	if _cizim == 0:
		printerr("ÇALIŞTIRILAMADI: çizim sayacı 0 — çizici yok mu? (--headless?)")
		quit(2); return true

	_kareler.sort()
	var toplam := 0.0
	for k in _kareler:
		toplam += k
	var ort_ms := (toplam / float(_kareler.size())) * 1000.0
	var p95_ms: float = _kareler[int(float(_kareler.size()) * 0.95)] * 1000.0
	var en_kotu_ms: float = _kareler[_kareler.size() - 1] * 1000.0

	# §5.8: her rapor ÖLÇÜM KOŞULLARINI yazar.
	print("")
	print("ölçüm koşulları")
	print("  yapı         %s" % preload("res://betik/veri/surum.gd").tam_damga())
	print("  GPU          %s" % RenderingServer.get_video_adapter_name())
	print("  çözünürlük   %dx%d" % [
		DisplayServer.window_get_size().x, DisplayServer.window_get_size().y])
	print("  vsync        KAPALI (açıkken her şey 16.7 ms çıkar)")
	print("  süre         %.1f sn · %d kare" % [_gecti, _kareler.size()])
	print("")
	print("kare süresi")
	print("  ortalama     %6.2f ms   (bütçe ≤ 16.70)  %s" % [ort_ms, "GEÇTİ" if ort_ms <= 16.7 else "AŞILDI"])
	print("  p95          %6.2f ms   (bütçe ≤ 20.00)  %s" % [p95_ms, "GEÇTİ" if p95_ms <= 20.0 else "AŞILDI"])
	print("  en kötü      %6.2f ms" % en_kotu_ms)
	print("")
	print("sahne sayaçları (taban çizgisi — sınır BURADAN konur)")
	print("  çizim çağrısı %5d" % _cizim)
	print("  üçgen         %5d" % _ucgen)
	print("  nesne         %5d" % _nesne)

	var kaldi := (ort_ms <= 16.7) and (p95_ms <= 20.0)
	quit(0 if kaldi else 1)
	return true
