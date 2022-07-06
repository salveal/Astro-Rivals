extends Timer

# Variables
var secondsTurn = 25
var secondsStandby = 4
var time_lapse
var last_time
var split_timer
var output_timer
onready var label = $Label
onready var standby = $standBy

# Called when the node enters the scene tree for the first time.
func _ready():
	# Se crea el timer y se inicializan las variables para indicar que color tiene que poseer
	var output_print = "Timer Creado con: " + str(secondsTurn)
	print(output_print)
	
func initTimer(team: String):
	# Inicia el timer dependiendo del estado del timer
	# esto es si es el timer del turno de un equipo o el standby
	

	# Se cambia las variables que necesitamos dependiendo del estado de la variable team
	if team == "red" or team == "blue":
		wait_time = secondsTurn

	else:
		wait_time = secondsStandby

	# reseteamos el timer
	resetTimer()
	
func resetTimer():
	# resetea el timer cambiando el color del font e iniciandolo
	# además de iniciar de nuevo el contador|
	start()
	time_lapse = 0
	print("start timer")
	
func change_color():
	# Codigo para parpadear el contador
	if time_left < 5.0:
		label.add_color_override("font_color", Color(1,0.5,0,1))
		
	elif time_left < 10.0:
		label.add_color_override("font_color", Color(1,1,0,1))
	
	else:
		label.add_color_override("font_color", Color(1,1,1,1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Se cambia la variable label dependiendo si termino el timer o no
	if is_stopped():
		stop()
		label.add_color_override("font_color", Color(0,0,0,1))
	
	else:
		change_color()
		
		split_timer = str(time_left).split(".")
		output_timer = split_timer[0]
		label.set_text(output_timer)
		
