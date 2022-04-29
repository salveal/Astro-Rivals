extends RigidBody2D

# Variables
var grav_point = Vector2()
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

func get_rotation_player(grav_vector):
	var rotation = Vector2(0,1)
	return rotation.angle_to(grav_vector)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var gravity_vector = (grav_point - position).normalized()
	var rotation = get_rotation_player(gravity_vector)
	#if linear_velocity.y < 0:
	#	fallen_rotation += 0.3
	#	rotation += fallen_rotation
	set_rotation(rotation)

	#if contact_monitor:
	#	queue_free()
