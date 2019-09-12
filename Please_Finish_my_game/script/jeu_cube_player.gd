extends Node2D

var dir = Directory.new()

func _input(event):
	if(event.is_action_pressed("ui_accept")):
		get_node("Sprite").set_texture(scan_dir("res://ressources/img/game_01/cube/"))

func scan_dir(path):
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
			files += scan_dir(new_path)
		else:
			var name = path+"/"+file_name
			if ! ".import" in name:
				files.push_back(name)
		file_name = dir.get_next()
	dir.list_dir_end()
	print(files[randi()%files.size()])