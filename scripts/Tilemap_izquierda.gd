extends "res://scripts/TileMap.gd"

func _ready():
	var laseres = get_tree().get_nodes_in_group("Laser")
	for laser in laseres:
		add_collision_exception_with(laser)
