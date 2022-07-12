extends RigidBody2D

# Variables
var grav_point = Vector2()
var b_rotation = 0
onready var Planet = get_parent().get_node("listPlanets").get_node("Planet1")
onready var sprite = $Sprite
onready var area_vision = $AreaVision
onready var timer_damage = $Timer_damage
onready var soldierShot
onready var camera = $Camera2D
var EXPLOSION = preload("res://scenes/soldiers/weapons/proximity_mine/explosion_mine.tscn")
var tick = 0
var explosion

# Called when the node enters the scene tree for the first time.
func _ready():
	grav_point = Planet.global_position
	contact_monitor = true
	tick = 0

# Funcion para asociar el proyectil con el soldado que ejecuto el disparo
# Aqui se cambian las variables que no se pueden inicializar en _ready()
func init_weapon(soldier: Node):
	soldierShot = soldier

# Recibe daño de la fuente que es entregada como parametro de la funcion
func take_damage(damage_origin: Node):
	deleteNode()

# Cheque si existe colision del misil para ejecutar su explosion/daño o no
func check_colision():
	
	# Etapa uno: Llegada y activacion de colision
	if abs(linear_velocity.x) < 5 and abs(linear_velocity.y) < 5 and tick == 0:
		tick += 1
		print("se activo la mina")
		sendColisionToSoldier()
		
	# Etapa 2: Revisa si hay soldados en el area de activacion
	elif tick > 0:
		var bodies = area_vision.get_overlapping_bodies()
		
		if len(bodies) > 0 and tick == 1:
			for body in bodies:
				# Se revisa si es soldado los cuerpos obtenidos
				if body.has_method("take_damage") and body != self:
					explosion = EXPLOSION.instance()
					explosion.init(global_position, grav_point)
					get_parent().add_child(explosion)
					timer_damage.start()
					visible = not visible
					tick += 1
					break
		
		elif tick == 2 and timer_damage.is_stopped():
			explosion.generate_damage()
			deleteNode()
				
# Envia la señal para indicar que el misil choco y exploto al soldado
func sendColisionToSoldier():
	soldierShot.colisionShot()

# Funcion para eliminarse
func deleteNode():
	sendColisionToSoldier()
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	check_colision()
