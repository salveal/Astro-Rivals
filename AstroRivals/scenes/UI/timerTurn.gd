extends Timer

# Variables
var secondsTurn = 15
var secondsStandby = 5
var split_timer
var output_timer
onready var label = $Label
onready var blueUI = $blueTurn 
onready var redUI = $redTurn
onready var standby = $standBy

# Called when the node enters the scene tree for the first time.
func _ready():
	# Se crea el timer y se inicializan las variables para indicar que color tiene que poseer
	var output_print = "Timer Creado con: " + str(secondsTurn)
	print(output_print)
	blueUI.visible = false
	redUI.visible = false
	standby.visible = false
	
func initTimer(team: String):
	# Inicia el timer dependiendo del estado del timer
	# esto es si es el timer del turno de un equipo o el standby
	
	# Se setean las variable de la clase con los valores defautls
	redUI.visible = false
	blueUI.visible = false
	standby.visible = false

	# Se cambia las variables que necesitamos dependiendo del estado de la variable team
	if team == "red":
		redUI.visible = true
		wait_time = secondsTurn
	elif team == "blue":
		blueUI.visible = true
		wait_time = secondsTurn
	else:
		standby.visible = true
		wait_time = secondsStandby

	# reseteamos el timer
	resetTimer()
	
func resetTimer():
	# resetea el timer cambiando el color del font e iniciandolo
	# además de iniciar de nuevo el contador
	label.add_color_override("font_color", Color(1,1,1,1))
	start()
	print("start timer")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Se cambia la variable label dependiendo si termino el timer o no
	if is_stopped():
		stop()
		label.add_color_override("font_color", Color(0,0,0,1))
	
	else:
		split_timer = str(time_left).split(".")
		output_timer = split_timer[0]
		label.set_text(output_timer)
