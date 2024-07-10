extends KinematicBody2D

var dir = 0
var speed = 3000

func _ready():
	var babacuadros = get_tree().get_nodes_in_group("Cuadros_de_baba")
	for babacuadro in babacuadros:
		add_collision_exception_with(babacuadro)
	
	var herr = get_tree().get_nodes_in_group("Herramientas_grupo")
	for her in herr:
		add_collision_exception_with(her)
	
	var recargas = get_tree().get_nodes_in_group("Cartuchos")
	for recarga in recargas:
		add_collision_exception_with(recarga)
	
	var estaciones = get_tree().get_nodes_in_group("Estacion_de_gas")
	for estacion in estaciones:
		add_collision_exception_with(estacion)
	
	var carros = get_tree().get_nodes_in_group("Carro")
	for carro in carros:
		add_collision_exception_with(carro)
	
	var coats = get_tree().get_nodes_in_group("Escudito")
	for coat in coats:
		add_collision_exception_with(coat)
	
	var lavac = get_tree().get_nodes_in_group("Fuego")
	for lavc in lavac:
		add_collision_exception_with(lavc)
	
	var laseres = get_tree().get_nodes_in_group("Laser")
	for laser in laseres:
		add_collision_exception_with(laser)
	
	var lavas = get_tree().get_nodes_in_group("Zanja")
	for lava in lavas:
		add_collision_exception_with(lava)
	
	add_collision_exception_with(self)

func _physics_process(delta):
	var move = move_and_collide(Vector2(cos(dir) * speed * delta, sin(dir) * speed * delta))
	if move:
		if move.collider.is_in_group("Rocas_y_obstaculos"):
			queue_free()
			
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
