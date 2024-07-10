extends StaticBody2D

func _ready():
	
	var fires = get_tree().get_nodes_in_group("Bullet")
	for fire in fires:
		add_collision_exception_with(fire)
	
	var laseres = get_tree().get_nodes_in_group("Laser")
	for laser in laseres:
		add_collision_exception_with(laser)
