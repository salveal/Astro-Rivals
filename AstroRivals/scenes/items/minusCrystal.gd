extends RigidBody2D

onready var associated_planet

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Funcion de inicializacion, se le asocia un planeta para poder editar la gravedad
func init(planet: Node2D):
	associated_planet = planet

func check_colision():
	# Funcion para observar si la gema tuvo alguna colision con un cuerpo
	var bodies = get_colliding_bodies()
	if len(bodies) > 0:
		# Se cambia la gravedad actual del planeta
		var actual_gravity = associated_planet.get_child(2).gravity
		associated_planet.get_child(2).sum_gravity(-100)
		print(associated_planet)
		print("ha cambiado su gravedad")
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Chequea si hay colisiones
	check_colision()
