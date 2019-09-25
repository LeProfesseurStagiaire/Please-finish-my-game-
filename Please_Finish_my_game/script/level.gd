extends Node2D

var wall = preload("res://scene/jeu_cube.tscn")

func _on_Timer_timeout():
	randomize()
	var wall_instance = wall.instance()
	wall_instance.position.x = get_node("Node2D").position.x + get_viewport().size.x + 10
	self.add_child(wall_instance)
	get_node("Timer").wait_time = rand_range(3,5)
	print(get_node("Timer").wait_time)