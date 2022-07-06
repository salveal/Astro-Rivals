extends RigidBody2D

# Variables
var grav_point = Vector2()
var b_rotation = 0
var damage_value
onready var Planet = get_parent().get_node("listPlanets").get_node("Planet1")
onready var sprite = $Sprite
onready var soldierShot

# Called when the node enters the scene tree for the first time.
func _ready():
	grav_point = Planet.global_position
	contact_monitor = true

# Funcion para asociar el proyectil con el soldado que ejecuto el disparo
# Aqui se cambian las variables que no se pueden inicializar en _ready()
func init_weapon(soldier: Node):
	soldierShot = soldier
	
	# Se obtiene el daño de la flecha
	randomize()
	damage_value = randi() % 15 + 35

# Funcion para calcular la rotacion del misil con respecto al planeta asociado
func get_rotation_player(vel_vector):
	var rotation = Vector2(1,0)
	return rotation.angle_to(vel_vector)

# Cheque si existe colision del misil para ejecutar su explosion/daño o no
func check_colision():
	var bodies = get_colliding_bodies()
	if len(bodies) > 0:
		for body in bodies:
			if body.has_method("take_damage"):
				body.take_damage(self)
		deleteNode()
		
# Envia la señal para indicar que el misil choco y exploto al soldado
func sendColisionToSoldier():
	soldierShot.colisionShot()
	
func deleteNode():
	sendColisionToSoldier()
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var gravity_vector = (grav_point - position).normalized()
	var linear_vel = get_linear_velocity()
	if linear_vel.length() > 20:
		b_rotation = get_rotation_player(linear_vel.normalized())
		set_rotation(b_rotation)
		
	check_colision()
