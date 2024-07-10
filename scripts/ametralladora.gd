extends KinematicBody2D

var Bala = load("res://Escenas/Bala.tscn")
var cargada = true
var reproduciendo = false

func _ready():
	pass
	
func _physics_process(delta):
	look_at(get_global_mouse_position())
	if Puntuacion.cartucho_obtenido:
		recargar()
		Puntuacion.cartucho_obtenido = false
	
func _on_tiempo_entre_balas_timeout():
	if Input.is_action_pressed("ui_disparar"):
		if cargada:
			if !reproduciendo and cargada:
				$fuego.play()
				reproduciendo = true
			var newBala = Bala.instance()
			get_parent().add_child(newBala)
			newBala.global_position = $pos_bala.global_position
			newBala.global_rotation = global_rotation
			newBala.dir = global_rotation
			Puntuacion.cant_balas -= 1
			if Puntuacion.cant_balas == 0 and cargada:
				cargada = false
				$fuego.stop()
				$sin_balas.play()
				$recargar_timer.start()
		else:
			$gatillo.play()
	else:
		$fuego.stop()
		reproduciendo = false
			
func _on_recargar_timer_timeout():
	Puntuacion.cant_balas = Puntuacion.cant_balas_max
	cargada = true
	reproduciendo = false

func recargar():
	$recargar_timer.stop()
	_on_recargar_timer_timeout()



