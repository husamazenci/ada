class_name Kayit
extends RefCounted

# TEK YUVALI ASKIYA ALMA (K-006). Elle kayıt ve yükleme YOKTUR: oyun sürerken
# tek yuvaya sürekli yazılır, oyuncu kaldığı yerden devam eder, ölüm
# kesinleştiği an yuva SİLİNİR ve oyun biter.
#
# Serileştirme dosya işleminden AYRI tutulur: `topla`/`yukle` yalnızca Sözlük
# ile çalışır. Sebep, gidiş-dönüş testinin dosya sistemine hiç dokunmadan
# koşabilmesi — ve asıl sebep şu: unutulan bir alan ancak deterministik
# karşılaştırmayla yakalanır, gözle değil.
#
# ÇAĞRI DURUMU BİLEREK KAYDEDİLMEZ (K-068). Askıya alma dünyayı sürdürür,
# ANI değil. Oyundan çıkıp ertesi gün dönen oyuncunun karşısında dünkü bağırışa
# hâlâ yürüyen bir arkadaş bulması yanlış olurdu; yeni bir Dunya zaten temiz bir
# Cagri ile doğar. Unutulmuş alan DEĞİL, verilmiş karardır — testler/cagri.gd
# yükleme sonrası makinenin boş olduğunu denetler.
#
# ÖZEL ALANLAR (_ ile başlayanlar) DA kaydedilir. Onlar "iç durum" diye
# atlanırsa oyun yüklendikten sonra sessizce başka türlü akar: eşik cümlesi
# ikinci kez belirir, günlük jest tavanı sıfırlanır, çöküş süresi geri sayar.

const SURUM := 1
const YUVA := "user://ada.kayit"

static func topla(d) -> Dictionary:
	return {
		"surum": SURUM,
		"gun": d.gun, "t": d.t,
		"yiyecek": d.yiyecek, "kap_dolu": d.kap_dolu, "mesafe_m": d.mesafe_m,
		"ates_yaniyor": d.ates_yaniyor,
		"ates_yakit": d.ates_yakit, "odun": d.odun,
		"ates_sondu_gece": d.ates_sondu_gece,
		# KÖPEK KAYDEDİLİR (çağrının aksine). Çağrı bir andır, köpek epizodu
		# bir dünya olayıdır: yarım kalmış bir saldırıya dönmek doğru.
		# "_bu_gece_geldi" özellikle şart — kaydedilmezse yükleme sonrası
		# köpek aynı gece İKİNCİ kez gelir.
		"kopek": {
			"durum": d.kopek.durum, "_kalan": d.kopek._kalan,
			"_bu_gece_geldi": d.kopek._bu_gece_geldi,
			"gorunme": d.kopek.gorunme_sayisi, "saldiri": d.kopek.saldiri_sayisi,
			"caydirma": d.kopek.caydirma_sayisi,
		},
		"_araya_girdi": d._araya_girdi, "kopek_sonucu": d.kopek_sonucu,
		"_bugun_odun": d._bugun_odun,
		"_ates_ihmali_bu_gece": d._ates_ihmali_bu_gece,
		"oyuncu_atesin_isiginda": d.oyuncu_atesin_isiginda,
		"arkadas_atesin_isiginda": d.arkadas_atesin_isiginda,
		"arkadas_gitti": d.arkadas_gitti, "arkadas_oldu": d.arkadas_oldu,
		"bitti": d.bitti, "bitis_sebebi": d.bitis_sebebi,
		"firsat_sayisi": d.firsat_sayisi, "alinan_firsat": d.alinan_firsat,
		"ihanet_sayisi": d.ihanet_sayisi,
		"_firsat_acik": d._firsat_acik, "_bugun_toplandi": d._bugun_toplandi,
		"gunluk": d.gunluk.duplicate(true), "duyumlar": d.duyumlar.duplicate(),
		"oyuncu": _kisi(d.oyuncu), "arkadas": _kisi(d.arkadas),
		"guven": {
			"deger": d.guven.deger, "moral": d.guven.moral, "ihmal": d.guven.ihmal,
			"_gun_icinde_yukselis": d.guven._gun_icinde_yukselis,
			"_cokus_suresi_gun": d.guven._cokus_suresi_gun,
			"bakim_gordu_bugun": d.guven.bakim_gordu_bugun,
		},
	}

static func yukle(d, veri: Dictionary) -> bool:
	# Kipi uymayan yuva ATILIR. İkinci denemede bunun yokluğu "cutscene
	# çalışmıyor" diye günlerce yanlış yerde arandı.
	if not veri.has("surum") or int(veri["surum"]) != SURUM:
		return false
	d.gun = int(veri["gun"]); d.t = float(veri["t"])
	d.yiyecek = int(veri["yiyecek"]); d.kap_dolu = bool(veri["kap_dolu"])
	d.mesafe_m = float(veri["mesafe_m"])
	d.ates_yaniyor = bool(veri["ates_yaniyor"])
	d.ates_yakit = float(veri["ates_yakit"]); d.odun = int(veri["odun"])
	d.ates_sondu_gece = int(veri["ates_sondu_gece"])
	var kp: Dictionary = veri["kopek"]
	d.kopek.durum = int(kp["durum"]); d.kopek._kalan = float(kp["_kalan"])
	d.kopek._bu_gece_geldi = bool(kp["_bu_gece_geldi"])
	d.kopek.gorunme_sayisi = int(kp["gorunme"])
	d.kopek.saldiri_sayisi = int(kp["saldiri"])
	d.kopek.caydirma_sayisi = int(kp["caydirma"])
	d._araya_girdi = bool(veri["_araya_girdi"])
	d.kopek_sonucu = String(veri["kopek_sonucu"])
	d._bugun_odun = int(veri["_bugun_odun"])
	d._ates_ihmali_bu_gece = bool(veri["_ates_ihmali_bu_gece"])
	d.oyuncu_atesin_isiginda = bool(veri["oyuncu_atesin_isiginda"])
	d.arkadas_atesin_isiginda = bool(veri["arkadas_atesin_isiginda"])
	d.arkadas_gitti = bool(veri["arkadas_gitti"]); d.arkadas_oldu = bool(veri["arkadas_oldu"])
	d.bitti = bool(veri["bitti"]); d.bitis_sebebi = String(veri["bitis_sebebi"])
	d.firsat_sayisi = int(veri["firsat_sayisi"]); d.alinan_firsat = int(veri["alinan_firsat"])
	d.ihanet_sayisi = int(veri["ihanet_sayisi"])
	d._firsat_acik = bool(veri["_firsat_acik"]); d._bugun_toplandi = int(veri["_bugun_toplandi"])
	d.gunluk = (veri["gunluk"] as Array).duplicate(true)
	d.duyumlar = (veri["duyumlar"] as Array).duplicate()
	_kisi_yukle(d.oyuncu, veri["oyuncu"]); _kisi_yukle(d.arkadas, veri["arkadas"])
	var g: Dictionary = veri["guven"]
	d.guven.deger = float(g["deger"]); d.guven.moral = float(g["moral"])
	d.guven.ihmal = float(g["ihmal"])
	d.guven._gun_icinde_yukselis = int(g["_gun_icinde_yukselis"])
	d.guven._cokus_suresi_gun = float(g["_cokus_suresi_gun"])
	d.guven.bakim_gordu_bugun = bool(g["bakim_gordu_bugun"])
	return true

static func _kisi(i) -> Dictionary:
	return {
		"aclik": i.aclik, "susuzluk": i.susuzluk, "yorgunluk": i.yorgunluk,
		"yarali": i.yarali, "yara_kalan_gun": i.yara_kalan_gun, "oldu": i.oldu,
		"_aclik_soylendi": i._aclik_soylendi, "_susuzluk_soylendi": i._susuzluk_soylendi,
	}

static func _kisi_yukle(i, v: Dictionary) -> void:
	i.aclik = float(v["aclik"]); i.susuzluk = float(v["susuzluk"])
	i.yorgunluk = float(v["yorgunluk"])
	i.yarali = bool(v["yarali"]); i.yara_kalan_gun = float(v["yara_kalan_gun"])
	i.oldu = bool(v["oldu"])
	i._aclik_soylendi = bool(v["_aclik_soylendi"])
	i._susuzluk_soylendi = bool(v["_susuzluk_soylendi"])

# --- dosya katmanı (tek yuva) ---

static func yaz(d) -> bool:
	var f := FileAccess.open(YUVA, FileAccess.WRITE)
	if f == null:
		return false
	f.store_string(JSON.stringify(topla(d)))
	f.close()
	return true

static func oku(d) -> bool:
	if not FileAccess.file_exists(YUVA):
		return false
	var f := FileAccess.open(YUVA, FileAccess.READ)
	if f == null:
		return false
	var metin := f.get_as_text()
	f.close()
	var veri = JSON.parse_string(metin)
	if typeof(veri) != TYPE_DICTIONARY:
		return false
	return yukle(d, veri)

static func sil() -> void:
	# Ölüm kesinleştiği an (K-006). Geri dönüş yok.
	if FileAccess.file_exists(YUVA):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(YUVA))

static func yuva_var_mi() -> bool:
	return FileAccess.file_exists(YUVA)
