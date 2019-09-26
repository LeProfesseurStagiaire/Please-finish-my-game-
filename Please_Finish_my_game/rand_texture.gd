# loaded texture are here : C:\Users\Ange\AppData\Roaming\Godot\app_userdata\PFMG_0.1\Godot_test\cube

#les fichiers qui fonctionnent se trouvent dans le dossier .import  et sont des extensions .stex (godot StreamTexture)
#pour en générer un, il faut glisser l'image dans un dossier de projet ouvert dans léditeur, le logiciel ouvert vas automatiquement
#créer le fichier .stex qu'il placera dans le dossier .import, il suffu de le récupérer et de le placer dans le dir recherché !

func random_texture(path):
	var d = Directory.new()
	if !(d.dir_exists("user://Godot_test")):
		print("ERR: dir does not exist ")
		d.open("user://")
		d.make_dir("user://Godot_test")
	randomize()
	var file_name
	var files = []
	var dir = Directory.new()
	var error = dir.open(path)
	if error!=OK:
		print("Can't open "+path+"!")
		return
	dir.list_dir_begin(true)
	file_name = dir.get_next()
	while file_name!="":
		if dir.current_is_dir():
			var new_path = path+"/"+file_name
			print("Found directory "+new_path+".")
			files += random_texture(new_path)
		else:
			var name = path+"/"+file_name
			files.push_back(name)
		file_name = dir.get_next()
	return files[randi()%files.size()]
	dir.list_dir_end()