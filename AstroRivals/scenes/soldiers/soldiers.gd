extends KinematicBody2D

# Variables personajes
var HP = 100
var isDeath = false
var alredyDeath = false
var id
var team # 0 - blue, 1 - red

# Variables Moviminetos
var GRAVITY = 5000
var MAX_SPEED = 4000
var JUMP = 3000
var MAX_POWER = 200
var MIN_POWER = 0
var direction = 0
var speed = Vector2()
var velocity = Vector2()
var grav_point = Vector2()
var death_pos = Vector2()

# Variables armas
var bullet
var generate_shoot = false
var rate = 2
var power = 0

# Variables Turnos
var active = false
var changeControl = false

# Señales para el hud
signal damage_to_soldier(team, index, new_healt)
signal delete_soldier(team, index)

# Imports
onready var Planet
onready var power_bar = $PowerBar
onready var sprite = $Sprite
onready var hp_label = $Label
onready var animTree = $AnimationTree
onready var playback = animTree.get("parameters/playback")
var BULLET = preload("res://scenes/soldiers/weapons/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	animTree.active = true
	hp_label.set_text(str(HP))
	
func get_rotation_player(grav_vector):
	# Funcion que obtienen la rotacion del jugador con respecto al planeta que se encuentra
	var rotation = Vector2(0,1)
	return rotation.angle_to(grav_vector)
	
func apply_movement(sp, delta):
	# Movimiento
	
	# se revisa si se mueve el jugador
	if Input.is_action_pressed("move_left") and active:
		direction = -1
	elif Input.is_action_pressed("move_right") and active:
		direction = 1
	else:
		direction = 0
		
	# Se realizan los calculos de los vectores de posicion para los dos ejes
	sp.x = MAX_SPEED * direction
	GRAVITY = Planet.get_child(2).gravity * 40
	if sp.y < GRAVITY:
		sp.y += GRAVITY * delta
	
	# Se revisa si se quiere saltar
	if is_on_floor() and Input.is_action_just_pressed("jump") and active:
		sp.y = -2 * JUMP
	
	return sp
	

func apply_animations():
	# Animacion
	if is_on_floor():
		if direction != 0:
			playback.travel("walk")
		else:
			playback.travel("idle")
	else:
		playback.travel("jump")

	if active:
		if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
			sprite.flip_h = false

		if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
			sprite.flip_h = true

# Function called to move the player around the scene
func _physics_process(delta):
	# obtiene los valores importantes para el calculo
	var gravity_vector = (grav_point - position).normalized()
	var rotation = get_rotation_player(gravity_vector)
	move_and_slide(velocity, -gravity_vector)
	
	# Comprueba si el jugador esta en el area de la gravedad
	# para poder aplicarla o no
	if not generate_shoot:
		if is_in_area_gravity():
			speed = apply_movement(speed, delta)
			
		apply_animations()
		
	# Se generan las rotaciones de las velocidades y del personaje
	velocity = Vector2(speed.x * delta, speed.y * delta)
	velocity = velocity.rotated(rotation)
	set_rotation(rotation)
	
	
func is_in_area_gravity():
	# Funcion que retornara un booleano dependiendo si el 
	# player se encuentra en el area de la gravedad del planeta
	var radio = Planet.get_node("Gravity/CollisionShape2D").shape.radius
	var distancia = position.distance_to(Planet.position)
	return distancia < radio
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# se revisa si es turno del jugador
	if active:
		# Entra si el jugador va a disparar revisando si se cumple las condiciones necesarias
		if generate_shoot == true and is_on_floor():
			
			# condicion para cambiar el valor de rate para que no salga de los rangos establecidos
			if generate_shoot and (power > MAX_POWER or power < MIN_POWER):
				rate = -rate
			
			# Se suma el rate
			power += rate
			power_bar.value = power
			
			# Se revisa si se debe disparar
			if Input.is_action_just_released("shoot"):
				# Dejamos de mover al soldado
				active = false
				
				# Creamos la instancia de la bala seleccionada, seteamos su posicion y velocidades
				# y la agregamos al arbol del nivel
				bullet = BULLET.instance()
				bullet.initMisil(self)
				var mouse_position = get_global_mouse_position()
				bullet.global_position = global_position - (global_position - mouse_position).normalized() * 50
				bullet.linear_velocity = (mouse_position - global_position).normalized() * power * 2
				get_parent().get_parent().add_child(bullet)
				
				# Se cambian las variables del soldado para poder pasar el turno al siguiente soldado
				generate_shoot = false
				power = 0
				power_bar.value = power
		
		# cambia la variable si el jugador quiere generar un disparo
		if Input.is_action_just_pressed("shoot") and is_on_floor():
			generate_shoot = true

#Retorna la variable si debe termino el turno
func getChangeControl():
	return changeControl

#Funcion que setea a la gravedad a la cual estara sometido el soldado
func change_gravity_point(new_planet: Node2D):
	print("change")
	Planet = new_planet
	grav_point = Planet.global_position

# Funcion para aplicarle daño al soldado entregandole el daño de origen que recibe
func take_damage(damage_origin: Node):
	HP -= damage_origin.damage_value
	hp_label.set_text(str(HP))
	emit_signal("damage_to_soldier", team, id, HP)
	if HP <= 0:
		deleteNode()

# Funcion que sera llamada para indicar que choco el proyectil enviado por el mismo soldado
# Esta funcion cambiara la variable de changeControl para pasar el tunro
func colisionShot():
	changeControl = true
	
func deleteNode():
	# Si es del jugador activo, dejamos que el script del nivel se encargen de eliminar
	# el personaje
	isDeath = true
	if !active:
		# Aqui deberia haber una animacion de muerte con un timer
		speed = Vector2(0,0)
		emit_signal("delete_soldier", team, id)
