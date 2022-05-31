extends RigidBody2D

# Variables
var grav_point = Vector2()
var b_rotation = 0
onready var Planet = get_parent().get_node("Planet1")
onready var sprite = $Sprite
onready var animTree = $AnimationTree
onready var timer_damage = $Timer_damage
onready var playback = animTree.get("parameters/playback")
onready var soldierShot
var EXPLOSION = preload("res://scenes/soldiers/weapons/explosion.tscn")
var tick = 0
var explosion

# Called when the node enters the scene tree for the first time.
func _ready():
	grav_point = Planet.global_position
	playback.travel("init")
	contact_monitor = true

# Funcion para asociar el proyectil con el soldado que ejecuto el disparo
# Aqui se cambian las variables que no se pueden inicializar en _ready()
func initMisil(soldier: Node):
	soldierShot = soldier

# Funcion para calcular la rotacion del misil con respecto al planeta asociado
func get_rotation_player(vel_vector):
	var rotation = Vector2(1,0)
	return rotation.angle_to(vel_vector)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var gravity_vector = (grav_point - position).normalized()
	var linear_vel = get_linear_velocity()
	if linear_vel.length() > 20:
		b_rotation = get_rotation_player(linear_vel.normalized())
		set_rotation(b_rotation)
		
	check_colision()

# Cheque si existe colision del misil para ejecutar su explosion/daño o no
func check_colision():
	var bodies = get_colliding_bodies()
	if len(bodies) > 0 and tick == 0:
		explosion = EXPLOSION.instance()
		explosion.init(global_position, grav_point)
		get_parent().add_child(explosion)
		timer_damage.start()
		visible = not visible
		tick+=1
		
	elif tick==1 and timer_damage.is_stopped():
		deleteNode()
		explosion.generate_damage()

# Envia la señal para indicar que el misil choco y exploto al soldado
func sendColisionToSoldier():
	soldierShot.colisionShot()
	
func deleteNode():
	sendColisionToSoldier()
	queue_free()
