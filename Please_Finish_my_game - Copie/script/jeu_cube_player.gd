extends Node2D

var script_rand = preload("res://script/rand_texture.gd")

func _input(event):
	if(event.is_action_pressed("ui_accept")):
		randomize()
		#print(script_rand.new().random_texture("res://ressources/img/game_01/cube/"))
		#print(EditorFileSystem.get_filesystem())
#		get_node("Sprite").texture = load("res://ressources/img/game_01/cube/cube_3.png")
#		print(get_node("Sprite").texture.get_path())
#		get_node("Sprite").texture = load((script_rand.new().random_texture("res://ressources/img/game_01/cube")).replace(".import", ""))
		get_node("TextureRect").texture = load((script_rand.new().random_texture("user://Godot_test/player")))
		#get_node("TextureRect").texture = load("user://Godot_test/player/cube_1.png")
