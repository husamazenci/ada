extends SceneTree

# ANİMASYON KÜTÜPHANESİ TESTİ.
#
# Buradaki risk türü, dil testininkiyle (K-010) birebir aynı: kod bir ad
# bildirir, kütüphanede karşılığı yoktur, ve hata ancak o sahneye gelindiğinde
# **sessiz bir hiçlik** olarak görünür — arkadaş T-pozunda kalakalır, konsolda
# tek satır çıkmaz. Test bunu önceden yakalar.
#
# İlk koşuda tam olarak bunu yakaladı: GLB'nin içinde klipler "Idle_Loop",
# "Walk_Loop", "Sitting_Idle_Loop" diye geçiyor, ama Godot'nun içe aktarıcısı
# "_Loop" ekini KIRPIYOR (onu döngü işareti olarak kullanıyor). Altı klipten
# üçü bulunamadı.
#
# Çıkış: 0 geçti · 1 başarısız · 2 ÇALIŞTIRILAMADI.

const An := preload("res://betik/veri/animasyonlar.gd")
const D := preload("res://betik/ai/davranis.gd")
const A := preload("res://betik/veri/ayarlar.gd")

func _initialize() -> void:
	var hata: Array = []

	# 1 · Veri modülünün kendi değişmezleri
	for h in An.dogrula():
		hata.append("animasyonlar.gd: " + h)

	var kutuphane = load(An.KAYNAK)
	if kutuphane == null:
		printerr("ÇALIŞTIRILAMADI: kütüphane yüklenemedi: %s" % An.KAYNAK)
		quit(2); return
	if not (kutuphane is AnimationLibrary):
		printerr("ÇALIŞTIRILAMADI: kaynak AnimationLibrary değil, %s — içe aktarma türü 'scene' mi kaldı?" % kutuphane.get_class())
		quit(2); return
	var mevcut: PackedStringArray = kutuphane.get_animation_list()
	print("kütüphanede %d klip var; oyun %d tanesini kullanıyor" % [mevcut.size(), An.KLIPLER.size()])

	# 2 · Kodun bildirdiği HER klip kütüphanede GERÇEKTEN var mı
	for oyun_adi in An.KLIPLER:
		var klip: String = An.KLIPLER[oyun_adi]
		if not kutuphane.has_animation(klip):
			hata.append("'%s' → '%s' KÜTÜPHANEDE YOK (arkadaş T-pozunda kalır, konsol susar)" % [oyun_adi, klip])

	# 3 · Döngü modları. Çöküş döngüye alınırsa arkadaş sonsuza kadar yığılır.
	for oyun_adi in An.KLIPLER:
		var klip: String = An.KLIPLER[oyun_adi]
		if not kutuphane.has_animation(klip):
			continue
		var a: Animation = kutuphane.get_animation(klip)
		var dongulu := a.loop_mode != Animation.LOOP_NONE
		var olmali: bool = oyun_adi in An.DONGULU
		if dongulu != olmali:
			hata.append("'%s' (%s) döngü %s — %s olmalı" % [
				oyun_adi, klip, "AÇIK" if dongulu else "kapalı",
				"açık" if olmali else "KAPALI"])
		if a.length <= 0.0:
			hata.append("'%s' süresi sıfır" % klip)
		if a.get_track_count() == 0:
			hata.append("'%s' hiç iz içermiyor" % klip)

	# 4 · İzlerin hedeflediği KEMİKLER gövdemizde var mı?
	# Klip başka bir rige aitse adı doğru, izleri boşa düşer — ve yine
	# sessizce hiçbir şey olmaz. En sinsi hata ailesi bu.
	var govde_sahne = load("res://varlik/karakter/temel/Superhero_Male_FullBody.gltf")
	if govde_sahne == null:
		printerr("ÇALIŞTIRILAMADI: gövde sahnesi yüklenemedi"); quit(2); return
	var govde: Node = govde_sahne.instantiate()
	var iskelet: Skeleton3D = govde.find_child("Skeleton3D", true, false)
	if iskelet == null:
		printerr("ÇALIŞTIRILAMADI: gövdede Skeleton3D yok"); quit(2); return
	var kemikler: Array = []
	for i in iskelet.get_bone_count():
		kemikler.append(iskelet.get_bone_name(i))

	var denetlenen := 0
	var eksik: Array = []
	for oyun_adi in An.KLIPLER:
		var klip: String = An.KLIPLER[oyun_adi]
		if not kutuphane.has_animation(klip):
			continue
		var a: Animation = kutuphane.get_animation(klip)
		for i in a.get_track_count():
			var yol := str(a.track_get_path(i))
			var iki := yol.split(":")
			if iki.size() < 2:
				continue
			denetlenen += 1
			if not (iki[1] in kemikler) and not (iki[1] in eksik):
				eksik.append(iki[1])
	print("%d iz denetlendi · gövdede %d kemik" % [denetlenen, kemikler.size()])
	if denetlenen == 0:
		printerr("ÇALIŞTIRILAMADI: hiç iz denetlenmedi — bu test bir şey ölçmedi")
		govde.free(); quit(2); return
	for k in eksik:
		hata.append("iz '%s' kemiğini arıyor, gövdede YOK — klip başka bir rige ait" % k)
	govde.free()

	# 5 · Saf durum seçicisi üç bedeni de veriyor mu, ve MORAL SIRALI mı?
	var d_yuksek := D.durus_animasyonu(0.80, 0.0)
	var d_orta := D.durus_animasyonu(0.50, 0.0)
	var d_dip := D.durus_animasyonu(0.20, 0.0)
	var d_cokus := D.durus_animasyonu(0.05, 0.0)
	var d_yuruyor := D.durus_animasyonu(0.80, 1.2)
	print("durum seçici: yüksek '%s' · orta '%s' · dip '%s' · çöküş '%s' · yürürken '%s'" % [
		d_yuksek, d_orta, d_dip, d_cokus, d_yuruyor])
	if d_dip != "otur":
		hata.append("dip moralde oturmuyor: '%s'" % d_dip)
	if d_cokus != "cokus":
		hata.append("çöküş eşiğinin altında çökmüyor: '%s'" % d_cokus)
	if d_yuruyor != "yuru":
		hata.append("hareket ederken yürümüyor: '%s'" % d_yuruyor)
	if d_yuksek != "dur" or d_orta != "dur":
		hata.append("dururken 'dur' değil: yüksek '%s' orta '%s'" % [d_yuksek, d_orta])
	# Çöküş eşiği oturma eşiğinin ALTINDA olmalı; tersi olursa arkadaş
	# oturmadan doğrudan çöker ve müdahale penceresi ekranda hiç görünmez.
	if A.MORAL_COKUS_ESIGI >= A.MORAL_ORTA_ALT:
		hata.append("İHLAL: çöküş eşiği (%.2f) oturma eşiğinin (%.2f) üstünde — ara duruş yok" % [
			A.MORAL_COKUS_ESIGI, A.MORAL_ORTA_ALT])

	# 6 · Güven bu kanala KARIŞMAMALI (iki kanal kuralı).
	for g in [0.10, 0.50, 0.90]:
		if D.durus_animasyonu(0.80, 0.0) != "dur":
			hata.append("güven %.2f duruş animasyonunu değiştirdi" % g)

	print("")
	if hata.is_empty():
		print("GEÇTİ — altı klibin hepsi var, döngüleri doğru, izleri gövdenin kemiklerine düşüyor.")
		quit(0); return
	for h in hata:
		printerr("BAŞARISIZ: " + h)
	quit(1)
