extends Node2D

# Posiciones fuera de batalla
var red_dead_pos = [Vector2(-100,0), Vector2(-100,50), Vector2(-100,100), Vector2(-100,150)]
var blue_dead_pos = [Vector2(-200,0), Vector2(-200,50), Vector2(-200,100), Vector2(-200,150)]
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
onready var hudSimple = $HUD/HUDSimple
onready var items = [preload("res://scenes/items/minusCrystal.tscn"), preload("res://scenes/items/plusCrystal.tscn")]

# Variables para saber el siguiente soldado del equipo
var indexBlue = 0
var indexRed = 0
var activeTeam # 0 - Blue / 1 - Red
var stateGame  # tendra un string del siguiente array: ["red", "blue", "standby"]
var actual_item = 0

func _ready():
	# Inicia lo necesario para comenzar el juego
	timerTurn.initTimer("standby")
	stateGame = "standby"
	
	# variable para randomizar el numero que se ocupara para determinar quien empieza el juego
	randomize()
	
	# Se llama la funcion para que realice lo necesario para iniciar el juego
	startGame()

# Determina que equipo empezara el juego
func startGame():
	
	# Se escoge quien va a empezar para el equipo azul
	randomize()
	var who_start_red = randi() % queueRed.get_child_count()
	
	# Se escoge quien va a empezar para el equipo rojo
	randomize()
	var who_start_blue = randi() % queueBlue.get_child_count()

	# Se elige quien va a partir en el juego
	if randi() % 2 == 0:
		actualPlayer = queueBlue.get_child(who_start_blue)
		activeTeam = 0
		indexRed = who_start_red
		
	else:
		actualPlayer = queueRed.get_child(who_start_red)
		activeTeam = 1
		indexBlue = who_start_blue
	
	# Cambiamos las variables para el flujo de juego
	red_soldiers_death = 0
	blue_soldiers_death = 0
		
	# Se asocia la informacion para el HUD avanzado
	# Se asocia el hud del equipo azul
	for i in range(queueBlue.get_child_count()):
		print(i)
		queueBlue.get_child(i).id = i
		queueBlue.get_child(i).team = 0
		queueBlue.get_child(i).death_pos = blue_dead_pos[i]
		hudBlue.get_child(i).value = queueBlue.get_child(i).HP
		queueBlue.get_child(i).connect("damage_to_soldier", self, "signal_damage_to_soldier")
		queueBlue.get_child(i).connect("delete_soldier", self, "signal_delete_soldier")
		
	# Se asocia el hud del equipo rojo
	for i in range(queueRed.get_child_count()):
		queueRed.get_child(i).id = i
		queueRed.get_child(i).team = 1
		queueRed.get_child(i).death_pos = red_dead_pos[i]
		hudRed.get_child(i).value = queueRed.get_child(i).HP
		queueRed.get_child(i).connect("damage_to_soldier", self, "signal_damage_to_soldier")
		queueRed.get_child(i).connect("delete_soldier", self, "signal_delete_soldier")
		
	# Se hacen unicos los algunas variables de los planetas para que no cambien 
	# con respecto a la gravedad de otro planeta
	for i in range(planets.get_child_count()):
		planets.get_child(i).get_node("ParticlesGravityNeg").process_material = \
			planets.get_child(i).get_node("ParticlesGravityNeg").process_material.duplicate()
		planets.get_child(i).get_node("ParticlesGravityPos").process_material = \
			planets.get_child(i).get_node("ParticlesGravityPos").process_material.duplicate()

# Cambia el turno cambian el equipo
func changeTurn():
	# En los dos bloques de codigo de las condiciones se elige al proximo soldado del 
	# equipo que manejara, iniciando el timer correspondiente
	
	if activeTeam == 1: # pasar turno a azul
		indexBlue = (indexBlue + 1) % queueBlue.get_child_count()
		actualPlayer = queueBlue.get_child(indexBlue)
		while actualPlayer.isDeath:
			indexBlue = (indexBlue + 1) % queueBlue.get_child_count()
			actualPlayer = queueBlue.get_child(indexBlue)
		activeTeam = 0
		timerTurn.initTimer("blue")
		stateGame = "blue"
		hudSimple.color = Color(0,0,1.0,0.2)

	else: # pasar turno a rojo
		indexRed = (indexRed + 1) % queueRed.get_child_count()
		actualPlayer = queueRed.get_child(indexRed)
		while actualPlayer.isDeath:
			indexRed = (indexRed + 1) % queueRed.get_child_count()
			actualPlayer = queueRed.get_child(indexRed)
		activeTeam = 1
		timerTurn.initTimer("red")
		stateGame = "red"
		hudSimple.color = Color(1.0,0,0,0.2)
	
	# Se cambia la variable para poder mover al soldado
	actualPlayer.active = true
	
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

# Funcion con el codigo necesario para verificar las condiciones de victoria
func check_win_condition():
	# Se comprueba si algun jugador no le quedan soldados disponibles
	if red_soldiers_death == 4:
		get_tree().change_scene("res://scenes/UI/blueWins.tscn")
	
	elif blue_soldiers_death == 4:
		get_tree().change_scene("res://scenes/UI/redWins.tscn")
		
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
			actualPlayer.speed = Vector2(0,0)
			actualPlayer.emit_signal("delete_soldier",actualPlayer.team, actualPlayer.id)
			
			# Pasamos al estado de Standby
			timerTurn.initTimer("standby")
			stateGame = "standby"
			hudSimple.color = Color(1,1,1,0.40)
			
		# Se revisa si se termino el turno del jugador con varias condiciones
		elif actualPlayer.getChangeControl() or (timerTurn.is_stopped() and stateGame != "standby"):
			
			# Cambiamos las variables para poder pasar el turno al siguiente soldado
			actualPlayer.changeControl = false # se debe cambiar al entrar si no queda en un loop
			actualPlayer.active = false # solo sera necesario cuando acaba el timer, se hizo asi para no repetir codigo
			
			# Pasamos el estado de Standby
			timerTurn.initTimer("standby")
			stateGame = "standby"
			hudSimple.color = Color(1,1,1,0.40)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Se comprueban las condiciones de victoria
	check_win_condition()
	
	# Input para cambiar entre gemas y colocar gemas de gravedad
	if Input.is_action_just_pressed("change_item"):
		actual_item = (actual_item + 1) % items.size()
		
	if Input.is_action_just_pressed("add_item"):
		var mouse_position = get_global_mouse_position()
		var item = items[actual_item].instance()
		item.init(planets.get_child(randi() % planets.get_child_count()))
		item.global_position = mouse_position
		item.get_node("Particles2D").process_material = item.get_node("Particles2D").process_material.duplicate()
		add_child(item)
		
	# Se comprueba el estado del flujo del jugego
	check_game_flow()
