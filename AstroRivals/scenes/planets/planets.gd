extends StaticBody2D

onready var gravity_node = $Gravity
var GRAVITY_FORCE = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_node.gravity = GRAVITY_FORCE
	connect("body_entered", self, "on_gravity_entered")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func sum_gravity(add_value):
	gravity_node.gravity += add_value
	for body in gravity_node.get_overlapping_bodies():
		if body.has_method("change_gravity"):
				body.change_gravity(gravity_node.gravity)

func on_gravity_entered(body: Node2D):
	if body.has_method("change_gravity_point"):
		var last_rotation = body.get_rotation()
		var gravity_vector = (global_position - body.global_position).normalized()
		var new_rotation = body.get_rotation_player(gravity_vector)
		body.speed = body.speed.rotated(-(new_rotation-last_rotation))
		body.change_gravity_point(self)
