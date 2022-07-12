extends Camera2D


var grav_point = Vector2()
onready var Planet = get_parent().get_parent().get_node("listPlanets").get_node("Planet1")

# Called when the node enters the scene tree for the first time.
func _ready():
	grav_point = Planet.global_position
	var gravity_vector = (grav_point - global_position).normalized()
	global_rotation = gravity_vector.angle()-(PI/2)
	#rotation = gravity_vector.angle()
	make_current()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var gravity_vector = (grav_point - global_position).normalized()
	global_rotation = gravity_vector.angle()-(PI/2)
	#rotation = gravity_vector.angle()
