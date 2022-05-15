extends Node2D

onready var queueBlue = $queueBlue
onready var queueRed = $queueRed
onready var actualPlayer
onready var planet = $Planet
var indexBlue = 0
var indexRed = 0
var activeTeam # 0 - Blue / 1 - Red

func _ready():
	if randi() % 2 == 0:
		actualPlayer = queueBlue.get_child(0)
		activeTeam = 0
		indexRed = -1
	else:
		actualPlayer = queueRed.get_child(0)
		activeTeam = 1
		indexBlue = -1
	actualPlayer.active = true
		
func _draw():
	draw_circle($Planet.position, $Planet/Gravity/CollisionShape2D.shape.radius, Color(0,1,1,0.1))

func _input(event):
	if actualPlayer.getChangeControl():
		actualPlayer.active = false
		actualPlayer.changeControl = false
		
		if activeTeam == 1: # pasar turno a azul
			indexBlue = (indexBlue + 1) % queueBlue.get_child_count()
			actualPlayer = queueBlue.get_child(indexBlue)
			activeTeam = 0
		else: # pasar turno a rojo
			indexRed = (indexRed + 1) % queueRed.get_child_count()
			actualPlayer = queueRed.get_child(indexRed)
			activeTeam = 1
			
		actualPlayer.active = true
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
