extends Node2D

func _ready():
	pass # Replace with function body.

func _draw():
	draw_circle($Planet.position, $Planet/CollisionShape2D.shape.radius, Color(1,0,0,1))
	draw_circle($Planet.position, $Planet/Gravity/CollisionShape2D.shape.radius, Color(0,1,1,0.1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
