extends Area2D

onready var planet = get_parent()
var GRAVITY_FORCE = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = planet.global_position
	gravity = GRAVITY_FORCE
	connect("body_entered", self, "on_gravity_entered")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("add_grav"):
		sum_gravity(gravity/100 * 40)
	
	elif Input.is_action_just_pressed("low_grav"):
		sum_gravity(-gravity/100 * 40)
	
func sum_gravity(add_value):
	gravity += add_value
	for body in get_overlapping_bodies():
		if body.has_method("change_gravity"):
				body.change_gravity(gravity)

func on_gravity_entered(body: Node2D):
	if body.has_method("change_gravity_point"):
		var last_rotation = body.get_rotation()
		var gravity_vector = (planet.global_position - body.global_position).normalized()
		var new_rotation = body.get_rotation_player(gravity_vector)
		body.speed = body.speed.rotated(-(new_rotation-last_rotation))
		body.change_gravity_point(planet)
