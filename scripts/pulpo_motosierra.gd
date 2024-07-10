extends KinematicBody2D

export (int) var velocidad
var movimiento = Vector2()
var numero = 1
var tiempo_cambio_direccion = 1.0
var pegado = false
var stateMachine

func _ready():
	randomize()
	stateMachine = $AnimationTree.get("parameters/playback")
	
	var herr = get_tree().get_nodes_in_group("Herramientas_grupo")
	for her in herr:
		add_collision_exception_with(her)
	
	var estaciones = get_tree().get_nodes_in_group("Estacion_de_gas")
	for estacion in estaciones:
		add_collision_exception_with(estacion)
	
	var laseres = get_tree().get_nodes_in_group("Laser")
	for laser in laseres:
		add_collision_exception_with(laser)
	
	var coats = get_tree().get_nodes_in_group("Escudito")
	for coat in coats:
		add_collision_exception_with(coat)
	
	var recargas = get_tree().get_nodes_in_group("Cartuchos")
	for recarga in recargas:
		add_collision_exception_with(recarga)
	
func _physics_process(delta):
	movimiento = Vector2()
	
	if $iman.is_colliding():
		if $iman.get_collider().is_in_group("Carro"):
			$retencion1.disabled = false
			$retencion2.disabled = false
			if pegado == false:
				crecer_cabeza()
		elif pegado == true:
			decrecer_cabeza()
	
	if numero == 0 or numero == 8 or numero == 9 or numero == 14 or numero == 19: #abajo
		movimiento.y += 0.2 
		movimiento.x += 0
	if numero == 1 or numero == 5 or numero == 15 or numero == 4: #derecha
		movimiento.y += 0
		movimiento.x += 0.2
	if numero == 2  or numero == 3 or numero == 17 or numero == 20: #izquierda
		movimiento.y += 0
		movimiento.x -= 0.2
	if numero == 6 or numero == 10 or numero == 11 or numero == 16: #inferior derecha
		movimiento.y += 0.2 
		movimiento.x += 0.2
	if numero == 7 or numero == 12 or numero == 13 or numero == 18: #inferior izquierda
		movimiento.y += 0.2 
		movimiento.x -= 0.2
			
	if movimiento.length() > 0:
		movimiento = movimiento.normalized() * velocidad
	
	var collision = move_and_collide(movimiento * delta)
	if collision:
		if collision.collider.is_in_group("Bullet") or collision.collider.is_in_group("Zanja"):
			stateMachine.travel("muriendo")
			$CollisionShape2D.disabled = true
			$iman.enabled = false
			$retencion1.disabled = true
			$retencion2.disabled = true
		
		if collision.collider.is_in_group("Bullet"): Puntuacion.bono += 5
			
	position += movimiento * delta

func crecer_cabeza():
	stateMachine.travel("cabeza_creciendo")
	stateMachine.travel("cabeza_motosierra")
	pegado = true

func decrecer_cabeza():
	stateMachine.travel("cabeza_creciendo_reversa")
	stateMachine.travel("andando")
	pegado = false

func _on_cambio_direccion_timeout():
	numero = randi() % 21
	var numero_de_segundos = randi() % 20
	tiempo_cambio_direccion = numero_de_segundos / 10
	$cambio_direccion.wait_time = tiempo_cambio_direccion
	$cambio_direccion.start()
	
func _on_VisibilityNotifier2D_screen_exited():
	if position.y > Puntuacion.poscary:
		if !$CollisionShape2D.disabled: 
			Puntuacion.bono -= 10
		queue_free()
	
