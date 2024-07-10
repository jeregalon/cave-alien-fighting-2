extends StaticBody2D

func _ready():
	var balas = get_tree().get_nodes_in_group("Bullet")
	for bala in balas:
		add_collision_exception_with(bala)
	
	var laseres = get_tree().get_nodes_in_group("Laser")
	for laser in laseres:
		add_collision_exception_with(laser)
	
	var herr = get_tree().get_nodes_in_group("Herramientas_grupo")
	for her in herr:
		add_collision_exception_with(her)
	
	var estaciones = get_tree().get_nodes_in_group("Estacion_de_gas")
	for estacion in estaciones:
		add_collision_exception_with(estacion)
	
	var coats = get_tree().get_nodes_in_group("Escudito")
	for coat in coats:
		add_collision_exception_with(coat)
