extends Node2D

# Variables
var bodies
var damage_value

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Se creo la explosion")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func generate_damage():
	print("Generando daño")
	bodies = $Area2D.get_overlapping_bodies()
	if len(bodies) > 0:
		damage_value = randi() % 5 + 20
		for i in bodies:
			print(i)
			if i.has_method("take_damage"):
				i.take_damage(self)

