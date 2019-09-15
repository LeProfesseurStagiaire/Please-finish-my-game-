extends Node2D

var dir = Directory.new()

var script_rand = preload("res://script/rand_texture.gd")

func _input(event):
	if(event.is_action_pressed("ui_accept")):
		#print(script_rand.new().random_texture("res://ressources/img/game_01/cube/"))
		#print(EditorFileSystem.get_filesystem())
		get_node("Sprite").texture = load("res://ressources/img/game_01/cube/cube_3.png")
		print(get_node("Sprite").texture.get_path())
		get_node("Sprite").texture = load((script_rand.new().random_texture("res://ressources/img/game_01/cube")).replace(".import", ""))