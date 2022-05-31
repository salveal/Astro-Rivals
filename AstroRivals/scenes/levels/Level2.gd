extends Node2D

# Objetos y estructuras para el flujo de juego
onready var queueBlue = $queueBlue
onready var queueRed = $queueRed
onready var timerTurn = $TimerTurn
onready var actualPlayer
onready var items = [preload("res://scenes/items/minusCrystal.tscn"), preload("res://scenes/items/plusCrystal.tscn")]
onready var planets = [$Planet1]

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
	startGame()

# Determina que equipo empezara el juego
func startGame():
	if randi() % 2 == 0:
		actualPlayer = queueBlue.get_child(0)
		activeTeam = 0
		indexRed = -1
	else:
		actualPlayer = queueRed.get_child(0)
		activeTeam = 1
		indexBlue = -1

# Cambia el turno cambian el equipo
func changeTurn():
	# En los dos bloques de codigo de las condiciones se elige al proximo soldado del 
	# equipo que manejara, iniciando el timer correspondiente
	if activeTeam == 1: # pasar turno a azul
		indexBlue = (indexBlue + 1) % queueBlue.get_child_count()
		actualPlayer = queueBlue.get_child(indexBlue)
		activeTeam = 0
		timerTurn.initTimer("blue")
		stateGame = "blue"

	else: # pasar turno a rojo
		indexRed = (indexRed + 1) % queueRed.get_child_count()
		actualPlayer = queueRed.get_child(indexRed)
		activeTeam = 1
		timerTurn.initTimer("red")
		stateGame = "red"
	
	# Se cambia la variable para poder mover al soldado
	actualPlayer.active = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if queueRed.get_child_count() == 0:
		get_tree().change_scene("res://scenes/UI/blueWins.tscn")
	
	if queueBlue.get_child_count() == 0:
		get_tree().change_scene("res://scenes/UI/redWins.tscn")
	
	if Input.is_action_just_pressed("change_item"):
		actual_item = (actual_item + 1) % items.size()
		
	if Input.is_action_just_pressed("add_item"):
		var mouse_position = get_global_mouse_position()
		var item = items[actual_item].instance()
		item.init(planets[randi() % planets.size()])
		item.global_position = mouse_position
		add_child(item)
	
	if stateGame == "standby":
		if timerTurn.is_stopped():
			changeTurn()
	
	else:
		# Se evalua si se debe eliminar el soldado que esta siendo controlado
		if actualPlayer.needToBeDelete:
			actualPlayer.active = false
			actualPlayer.queue_free()
			timerTurn.initTimer("standby")
			stateGame = "standby"
			
		# Se revisa si se termino el turno del jugador con varias condiciones
		elif actualPlayer.getChangeControl() or (timerTurn.is_stopped() and stateGame != "standby"):
			actualPlayer.changeControl = false # se debe cambiar al entrar si no queda en un loop
			actualPlayer.active = false # solo sera necesario cuando acaba el timer, se hizo asi para no repetir codigo
			timerTurn.initTimer("standby")
			stateGame = "standby"
