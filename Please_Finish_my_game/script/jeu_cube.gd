extends Node2D

var dir = Directory.new()

var script_rand = preload("res://script/rand_texture.gd")

func _ready():
	
	get_node("Sprite").texture = load((script_rand.new().random_texture("user://Godot_test/cube")).replace(".import", ""))