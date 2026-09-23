class_name Surum
extends RefCounted

# Yapı damgası (AGENTS.md §5.5). İlk günden var, çünkü damga yoksa
# "değişiklik görünmüyor" ile "değişiklik yüklenmedi" ayırt edilemez.
# Saf veri: hiçbir görsel düğüm bilmez, ekrana kendisi basmaz.

const OYUN_ADI := "Ada"
const ASAMA := "faz-0"

static func damga() -> String:
	return "%s · %s · %s" % [OYUN_ADI, ASAMA, Time.get_datetime_string_from_system(false, true)]
