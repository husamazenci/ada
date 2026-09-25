class_name Animasyonlar
extends RefCounted

# ARKADAŞIN KULLANDIĞI KLİPLER — kapalı liste.
#
# Kütüphanede 43 animasyon var; oyun bunların altısını kullanıyor. Listenin
# kapalı olmasının sebebi, defter ve söz listelerininkiyle aynı (K-059, K-063):
# klip adı koda string olarak serpilirse er geç biri yanlış yazılır ve hata
# ancak o sahneye gelindiğinde, sessiz bir "animasyon oynamıyor" olarak
# görünür. Burada tek yerde duruyor ve bir test her birinin kütüphanede
# GERÇEKTEN var olduğunu denetliyor.
#
# Soldaki ad OYUNUN durumu, sağdaki satıcının klip adı. Satıcı bir gün adı
# değiştirirse tek satır değişir.

const KAYNAK := "res://varlik/karakter/animasyon/UAL1_Standard.glb"

# DİKKAT: sağdaki adlar GLB'nin içindeki adlar DEĞİL, Godot'nun içe
# aktarma sonrası verdiği adlardır. İçe aktarıcı "_Loop" ekini KIRPAR ve onu
# döngü işareti olarak kullanır: dosyada "Idle_Loop" yazar, kütüphanede
# "Idle" olur. İlk yazışımda dosyadaki adları yazdım ve altısından üçü
# bulunamadı — kapalı liste + test bunu ilk koşuda yakaladı, oysa koda
# serpilmiş stringler olsaydı ancak o sahneye gelindiğinde sessiz bir
# "animasyon oynamıyor" olarak görünecekti.
const KLIPLER := {
	"dur": "Idle",
	"yuru": "Walk",
	"otur_giris": "Sitting_Enter",
	"otur": "Sitting_Idle",
	"otur_cikis": "Sitting_Exit",
	"cokus": "Death01",
}

# Döngülü olması GEREKENLER. Döngüyü içe aktarıcı "_Loop" ekinden kendisi
# kuruyor; bu liste onun doğru kurduğunu DENETLEMEK için var. "Giriş/çıkış" ve
# "çöküş" tek seferliktir — çöküş döngüye alınırsa arkadaş sonsuza kadar yere
# yığılıp yığılıp durur.
# --- KÖPEK (K-071) ---
# Ayrı bir kütüphane: köpek animasyonlarını kendi modeli taşıyor
# (varlik/hayvan/Husky.gltf), insan rigiyle ilgisi yok. Liste yine KAPALI,
# yine aynı sebeple: klip adı koda serpilirse biri yanlış yazılır ve hata
# "hayvan kıpırdamıyor" diye sessizce görünür.
const KOPEK_KAYNAK := "res://varlik/hayvan/Husky.gltf"
const KOPEK_KLIPLER := {
	"bekle": "Idle_2_HeadLow",   # ışığın sınırında, başı alçak, koku alıyor
	"dolan": "Walk",             # çemberin çevresinde
	"atil": "Gallop",            # saldırı
	"isir": "Attack",
	"cekil": "Walk",             # geri çekilme
}
const KOPEK_DONGULU := ["bekle", "dolan", "atil", "cekil"]

const DONGULU := ["dur", "yuru", "otur"]

# Kök hareketi KAPALI sürüm kullanılıyor (UAL1_Standard, _RM değil).
# Sebep: hareketi `betik/cizim/arkadas.gd` sürüyor — mesafe bandı güvenden,
# tempo moralden geliyor. Kök hareketli klip o iki kanalı ezerdi.
const KOK_HAREKETI_VAR := false

static func dogrula() -> Array:
	var hata: Array = []
	var gorulen: Array = []
	for oyun_adi in KLIPLER:
		var klip: String = KLIPLER[oyun_adi]
		if klip in gorulen:
			hata.append("aynı klip iki oyun durumuna bağlı: %s" % klip)
		gorulen.append(klip)
		if klip.strip_edges().is_empty():
			hata.append("%s: klip adı boş" % oyun_adi)
	for d in DONGULU:
		if not KLIPLER.has(d):
			hata.append("döngülü listede olmayan durum: %s" % d)
	if "cokus" in DONGULU:
		hata.append("İHLAL: çöküş döngüye alınmış — arkadaş sonsuza kadar yığılır")
	if KOK_HAREKETI_VAR:
		hata.append("İHLAL: kök hareketli klip seçilmiş — mesafe ve tempo kanallarını ezer")
	for d in KOPEK_DONGULU:
		if not KOPEK_KLIPLER.has(d):
			hata.append("köpek: döngülü listede olmayan durum: %s" % d)
	if "isir" in KOPEK_DONGULU:
		hata.append("İHLAL: ısırma döngüye alınmış — köpek durmadan ısırır")
	return hata
