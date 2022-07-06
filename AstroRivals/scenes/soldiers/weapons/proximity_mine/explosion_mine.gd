extends Node2D

# Variables
var bodies
var damage_value
var grav_position = Vector2()
var impulse = 400
onready var timer_delete = $Timer_delete

# Called when the node enters the scene tree for the first time.
func _ready():
	timer_delete.start()
	
func init(explosion_position, planet_position):
	var gravity_vector = (planet_position - global_position).normalized()
	var anim_rotation = Vector2(0,1).angle_to(gravity_vector)
	set_position(explosion_position)
	set_rotation(anim_rotation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer_delete.is_stopped():
		queue_free()
	
func generate_damage():
	bodies = $Area2D.get_overlapping_bodies()
	if len(bodies) > 0:
		damage_value = randi() % 16 + 40
		for i in bodies:
			if i.has_method("take_damage"):
				i.take_damage(self)

