extends KinematicBody2D

# Variables personajes
var HP = 100

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

# Variables armas
var bullet
var generate_shoot = false
var rate = 2
var power = 0

# Variables Turnos
var active = false
var changeControl = false

# Imports
onready var Planet = get_parent().get_parent().get_node("Planet")
onready var power_bar = $PowerBar
onready var sprite = $Sprite
onready var hp_label = $Label
onready var animTree = $AnimationTree
onready var playback = animTree.get("parameters/playback")
var BULLET = preload("res://scenes/soldiers/weapons/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	animTree.active = true
	grav_point = Planet.global_position
	power = 0
	hp_label.set_text(str(HP))
	print(grav_point)
	
func get_rotation_player(grav_vector):
	var rotation = Vector2(0,1)
	return rotation.angle_to(grav_vector)
	
func apply_movement(sp, delta):
	# Movement
	if Input.is_action_pressed("move_left") and active:
		direction = -1
	elif Input.is_action_pressed("move_right") and active:
		direction = 1
	else:
		direction = 0
			
	sp.x = MAX_SPEED * direction
	if sp.y < GRAVITY:
		sp.y += GRAVITY * delta
		
	if is_on_floor() and Input.is_action_just_pressed("jump") and active:
		sp.y = -2 * JUMP
			
	return sp
	

func apply_animations():
	# Animation
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
	if active:
		if Input.is_action_pressed("add_grav"):
			GRAVITY += 1000
		elif Input.is_action_pressed("low_grav"):
			GRAVITY -= 1000
		
		if generate_shoot == true and is_on_floor():
			if generate_shoot and (power > MAX_POWER or power < MIN_POWER):
				rate = -rate
				
			power += rate
			power_bar.value = power
			if Input.is_action_just_released("shoot"):
				bullet = BULLET.instance()
				var mouse_position = get_global_mouse_position()
				bullet.global_position = global_position - (global_position - mouse_position).normalized() * 50
				bullet.linear_velocity = (mouse_position - global_position).normalized() * power * 2
				get_parent().get_parent().add_child(bullet)
				generate_shoot = false
				power = 0
				power_bar.value = power
				changeControl = true
		
		# Generar disparo
		if Input.is_action_just_pressed("shoot") and is_on_floor():
			generate_shoot = true

func getChangeControl():
	return changeControl
	
func take_damage(damage_origin: Node):
	HP -= damage_origin.damage_value
	hp_label.set_text(str(HP))
