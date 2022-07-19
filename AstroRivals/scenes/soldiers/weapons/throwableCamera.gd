extends Camera2D


var grav_point = Vector2()
var closest_zoom = 0.5
var farthest_zoom = 1.0
onready var Planet = get_parent().get_parent().get_node("listPlanets").get_node("Planet1")

# Called when the node enters the scene tree for the first time.
func _ready():
	grav_point = Planet.global_position
	var gravity_vector = (grav_point - global_position).normalized()
	global_rotation = gravity_vector.angle()-(PI/2)
	zoom = Vector2(closest_zoom, closest_zoom)
	# rotation = gravity_vector.angle()
	make_current()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var gravity_vector = (grav_point - global_position).normalized()
	global_rotation = gravity_vector.angle()-(PI/2)
	var distance_from_planet = (grav_point-global_position).length()
	if distance_from_planet <= 235:
		zoom = Vector2(closest_zoom, closest_zoom)
	elif distance_from_planet >= 500:
		zoom = Vector2(farthest_zoom, farthest_zoom)
	else:
		var y = (distance_from_planet*(farthest_zoom-closest_zoom))/225
		zoom = Vector2(y,y)
