extends RigidBody2D

# Variables
var grav_point = Vector2()
var b_rotation = 0
onready var Planet = get_parent().get_node("Planet")
onready var sprite = $Sprite
onready var animTree = $AnimationTree
onready var timer_damage = $Timer_damage
onready var playback = animTree.get("parameters/playback")
var EXPLOSION = preload("res://scenes/explosion.tscn")
var tick = 0
var explosion

# Called when the node enters the scene tree for the first time.
func _ready():
	grav_point = Planet.global_position
	playback.travel("init")
	contact_monitor = true
	
func get_rotation_player(vel_vector):
	var rotation = Vector2(1,0)
	return rotation.angle_to(vel_vector)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var gravity_vector = (grav_point - position).normalized()
	var linear_vel = get_linear_velocity()
	if linear_vel.length() > 20:
		b_rotation = get_rotation_player(linear_vel.normalized())
		set_rotation(b_rotation)
		
	check_colision()

func check_colision():
	var bodies = get_colliding_bodies()
	if len(bodies) > 0 and tick == 0:
		explosion = EXPLOSION.instance()
		explosion.init(global_position, grav_point)
		get_parent().add_child(explosion)
		timer_damage.start()
		visible = not visible
		tick+=1
		
	elif tick==1 and timer_damage.is_stopped():
		queue_free()
		explosion.generate_damage()
