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
	# Se obtienen los objetos que han colisionado con los 4 bordes que posee el mapa
	bodiesColision = leftLimit.get_overlapping_bodies() + rightLimit.get_overlapping_bodies() \
					+ bottomLimit.get_overlapping_bodies() + upperLimit.get_overlapping_bodies()

	# Si hay algun objeto, se debe eliminar
	for body in bodiesColision:
		# Se comprueba si tiene el metodo deleteNode() por si tiene que ejecutar codigo antes de eliminar
		if body.has_method("deleteNode"):
			body.deleteNode()
		else:
			body.queue_free()
