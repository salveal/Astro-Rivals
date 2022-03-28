extends KinematicBody2D
var SPEED = 150
var ACCELERATION = 400
var GRAVITY = 4000
var velocity = Vector2()
var grav_point = Vector2(506,303)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Function called to move the player around the scene
func _physics_process(delta):
	var direction = grav_point - position
	velocity = move_and_slide(velocity, direction, true, 5)
	velocity = direction.normalized() * GRAVITY * delta
	var rotation = position.angle_to(grav_point)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$pos.text = (str(get_floor_angle()))
