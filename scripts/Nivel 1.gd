extends Node2D

var vida_carro = 100
var vida_carro_max = 100
var gas_carro = 100
var gas_carro_max = 100
var carro_velocidad = 200
var AliensAsesinados = 0
var num_cuadros = -1500
var gameoverllamado = false
var randomy

#variables lava
var posx = 1.3
var posy = 1.3
var num_celda = 0
var num_cuadro = 1
var ocupadas = [-1, -2, -3, -4]
var no_dibujar = false
var termine = false

#variables carga
var Motopulpo = preload("res://Escenas/pulpo_motosierra.tscn")
var crear_motopulpo = Motopulpo.instance()
var Estacion = preload("res://Escenas/Gas_station.tscn")
var crear_estacion = Estacion.instance()
var Herramienta = preload("res://Escenas/Herramienta.tscn")
var crear_herramienta = Herramienta.instance()
var Coat = preload("res://Escenas/escudo.tscn")
var crear_escudo = Coat.instance()
var Cart = preload("res://Escenas/cartucho.tscn")
var crear_cartucho = Cart.instance()
var Garr = preload("res://Escenas/garrapata.tscn")
var crear_garrapata = Garr.instance()

var m1 = "Cuidado con\nla lava"
var m2 = "Disparales a\nesos pulpos\nNo los dejes\nescapar"
var m3 = "Atento, que el\nsuelo se cuartea"
var m4 = "Suscribete a\nEl Inframundo de Josen\nen Youtube"
var m5 = "Sigueme en Facebook\nmanquito"
var m6 = "Usa el escudo\npara protegerte\nde los lasers"
var m7 = "Diviertete y\napoyame para\nseguir\ndesarrollando"
var m8 = "Sin gasolina\nno podras\navanzar"
var m9 = "Piensa\nrapidoo"

func _ready():
	randomize()
	$carro.velocidad = 0
	$carro.hide()
	
func escoger_nivel():
	
	Puntuacion.distancia = 0
	Puntuacion.bono = 0
	Puntuacion.gameover = false
	Puntuacion.cant_balas = 100
	Puntuacion.quemao = false
		
	$TileMap_zanjas/TileMapZL.clear()
	$TileMap_rocas/TileMap.clear()
	$TileMap_lava/TileMap.clear()
	
	obstaculizar()
			
	$carro.protection = true
	$carro/escudo.visible = true
	$carro.inicio($posicion_de_inicio.position)
	$carro.gas_actual = gas_carro_max
	$carro.vida_actual = vida_carro_max
	$carro.actualizar_barra_gas()
	$carro.actualizar_barra_vida()
	$carro.velocidad = carro_velocidad
	$carro/CollisionShape2D.disabled = false
	$Musica_de_fondo.play()
	$carro/proteccion_timer.start()
	$inicio_timer.start()
	
	var m = randi() % 9
	if m == 4: $carro/Interfaz/Mensaje.text = m1
	elif m == 3: $carro/Interfaz/Mensaje.text = m2
	elif m == 2: $carro/Interfaz/Mensaje.text = m3
	elif m == 1: $carro/Interfaz/Mensaje.text = m4
	elif m == 0: $carro/Interfaz/Mensaje.text = m5
	elif m == 5: $carro/Interfaz/Mensaje.text = m6
	elif m == 6: $carro/Interfaz/Mensaje.text = m7
	elif m == 7: $carro/Interfaz/Mensaje.text = m8
	elif m == 8: $carro/Interfaz/Mensaje.text = m9
	$carro/Interfaz/Mensaje.show()
	
func _on_inicio_timer_timeout():
	$motopulpo_timer.start()
	$herramienta_timer.start()
	$estacion_timer.start()
	$escudo_timer.start()
	$cartucho_timer.start()
	$lava_timer1.start()
	$garrapata_timer.start()
	gameoverllamado = false
	$carro/Interfaz/Mensaje.hide()

func _on_lava_timer1_timeout():
	$lava_timer.start()
	
func _process(delta):
	Puntuacion.distancia = abs(int($carro.position.y/500)) + Puntuacion.bono
	
	if Puntuacion.gameover and !gameoverllamado:
		gameoverllamado = true
		game_over()
	
	if Puntuacion.quemao == true and $carro.protection == false:
		$sonidito.play()
		$carro.vida_actual -= 0.5
		$carro.actualizar_barra_vida()

func game_over():
	
	$Musica_de_fondo.stop()
	$estacion_timer.stop()
	$herramienta_timer.stop()
	$escudo_timer.stop()
	$inicio_timer.stop()
	$cartucho_timer.stop()
	$garrapata_timer.stop()
	$ambiente_timer.stop()
	Puntuacion.quemao = false
	
	var pulpos = get_tree().get_nodes_in_group("Cthulu")
	for pulpo in pulpos:
		pulpo.queue_free()
	
	var garras = get_tree().get_nodes_in_group("Garrapatas")
	for garra in garras:
		garra.queue_free()
	
	var escudos = get_tree().get_nodes_in_group("Escudito")
	for escudo in escudos:
		escudo.queue_free()
	
	var herr = get_tree().get_nodes_in_group("Herramientas_grupo")
	for her in herr:
		her.queue_free()
	
	var gascar = get_tree().get_nodes_in_group("Estacion_de_gas")
	for gas in gascar:
		gas.queue_free()
	
	var recargas = get_tree().get_nodes_in_group("Cartuchos")
	for recarga in recargas:
		recarga.queue_free()
		
	$carro.hide()
	$carro.velocidad = 0
	$carro/CollisionShape2D.disabled = true
	$carro/Interfaz.game_over()

#Timers y generar enemigos e ítems	
func _on_estacion_timer_timeout():
	instanciar_estacion()

func instanciar_estacion():
	crear_estacion = Estacion.instance()
	add_child(crear_estacion)
	crear_estacion.position.y = $carro.position.y - 1066
	crear_estacion.position.x = randi() % 500
	$estacion_timer.start()	

func _on_herramienta_timer_timeout():
	instanciar_herramienta()
	
func instanciar_herramienta():
	crear_herramienta = Herramienta.instance()
	add_child(crear_herramienta)
	crear_herramienta.position.y = $carro.position.y - 1066
	crear_herramienta.position.x = randi() % 500
	$herramienta_timer.start()	
	
func _on_escudo_timer_timeout():
	instanciar_escudo()

func instanciar_escudo():
	crear_escudo = Coat.instance()
	add_child(crear_escudo)
	crear_escudo.position.y = $carro.position.y - 1066
	crear_escudo.position.x = randi() % 500
	$escudo_timer.wait_time = randi() % 10 + 6
	$escudo_timer.start()	
	
func _on_cartucho_timer_timeout():
	instanciar_cartucho()

func instanciar_cartucho():
	crear_cartucho = Cart.instance()
	add_child(crear_cartucho)
	crear_cartucho.position.y = $carro.position.y - 1066
	crear_cartucho.position.x = randi() % 500
	$cartucho_timer.start()	

func _on_motopulpo_timer_timeout():
	instanciar_motopulpo()

func instanciar_motopulpo():
	crear_motopulpo = Motopulpo.instance()
	add_child(crear_motopulpo)
	crear_motopulpo.position.x = randi() % 500
	crear_motopulpo.position.y = $carro.position.y - 3066
	if !gameoverllamado: $motopulpo_timer.start()	

func _on_garrapata_timer_timeout():
	instanciar_garrapata()

func instanciar_garrapata():
	crear_garrapata = Garr.instance()
	add_child(crear_garrapata)
	randomy = randi() % 2
	if randomy == 0: crear_garrapata.position.x = -500
	else: crear_garrapata.position.x = 1100
	crear_garrapata.position.y = $carro.position.y - 3066
	$garrapata_timer.wait_time = randi() % 7 + 10
	$garrapata_timer.start()	

func _on_mapa_timer_timeout():
	num_cuadros -= 1500
	obstaculizar()

func obstaculizar():
	#colocando las lavas y puentes
	for i in range (num_cuadros - 8, num_cuadros + 1492, 100):
		var pos_x_lava = (randi() % 2) - 5
		if pos_x_lava <= 0:
			$TileMap_zanjas/TileMapZL.set_cell(pos_x_lava, i, 0, false, false, false, Vector2(0,0))
		elif pos_x_lava > 0 and pos_x_lava <= 6:
			$TileMap_zanjas/TileMapZL.set_cell(pos_x_lava, i, 1, false, false, false, Vector2(0,0))
		elif pos_x_lava > 6:
			$TileMap_zanjas/TileMapZL.set_cell(pos_x_lava, i, 2, false, false, false, Vector2(0,0))
			
	#colocando las rocas laterales
	for i in range (num_cuadros, num_cuadros + 1500, 18):
		$TileMap_rocas/TileMap.set_cell(10, i, 6, true, false, false, Vector2(0,0))
		$TileMap_rocas/TileMap.set_cell(-17, i, 6, false, false, false, Vector2(0,0))
	
	#colocando las rocas del medio
	for i in range (num_cuadros, num_cuadros + 1500, 15):
		var pos_x_roca = (randi() % 8) 
		$TileMap_rocas/TileMap.set_cell(pos_x_roca, i, 7, false, false, false, Vector2(0,0))

func _on_lava_timer_timeout():
	
	if num_cuadro == 1:
		
		var mult = posx / (posy + 0.2349)
		ocupadas.append(mult)
				
		posx = randi() % 20
		posy = int($carro.position.y / 64) - (randi() % 10) - 4
		
	if num_cuadro <= 6:
		
		num_celda = 7 + 8 * (-posy % 8) - (8 - (posx % 8)) + 64 * num_cuadro 
		for i in ocupadas.size():
			if posx / (posy + 0.2349) == ocupadas[i]: no_dibujar = true
		if no_dibujar == false:	
			$TileMap_lava/TileMap.set_cell(posx, posy, num_celda, false, false, false, Vector2(0,0))
		no_dibujar = false
		
		num_cuadro += 1
		
	else: num_cuadro = 0

func _on_carro_lava_escudo():
	$TileMap_zanjas.set_collision_layer_bit(0, false)
	$TileMap_zanjas.set_collision_mask_bit(0, false)
	$carro/escudo.visible = false
	$carro.protection = false
	$lava_escudo_timer.start()

func _on_lava_escudo_timer_timeout():
	$TileMap_zanjas.set_collision_layer_bit(0, true)
	$TileMap_zanjas.set_collision_mask_bit(0, true)

func _on_ambiente_timer_timeout():
	var sound = randi() % 4
	if sound == 0: $cueva1.play()
	if sound == 1: $cueva2.play()
	if sound == 2: $cueva3.play()
	if sound == 3: $cueva4.play()
	var tiempo_espera = randi() % 30 + 5
	$ambiente_timer.wait_time = tiempo_espera
	$ambiente_timer.start()
