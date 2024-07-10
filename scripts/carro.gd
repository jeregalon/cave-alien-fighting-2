extends KinematicBody2D

export (int) var velocidad
var movimiento = Vector2()
signal choque
signal lava_escudo
var movy = 0
var acelerando = false
export var gas_max = 100
export var gas_actual = 100
export var vida_max = 100
export var vida_actual = 100
var barra_gas
var barra_vida
var protection = true

func _ready():
	hide()
	velocidad = 0
	barra_gas = get_tree().get_nodes_in_group("Barra_gas_carro")[0]	
	barra_vida = get_tree().get_nodes_in_group("Barra_vida_carro")[0]	
	actualizar_barra_vida()
	
	var fires = get_tree().get_nodes_in_group("Bullet")
	for fire in fires:
		add_collision_exception_with(fire)
	
	$humo.emitting = false
	$tuercas.emitting = false
	
func _physics_process(delta):
	movimiento = Vector2()
	
	if vida_actual > 25:
		$humo.emitting = false
		$tuercas.emitting = false
	else:
		$humo.emitting = true
		$tuercas.emitting = true
	
	if gas_actual > 0:
		if Input.is_action_pressed("ui_arriba"): 
			movy = 4.5
			acelerando = true
			$Camera2D.smoothing_speed = 5
		else: 
			movy = 1.5
			acelerando = false
			$Camera2D.smoothing_speed = 2
		if Input.is_action_pressed("ui_derecha"):
			movimiento.x += 1.5
		if Input.is_action_pressed("ui_izquierda"):
			movimiento.x -= 1.5
		if Input.is_action_pressed("ui_abajo"):
			movy = -0.5
	else: 
	#	movy = 0
	#	movimiento.x += 0
		emit_signal("choque")
		
	movimiento.y -= movy
	
	if movimiento.length() > 0:
		movimiento = movimiento * velocidad
	
	if vida_actual < 0.1: emit_signal("choque")
	
	var collision = move_and_collide(movimiento * delta)
	if collision:
		
		if collision.collider.is_in_group("ret") and protection == false:
			vida_actual -= 1.5
			actualizar_barra_vida()
			if !$CollisionShape2D.disabled: $choquecito.play()
		
		if collision.collider.is_in_group("Rocas_y_obstaculos") and protection == false:
			if acelerando: vida_actual -= 2.0
			else: vida_actual -= 1.4
			if !$CollisionShape2D.disabled: $choquecito.play()
			actualizar_barra_vida()
			
		if collision.collider.is_in_group("Estacion_de_gas"):
			if gas_actual <= 60: gas_actual += 40
			else: gas_actual = 100
			actualizar_barra_gas()
		
		if collision.collider.is_in_group("Cartuchos"):
			if Puntuacion.cant_balas <= 75: Puntuacion.cant_balas += 25
			else: Puntuacion.cant_balas = 100
			Puntuacion.cartucho_obtenido = true
			
		if collision.collider.is_in_group("Herramientas_grupo"):
			if vida_actual <= 60: vida_actual += 40
			else: vida_actual = 100
			actualizar_barra_vida()
		
		if collision.collider.is_in_group("Escudito"):
			if !protection: protection = true
			$escudo.visible = true
			$proteccion_timer.stop()
			$proteccion_timer.start()
		
		if collision.collider.is_in_group("Zanja"):
			if !protection: emit_signal("choque")
			else: emit_signal("lava_escudo")

	if velocidad != 0 and (movimiento.x != 0 or movimiento.y != 0):
		if acelerando: gas_actual -= 0.2
		else: gas_actual -= 0.05
		actualizar_barra_gas()
		
	position += movimiento * delta
	Puntuacion.poscary = position.y
	Puntuacion.poscarx = position.x
	
func actualizar_barra_gas():
	barra_gas.value = gas_actual * barra_gas.max_value / gas_max

func actualizar_barra_vida():
	barra_vida.value = vida_actual * barra_vida.max_value / vida_max	
	
func inicio(pos):
	position = pos
	show()
	
func _on_proteccion_timer_timeout():
	$escudo.visible = false
	protection = false
