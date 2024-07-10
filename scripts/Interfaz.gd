extends CanvasLayer

signal reiniciar_nivel
var ultima_puntuacion = 0
var puntuacion_maxima = 0
var primera_vez = true
var mensaje_entre_niveles

var datos_partida = {
	ultima = 0,
	mejor = 0
}

func _ready():
	var path = Directory.new()
	if(!path.dir_exists("user://Cave_Alien_Fighting")):
		path.open("user://")
		path.make_dir("user://Cave_Alien_Fighting")
		
	cargar_partida()

	$Mensaje.hide()
	$Jugar.hide()
	$Score.hide()
	$best.hide()
	$last.hide()
	$bestnum.hide()
	$lastnum.hide()
	if primera_vez == true: 
		$tutorial.show()
		primera_vez = false
	else: $tutorial.hide()
	
func game_over():
	$Jugar.show()
	$Score.hide()
	$Mensaje.text = "Has muerto"
	$Mensaje.show()
	$best.show()
	$last.show()
	$bestnum.show()
	$lastnum.show()
	$lastnum.text = str(ultima_puntuacion)
	$bestnum.text = str(puntuacion_maxima)
	
	#guardar la puntuación:
	var save = File.new()
	save.open("user://Cave_Alien_Fighting" + String(1) + ".sav", File.WRITE)
	var datos_guardar = datos_partida
	datos_guardar.ultima = ultima_puntuacion
	datos_guardar.mejor = puntuacion_maxima
	save.store_line(to_json(datos_guardar))
	save.close()
	
func update_score(Puntos):
	if Puntos >= puntuacion_maxima:
		puntuacion_maxima = Puntos

func _on_Jugar_pressed():
	$Jugar.hide()
	$Score.show()
	$tutorial.hide()
	$best.hide()
	$last.hide()
	$bestnum.hide()
	$lastnum.hide()
	primera_vez = false
	emit_signal("reiniciar_nivel")

	
func _process(delta):
	ultima_puntuacion = Puntuacion.distancia
	$Score.text = str(ultima_puntuacion)
	update_score(ultima_puntuacion)
		
	if Input.is_action_pressed("ui_accept") and ($Jugar.visible == true or $tutorial.visible == true):
		$Jugar.hide()
		$Score.show()
		$tutorial.hide()
		$best.hide()
		$last.hide()
		$bestnum.hide()
		$lastnum.hide()
		primera_vez = false
		emit_signal("reiniciar_nivel")


func cargar_partida():
	var cargar = File.new()
	if(!cargar.file_exists("user://Cave_Alien_Fighting" + String(1) + ".sav")):
		return
	cargar.open("user://Cave_Alien_Fighting" + String(1) + ".sav", File.READ)
	var datos_cargar = datos_partida
	while(!cargar.eof_reached()):
		var dato_provisional = parse_json(cargar.get_line())
		if (dato_provisional != null):
			datos_cargar = dato_provisional
	cargar.close()
	ultima_puntuacion = datos_cargar.ultima
	puntuacion_maxima = datos_cargar.mejor
	$lastnum.text = str(ultima_puntuacion)
	$bestnum.text = str(puntuacion_maxima)


