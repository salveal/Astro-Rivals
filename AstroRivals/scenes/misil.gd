extends RigidBody2D

# Variables
var grav_point = Vector2()
var b_rotation = 0
var fallen_rotation = 0;
onready var Planet = get_parent().get_node("Planet")
onready var sprite = $Sprite
onready var animTree = $AnimationTree
onready var playback = animTree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	grav_point = Planet.global_position
	playback.travel("init")
	contact_monitor = true
	contacts_reported = 2

func get_rotation_player(vel_vector):
	var rotation = Vector2(1,0)
	return rotation.angle_to(vel_vector)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var gravity_vector = (grav_point - position).normalized()
	var linear_vel = get_linear_velocity()
	if linear_vel.length() > 20:
		b_rotation = get_rotation_player(linear_vel.normalized())
	#if linear_velocity.y < 0:
	#	fallen_rotation += 0.3
	#	rotation += fallen_rotation
		set_rotation(b_rotation)

	#if contact_monitor:
	#	queue_free()
