extends Node2D

# Variables
var soldierBlade
var damage_value = 100
var tick = 0

onready var timer_damage = $Timer
onready var area_damage = $AreaDamage
onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	timer_damage.start()
	var rotation = Vector2(1,0).angle_to((get_global_mouse_position() - soldierBlade.global_position).normalized())
	set_rotation(rotation)

func init_weapon(soldier: Node):
	soldierBlade = soldier
	
func check_damage():
	var bodies = area_damage.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(self)

# Envia la señal para indicar que el misil choco y exploto al soldado
func sendColisionToSoldier():
	soldierBlade.colisionShot()

# Funcion para eliminarse
func deleteNode():
	sendColisionToSoldier()
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if tick == 0:
		tick += 1
	
	elif tick > 0 and timer_damage.is_stopped():
		check_damage()
		deleteNode()
