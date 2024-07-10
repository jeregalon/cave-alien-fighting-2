extends StaticBody2D

func _ready():
	
	var nieves = get_tree().get_nodes_in_group("esfera_de_nieve")
	for nieve in nieves:
		add_collision_exception_with(nieve)
