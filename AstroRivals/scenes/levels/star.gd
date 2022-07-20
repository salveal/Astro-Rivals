extends Area2D

# Variables 
onready var anim_player = $AnimationPlayer

var bodiesColision

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Se obtienen los objetos que han colisionado con los 4 bordes que posee el mapa
	bodiesColision = get_overlapping_bodies()

	# Si hay algun objeto, se debe eliminar
	for body in bodiesColision:
		# Se comprueba si tiene el metodo deleteNode() por si tiene que ejecutar codigo antes de eliminar
		if body.has_method("deleteNode"):
			body.deleteNode()
		else:
			body.queue_free()
