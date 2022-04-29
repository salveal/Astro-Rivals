extends Node2D

onready var actualPlayer = $BluePlayer
var player = 0 # 0 = blue, 1 = red

func _ready():
	$BluePlayer.active = true
	$RedPlayer.active = false

func _draw():
	draw_circle($Planet.position, $Planet/Gravity/CollisionShape2D.shape.radius, Color(0,1,1,0.1))

func _input(event):
	if actualPlayer.getChangeControl():
		actualPlayer.active = false
		actualPlayer.changeControl = false
		if player == 0:
			actualPlayer = $RedPlayer
		else:
			actualPlayer = $BluePlayer
		player = 1 - player
		actualPlayer.active = true
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
