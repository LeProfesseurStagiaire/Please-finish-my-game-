extends Node2D

var dir = Directory.new()

var script_rand = preload("res://script/rand_texture.gd")

func _ready():
	var d = Directory.new()
	if !(d.dir_exists("user://Godot_test")):
		print("ERR: dir does not exist ")
		d.open("user://")
		d.make_dir("user://Godot_test")

func _input(event):
	if(event.is_action_pressed("ui_accept")):
		#print(script_rand.new().random_texture("res://ressources/img/game_01/cube/"))
		#print(EditorFileSystem.get_filesystem())
		get_node("Sprite").texture = load("res://ressources/img/game_01/cube/cube_3.png")
		print(get_node("Sprite").texture.get_path())
		get_node("Sprite").texture = load((script_rand.new().random_texture("res://ressources/img/game_01/cube")).replace(".import", ""))