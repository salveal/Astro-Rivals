extends Area2D

onready var planet = get_parent()
var GRAVITY_FORCE = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = planet.global_position
	gravity = GRAVITY_FORCE
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
