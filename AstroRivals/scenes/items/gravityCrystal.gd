extends RigidBody2D

onready var associated_planet

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func init(planet: Node2D):
	associated_planet = planet

func check_colision():
	var bodies = get_colliding_bodies()
	if len(bodies) > 0:
		var actual_gravity = associated_planet.get_child(2).gravity
		associated_planet.get_child(2).sum_gravity(100)
		print(associated_planet)
		print("ha cambiado su gravedad")
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_colision()
