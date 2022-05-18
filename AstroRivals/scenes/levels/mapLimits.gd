extends Node

onready var leftLimit = $left
onready var rightLimit = $rigth
onready var bottomLimit = $bottom
onready var upperLimit = $upper
var bodiesColision

# Called when the node enters the scene tree for the first time.
func _ready():
	print("se inicializaron los limites del mapa")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bodiesColision = leftLimit.get_overlapping_bodies() + rightLimit.get_overlapping_bodies() \
					+ bottomLimit.get_overlapping_bodies() + upperLimit.get_overlapping_bodies()

	for body in bodiesColision:
		if body.has_method("deleteNode"):
			body.deleteNode()
		else:
			body.queue_free()
