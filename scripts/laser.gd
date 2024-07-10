extends KinematicBody2D

func _ready():
	
	var pulpos = get_tree().get_nodes_in_group("Cthulu")
	for pulpo in pulpos:
		add_collision_exception_with(pulpo)
	
	var pulpos_boss = get_tree().get_nodes_in_group("Cthulu_boss")
	for pulpo_boss in pulpos_boss:
		add_collision_exception_with(pulpo_boss)
	
	var rocas = get_tree().get_nodes_in_group("Rocas_y_obstaculos")
	for roca in rocas:
		add_collision_exception_with(roca)
	
	var fires = get_tree().get_nodes_in_group("Bullet")
	for fire in fires:
		add_collision_exception_with(fire)
	
	
