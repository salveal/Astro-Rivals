extends Area2D

onready var planet = get_parent()
var GRAVITY_FORCE = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	# Se setean las variables relacionada con los planetas y se crea la señal
	# para indicar que un cuerpo entro al area de gravedad
	global_position = planet.global_position
	gravity = GRAVITY_FORCE
	connect("body_entered", self, "on_gravity_entered")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# funcion para editar la gravedad del planeta (posiblemente mejor cambiar el nombre del metodo)
func sum_gravity(add_value):
	# Se suma la gravedad
	gravity += add_value
	
	# Se cambia el valor de gravedad para todos los cuerpos que estan dentro del area
	# este bloque fue hecho para los nodos de RigidBody como los soldados
	for body in get_overlapping_bodies():
		if body.has_method("change_gravity"):
				body.change_gravity(gravity)

# Funcion para asociar la señal de body_entered
# Esta se ejecuta cuando entra un objeto a una area de gravedad nueva 
func on_gravity_entered(body: Node2D):
	if body.has_method("change_gravity_point"):
		var last_rotation = body.get_rotation()
		var gravity_vector = (planet.global_position - body.global_position).normalized()
		var new_rotation = body.get_rotation_player(gravity_vector)
		body.speed = body.speed.rotated(-(new_rotation-last_rotation))
		body.change_gravity_point(planet)
