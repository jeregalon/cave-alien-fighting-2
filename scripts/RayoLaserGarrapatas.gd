extends Node2D

const MAX_LENGTH = 1000
onready var beam = $Rayo
onready var end = $Final
onready var rayCast2D = $RayCast2D
var rotacion_del_laser = 0

func _physics_process(delta):
	var rot_rayo = Vector2(cos(rotacion_del_laser), sin(rotacion_del_laser))
	var max_cast_to = rot_rayo.normalized() * MAX_LENGTH
	rayCast2D.cast_to = max_cast_to
	if rayCast2D.is_colliding():
		end.global_position = rayCast2D.get_collision_point()
		if rayCast2D.get_collider().is_in_group("Carro"): 
			Puntuacion.quemao = true
			$danio_timer.start()
	else:
		end.global_position = rayCast2D.cast_to
	beam.rotation = rayCast2D.cast_to.angle()
	beam.region_rect.end.x = end.position.length()
	
	var rocas = get_tree().get_nodes_in_group("Rocas_y_obstaculos")
	for roca in rocas:
		rayCast2D.add_exception(roca)
	
	var pulpos = get_tree().get_nodes_in_group("Cthulu")
	for pulpo in pulpos:
		rayCast2D.add_exception(pulpo)
	
	var fuegos = get_tree().get_nodes_in_group("Fuego")
	for fuego in fuegos:
		rayCast2D.add_exception(fuego)
	
	var zanjas = get_tree().get_nodes_in_group("Zanja")
	for zanja in zanjas:
		rayCast2D.add_exception(zanja)
	
func aparecer(rotacion):
	rotacion_del_laser = rotacion

func _on_danio_timer_timeout():
	Puntuacion.quemao = false
