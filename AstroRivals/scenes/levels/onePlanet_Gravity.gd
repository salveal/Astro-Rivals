extends Area2D

# Imports
onready var planet = get_parent()
onready var particles_pos = get_parent().get_node("ParticlesGravityPos")
onready var particles_neg = get_parent().get_node("ParticlesGravityNeg")
onready var GUI_level = get_parent().get_node("levelIndex")

# Variables para el cambio de gravedad
var velocity_gravity = [0.005, 0.02, 0.04, 0.06, 0.08, 0.1, 0.12] # para las particulas
var list_gravity = [0, 100, 150, 300, 400, 600, 800] # para la variable gravedad del planeta
var color_gravity = [Color(0.5,0,1,1), Color(0.6,0,1,1), Color(0.7,0,1,1), Color(0.8,0,1,1), Color(0.9,0,1,1), Color(0.95,0,1,1), Color(1,0,1,1)]
var actual_level_gravity # indice con el nivel actual del planeta
var index_display 

# Called when the node enters the scene tree for the first time.
func _ready():
	# Se setean las variables relacionada con los planetas y se crea la señal
	# para indicar que un cuerpo entro al area de gravedad
	global_position = planet.global_position
	actual_level_gravity = 3
	index_display = 0
	GUI_level.visible = false
	change_gravity_level(actual_level_gravity)
	connect("body_entered", self, "on_gravity_entered")
	
func change_gravity_level(index: int):
	gravity = list_gravity[index]
	particles_pos.process_material.orbit_velocity = velocity_gravity[index]
	particles_neg.process_material.orbit_velocity = -velocity_gravity[index]
	
	GUI_level.set_text(str(actual_level_gravity))
	GUI_level.add_color_override("font_color", color_gravity[actual_level_gravity])
	
	change_bodies_gravity()
	
# Funcion para aumentar el nivel de gravedad en uno
func add_level_gravity():
	actual_level_gravity += 1
	if list_gravity.size() <= actual_level_gravity:
		actual_level_gravity = list_gravity.size() - 1 
		print("No puede aumentar mas la gravedad")
	change_gravity_level(actual_level_gravity)
	
# Funcion para aumentar el nivel de gravedad en uno
func sub_level_gravity():
	actual_level_gravity -= 1
	if actual_level_gravity < 0:
		actual_level_gravity = 0
		print("No puede disminuir mas la gravedad")
	change_gravity_level(actual_level_gravity)

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
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("change_hud"):
		index_display = (index_display + 1) % 3
		if index_display == 2:
			GUI_level.visible = true
		
		else:
			GUI_level.visible = false

