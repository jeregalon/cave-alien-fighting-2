extends KinematicBody2D

var movimiento = Vector2()

func _ready():
	var pulpos = get_tree().get_nodes_in_group("Cthulu")
	for pulpo in pulpos:
		add_collision_exception_with(pulpo)
	
	var zanjitas = get_tree().get_nodes_in_group("Zanja")
	for zanjita in zanjitas:
		add_collision_exception_with(zanjita)
		
func _physics_process(delta):
	var collision = move_and_collide(movimiento * delta)
	if collision:
		if collision.collider.is_in_group("Carro"):
			queue_free()
		if collision.collider.is_in_group("Rocas_y_obstaculos"):
			queue_free()
	
func _on_VisibilityNotifier2D_screen_exited():
	$desaparicion_timer.start()

func _on_desaparicion_timer_timeout():
	queue_free()
