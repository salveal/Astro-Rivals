extends Camera2D


var grav_point = Vector2()
var closest_zoom = 0.5
var farthest_zoom = 1.0
var on_gravity
var camera_rotation
var cam_grav_offset
var not_first = false
#onready var Planet = get_parent().get_parent().get_node("listPlanets").get_node("Planet1")

# Called when the node enters the scene tree for the first time.
func _ready():
	cam_grav_offset = Vector2(0,0).angle()
	make_current()

func set_grav(pos):
	if pos:
		grav_point = pos
		on_gravity = true
		if not_first:
			var gravity_vector = (grav_point - global_position).normalized()
			cam_grav_offset = gravity_vector.angle()-(PI/2) - camera_rotation
		not_first = true
	else:
		camera_rotation = global_rotation
		on_gravity = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if on_gravity:
		var gravity_vector = (grav_point - global_position).normalized()
		global_rotation = gravity_vector.angle()-(PI/2) - cam_grav_offset
		var distance_from_planet = (grav_point-global_position).length()
		if distance_from_planet <= 235:
			zoom = Vector2(closest_zoom, closest_zoom)
		elif distance_from_planet >= 450:
			zoom = Vector2(farthest_zoom, farthest_zoom)
		else:
			var y = (distance_from_planet*(farthest_zoom-closest_zoom))/215
			zoom = Vector2(y,y)
	else:
		zoom = Vector2(farthest_zoom, farthest_zoom)
