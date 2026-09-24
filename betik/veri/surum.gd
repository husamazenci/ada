class_name Surum
extends RefCounted

# YAPI DAMGASI (AGENTS.md §5.5). İlk günden ekranda görünür.
#
# Sebep: damga yoksa "değişiklik görünmüyor" ile "değişiklik yüklenmedi"
# AYIRT EDİLEMEZ. Birinci denemede bu ayrım yapılamadığı için saatler harcandı.
#
# Damga sabit bir metin DEĞİL: simülasyonun kaynak dosyalarından hesaplanır.
# Kural değişince damga da değişir; "yeni yapı mı?" sorusu gözle cevaplanır.

const OYUN_ADI := "Ada"
const ASAMA := "faz-1"

const DAMGALANAN: Array[String] = [
	"res://betik/veri/ayarlar.gd",
	"res://betik/sim/dunya.gd",
	"res://betik/ai/guven.gd",
	"res://betik/ai/davranis.gd",
	"res://betik/veri/sahneler.gd",
]

static func _ozet() -> String:
	var h := 0
	for yol in DAMGALANAN:
		var f := FileAccess.open(yol, FileAccess.READ)
		if f == null:
			continue
		var metin := f.get_as_text()
		f.close()
		for i in metin.length():
			h = (h * 31 + metin.unicode_at(i)) & 0xFFFFFF
	return "%06x" % h

static func damga() -> String:
	return "%s · %s · %s" % [OYUN_ADI, ASAMA, _ozet()]

static func tam_damga() -> String:
	return "%s · Godot %s · %s" % [damga(), Engine.get_version_info()["string"],
		"hata ayıklama" if OS.is_debug_build() else "dağıtım"]
