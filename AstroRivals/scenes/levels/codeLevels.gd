extends Node2D

# Variables para manejar el hud
var index_display
var string_scene
var is_pause_menu_active
var left_time

# Posiciones fuera de batalla
var red_dead_pos = [Vector2(-100,0), Vector2(-100,50), Vector2(-100,100), Vector2(-100,150)]
var blue_dead_pos = [Vector2(-200,0), Vector2(-200,50), Vector2(-200,100), Vector2(-200,150)]
# index_red_soldiers_alive = [0,1,2,3]
# var index_blue_soldiers_alive = [0,1,2,3]
var red_soldiers_death
var blue_soldiers_death 

# Objetos y estructuras para el flujo de juego
onready var actualPlayer
onready var queueBlue = $queueBlue 
onready var queueRed = $queueRed
onready var planets = $listPlanets
onready var timerTurn = $HUD/HUDSimple/TimerTurn
onready var hudBlue = $HUD/HUDBlueTeam
onready var hudRed = $HUD/HUDRedTeam
onready var hudSimple = $HUD
onready var menuPause = $HUD/menu_pause

# Variables para los items
onready var items = [preload("res://scenes/items/minusCrystal.tscn"), preload("res://scenes/items/plusCrystal.tscn")]
onready var queuePlusCrystal = $queuePlusCrystal
onready var queueMinusCrystal = $queueMinusCrystal
var max_cant_per_item = 3
var areas_spawn_items 

# Variables para saber el siguiente soldado del equipo
var indexBlue = 0
var indexRed = 0
var activeTeam # 0 - Blue / 1 - Red
var stateGame  # tendra un string del siguiente array: ["red", "blue", "standby"]
var actual_item = 0
var soldiers_per_team
var damage_value = 100

# Funcion que se ejecutara cuando se cargue por primera vez el nivel
func _ready():
	# Asocia la escena y sus variables importantes al menu de pausa
	is_pause_menu_active = false
	menuPause.set_variables(areas_spawn_items, string_scene, self)
	
	# Determina la cantidad de soldados por equipo / Deben ser iguales
	if queueBlue.get_child_count() == queueRed.get_child_count():
		soldiers_per_team = queueBlue.get_child_count()
		
	else:
		push_error("ERROR: En el nivel ocurrio un error con los numeros de soldados por equipo")
	
	# Inicia lo necesario para comenzar el juego
	stateGame = "standby"
	timerTurn.initTimer(stateGame)
	index_display = 0
	
	# variable para randomizar el numero que se ocupara para determinar quien empieza el juego
	randomize()
	
	# Se llama la funcion para que realice lo necesario para iniciar el juego
	startGame()

# Setea el listado de diccionario con el spawneo de items
func set_spawn_areas(areas: Array):
	areas_spawn_items = areas

# Setea el string con el path para la escena
func set_scene_string(new_scene):
	string_scene = new_scene

# Funcion para spawnear items
func spawn_items():
	
	randomize()
	# Se ve si se spawnea un item
	if randi() % 10 > 0:
		randomize()
		var actual_area = areas_spawn_items[randi() % len(areas_spawn_items)]
		var x = actual_area["top_left"].x + randi() % actual_area["x_len"]
		var y = actual_area["top_left"].y + randi() % actual_area["y_len"]
		
		randomize()
		var index_item = randi() % len(items)
		var actual_item = items[index_item].instance()
		actual_item.init(planets.get_child(randi() % planets.get_child_count()))
		actual_item.global_position = Vector2(x,y)
		actual_item.get_node("Particles2D").process_material = actual_item.get_node("Particles2D").process_material.duplicate()

		if index_item == 0:
			if queueMinusCrystal.get_child_count() == max_cant_per_item:
				queueMinusCrystal.get_child(randi() % max_cant_per_item).break_gem()
			queueMinusCrystal.add_child(actual_item)
			
		else:
			if queuePlusCrystal.get_child_count() == max_cant_per_item:
				queuePlusCrystal.get_child(randi() % max_cant_per_item).break_gem()
			queuePlusCrystal.add_child(actual_item)

# Determina que equipo empezara el juego y asocia las señales necesarias a los soldados
func startGame():
	
	# Se escoge quien va a empezar para el equipo azul
	randomize()
	var who_start_red = randi() % queueRed.get_child_count()
	indexRed = who_start_red
	
	# Se escoge quien va a empezar para el equipo rojo
	randomize()
	var who_start_blue = randi() % queueBlue.get_child_count()
	indexBlue = who_start_blue

	# Se elige quien va a partir en el juego
	randomize()
	if randi() % 2 == 0:
		actualPlayer = queueBlue.get_child(indexRed)
		activeTeam = 0
		
	else:
		actualPlayer = queueRed.get_child(indexBlue)
		activeTeam = 1

	# Cambiamos las variables para el flujo de juego
	red_soldiers_death = 0
	blue_soldiers_death = 0
		
	# Se asocia la informacion para el HUD avanzado
	for i in range(soldiers_per_team):

		# Se le asocia los datos del equipo azul al hud azul
		# Se le otorga una id unica al soldado por equipo y se identifica su equipo
		queueBlue.get_child(i).id = i
		queueBlue.get_child(i).team = 0

		# Se entrega la posicion donde se ubicara luego de morir
		queueBlue.get_child(i).death_pos = blue_dead_pos[i]

		# Se asocia la barra de vida
		hudBlue.get_child(i).value = queueBlue.get_child(i).HP

		# Se conectan las señales a los soldados
		queueBlue.get_child(i).connect("damage_to_soldier", self, "signal_damage_to_soldier")
		queueBlue.get_child(i).connect("delete_soldier", self, "signal_delete_soldier")
		queueBlue.get_child(i).connect("edit_hud_ammo", self, "signal_edit_hud_ammo")
		
	
		queueBlue.get_child(i).sprite_symbol_weapons[3] = "res://assets/weapons/blue_lightBlade.png"
		queueBlue.get_child(i).list_weapons[3] = load("res://scenes/soldiers/weapons/ligthsable/blue_ligthsable.tscn")
		
		# Se le asocia los datos del equipo azul al hud azul
		# Se le otorga una id unica al soldado por equipo y se identifica su equipo
		queueRed.get_child(i).id = i
		queueRed.get_child(i).team = 1

		# Se entrega la posicion donde se ubicara luego de morir
		queueRed.get_child(i).death_pos = red_dead_pos[i]

		# Se asocia la barra de vida
		hudRed.get_child(i).value = queueRed.get_child(i).HP

		# Se conectan las señales a los soldados
		queueRed.get_child(i).connect("damage_to_soldier", self, "signal_damage_to_soldier")
		queueRed.get_child(i).connect("delete_soldier", self, "signal_delete_soldier")
		queueRed.get_child(i).connect("edit_hud_ammo", self, "signal_edit_hud_ammo")
		
	# Se hacen unicos los algunas variables de los planetas para que no cambien 
	# con respecto a la gravedad de otro planeta
	for i in range(planets.get_child_count()):
		planets.get_child(i).get_node("ParticlesGravityNeg").process_material = \
			planets.get_child(i).get_node("ParticlesGravityNeg").process_material.duplicate()
		planets.get_child(i).get_node("ParticlesGravityPos").process_material = \
			planets.get_child(i).get_node("ParticlesGravityPos").process_material.duplicate()

# Cambia de turno al siguiente soldado del equipo contrario
func changeTurn():
	# En los dos bloques de codigo de las condiciones se elige al proximo soldado del 
	# equipo que manejara, iniciando el timer correspondiente
	
	if activeTeam == 1:
		print("pasa al equipo azul")
		
		# Se debe pasar el turno al equipo azul
		indexBlue = (indexBlue + 1) % queueBlue.get_child_count()
		actualPlayer = queueBlue.get_child(indexBlue)

		# Se revisa que el jugador actual no este muerto
		while actualPlayer.isDeath:

			# Se busca al siguiente soldado del equipo
			indexBlue = (indexBlue + 1) % queueBlue.get_child_count()
			actualPlayer = queueBlue.get_child(indexBlue)

		# Inicia el turno del equipo rojo
		activeTeam = 0
		timerTurn.initTimer("blue")
		stateGame = "blue"
		hudSimple.change_color_hud(Color(0,0,1.0,0.58))
		hudSimple.show_gui_ammo()

	else:
		print("pasa al equipo rojo")
		# Se debe pasar el tunro al equipo rojo
		indexRed = (indexRed + 1) % queueRed.get_child_count()
		actualPlayer = queueRed.get_child(indexRed)

		# Se revisa que el jugador actual no este muerto
		while actualPlayer.isDeath:

			# Se busca al siguiente soldado del equipo
			indexRed = (indexRed + 1) % queueRed.get_child_count()
			actualPlayer = queueRed.get_child(indexRed)
		
		# Inicia el turno del equipo rojo
		activeTeam = 1
		timerTurn.initTimer("red")
		stateGame = "red"
		hudSimple.change_color_hud(Color(1.0,0,0,0.58))
		hudSimple.show_gui_ammo()
	
	# Se cambia la variable para poder mover al soldado
	actualPlayer.active = true
	actualPlayer.camera.reset_camera()
	actualPlayer.camera.current = true
	actualPlayer.emit_signal("edit_hud_ammo", actualPlayer.actual_weapon_symbol, str(actualPlayer.ammo_weapons[actualPlayer.actual_weapon]))
	
	# Se corre el codigo de spawnear items
	spawn_items()
	
# Esta funcion se encargara de editar el valor de la bara de vida
# del soldado asociado cuando este reciba daño
func signal_damage_to_soldier(team: int, index:int, new_health):
	if team == 0: 
		# Equipo azul
		hudBlue.get_child(index).value = new_health
	else:
		# Equipo rojo
		hudRed.get_child(index).value = new_health

# Señal para indicar que se debe eliminar del campo de juego a dicho solado
func signal_delete_soldier(team: int, index: int):
	if team == 0 and not queueBlue.get_child(index).alredyDeath:
		queueBlue.get_child(index).position = queueBlue.get_child(index).death_pos
		queueBlue.get_child(index).alredyDeath = true
		blue_soldiers_death += 1

	elif team == 1 and not queueRed.get_child(index).alredyDeath:
		queueRed.get_child(index).position = queueRed.get_child(index).death_pos
		queueRed.get_child(index).alredyDeath = true
		red_soldiers_death += 1

# Señal para editar el hud del arma y la municion del soldado activo 
func signal_edit_hud_ammo(sprite, ammo):
	hudSimple.get_node("HUDSimple/HUDSimple_left/symbol_weapon").texture = load(sprite)
	if ammo == "-1":
		ammo = "99"
	hudSimple.get_node("HUDSimple/HUDSimple_left/ammo_weapon").set_text("x" + ammo)

# Funcion con el codigo necesario para verificar las condiciones de victoria
func check_win_condition():
	
	# Se comprueba si algun jugador no le quedan soldados disponibles
	if red_soldiers_death == 4:
		var scene = load("res://scenes/UI/blueWins.tscn").instance()
		get_tree().get_root().add_child(scene)
		get_tree().get_root().remove_child(self)
	
	elif blue_soldiers_death == 4:
		var scene = load("res://scenes/UI/redWins.tscn").instance()
		get_tree().get_root().add_child(scene)
		get_tree().get_root().remove_child(self)
		
# Funcion con el codigo necesario para verificar el flujo del juego
func check_game_flow():
	# Se revisa el estado del flujo del juego
	if stateGame == "standby":
		if timerTurn.is_stopped():
			changeTurn()
	
	# Se entra en este bloque de codigo si el es el turno de un jugador y se evalua si termino o no su turno
	else:
		# Se evalua si se debe eliminar el soldado que esta siendo controlado
		if actualPlayer.isDeath:
			
			# cambiamos las variables del actualPlayer para poder pasar el turno al siguiente
			# soldado y quitarlo del juego sin que se rompa el flujo del juego
			actualPlayer.active = false
			#actualPlayer.changeControl = false
			actualPlayer.speed = Vector2(0,0)
			actualPlayer.emit_signal("delete_soldier",actualPlayer.team, actualPlayer.id)
			
			# Pasamos al estado de Standby
			stateGame = "standby"
			timerTurn.initTimer(stateGame)
			hudSimple.change_color_hud(Color(1,1,1,0.58))
			hudSimple.hidden_gui_ammo()
			
		# Se revisa si se termino el turno del jugador con varias condiciones
		elif actualPlayer.getChangeControl() or (timerTurn.is_stopped() and stateGame != "standby"):
			
			# Cambiamos las variables para poder pasar el turno al siguiente soldado
			actualPlayer.changeControl = false # se debe cambiar al entrar si no queda en un loop
			actualPlayer.active = false # solo sera necesario cuando acaba el timer, se hizo asi para no repetir codigo
			
			# Pasamos el estado de Standby
			stateGame = "standby"
			timerTurn.initTimer(stateGame)
			hudSimple.change_color_hud(Color(1,1,1,0.58))
			hudSimple.hidden_gui_ammo()

# Funcion para cambiar el hud del juego
func change_display_hud():
	index_display = (index_display + 1) % 3
	
	# Poner vida sobre los personajes
	for i in range(queueBlue.get_child_count()):
		queueBlue.get_child(i).index_display = index_display
		queueBlue.get_child(i).change_label()
		queueRed.get_child(i).index_display = index_display
		queueRed.get_child(i).change_label()
	
	# HUD Simple
	if index_display == 0:
		hudBlue.visible = false
		hudRed.visible = false
		
	# HUD Medio
	elif index_display == 1:
		hudBlue.visible = true
		hudRed.visible = true
		
	# HUD Complejo
	else:
		pass
	
# Funcion que checkea los inputs de debbug y menu de pausa
func check_inputs():
		
	if Input.is_action_just_pressed("pause_menu") and not actualPlayer.generate_shoot:
		if is_pause_menu_active:
			timerTurn.set_paused(false)
			if stateGame != "standby":
				actualPlayer.active = true
			is_pause_menu_active = false
			hudSimple.get_node("menu_pause").visible = false
			
		else:
			timerTurn.set_paused(true)
			actualPlayer.active = false
			is_pause_menu_active = true
			hudSimple.get_node("menu_pause").visible = true
		
	if not is_pause_menu_active:
		
		# Input para cambiar entre gemas y colocar gemas de gravedad
		if Input.is_action_just_pressed("change_item"):
			actual_item = (actual_item + 1) % items.size()
		
		# Input para agregar los itemes de gravedad
		if Input.is_action_just_pressed("add_item"):
			var mouse_position = get_global_mouse_position()
			var item = items[actual_item].instance()
			item.init(planets.get_child(randi() % planets.get_child_count()))
			item.global_position = mouse_position
			item.get_node("Particles2D").process_material = item.get_node("Particles2D").process_material.duplicate()
			add_child(item)
			
		if Input.is_action_just_pressed("change_hud"):
			change_display_hud()
			
		if Input.is_action_just_pressed("delete_soldier"):
			actualPlayer.take_damage(self)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Se comprueba los inputs asociados al menu de pausa de juego y debbug
	check_inputs()
		
	# Se comprueba el estado del flujo del jugego
	if not is_pause_menu_active:
		# Se comprueban las condiciones de victoria
		check_win_condition()
		
		# Se comprueba el estado del flujo del jugego
		check_game_flow()
