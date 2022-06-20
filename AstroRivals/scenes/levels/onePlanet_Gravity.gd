extends Area2D

onready var planet = get_parent()
var list_gravity = [0, 100, 150, 300, 400, 600, 800]
var actual_level_gravity

# Called when the node enters the scene tree for the first time.
func _ready():
	# Se setean las variables relacionada con los planetas y se crea la señal
	# para indicar que un cuerpo entro al area de gravedad
	global_position = planet.global_position
	actual_level_gravity = 3
	gravity = list_gravity[actual_level_gravity]
	connect("body_entered", self, "on_gravity_entered")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Funcion para aumentar el nivel de gravedad en uno
func add_level_gravity():
	actual_level_gravity += 1
	if list_gravity.size() <= actual_level_gravity:
		actual_level_gravity = list_gravity.size() - 1 
		print("No puede aumentar mas la gravedad")
	gravity = list_gravity[actual_level_gravity]
	change_bodies_gravity()
	
# Funcion para aumentar el nivel de gravedad en uno
func sub_level_gravity():
	actual_level_gravity -= 1
	if actual_level_gravity < 0:
		actual_level_gravity = 0
		print("No puede disminuir mas la gravedad")
	gravity = list_gravity[actual_level_gravity]
	change_bodies_gravity()

func change_bodies_gravity():
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
