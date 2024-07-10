extends KinematicBody2D

var rotacion_laser = 0
var angulo = -60
var subiendo = false

func _ready():
	$CollisionShape2D/RayoLaserGarrapatas.hide()
	$CollisionShape2D/RayoLaserGarrapatas2.hide()

func _physics_process(delta):
	
	if angulo == -60: subiendo = true
	if angulo == 60: subiendo = false
	if subiendo: angulo += 1
	else: angulo -= 1
	rotacion_laser = angulo * PI/180
	
	if abs(position.y - Puntuacion.poscary) < 2000:
		if position.x > Puntuacion.poscarx:
			$CollisionShape2D/RayoLaserGarrapatas.aparecer(rotacion_laser + 3.14)
			$CollisionShape2D/RayoLaserGarrapatas2.aparecer(rotacion_laser + 3.14)
			$CollisionShape2D/RayoLaserGarrapatas.show()
			$CollisionShape2D/RayoLaserGarrapatas2.show()
			$CollisionShape2D/RayoLaserGarrapatas.position = $ojo_detras_1.position
			$CollisionShape2D/RayoLaserGarrapatas2.position = $ojo_detras_2.position
		else:
			$CollisionShape2D/RayoLaserGarrapatas.aparecer(rotacion_laser)
			$CollisionShape2D/RayoLaserGarrapatas2.aparecer(rotacion_laser)
			$CollisionShape2D/RayoLaserGarrapatas.show()
			$CollisionShape2D/RayoLaserGarrapatas2.show()
			$CollisionShape2D/RayoLaserGarrapatas.position = $ojo_delante_1.position
			$CollisionShape2D/RayoLaserGarrapatas2.position = $ojo_delante_2.position
	else:
		$CollisionShape2D/RayoLaserGarrapatas.hide()
		$CollisionShape2D/RayoLaserGarrapatas2.hide()

func _on_VisibilityNotifier2D_screen_exited():
	$desaparicion.start()

func _on_desaparicion_timeout():
	queue_free()
