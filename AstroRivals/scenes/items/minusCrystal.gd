extends RigidBody2D

onready var associated_planet
onready var particles = $Particles2D

var direction_particles = Vector3(0,100,0)
var is_direction_changed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Funcion de inicializacion, se le asocia un planeta para poder editar la gravedad
func init(planet: Node2D):
	associated_planet = planet
	
func check_colision():
	# Funcion para observar si la gema tuvo alguna colision con un cuerpo
	var bodies = get_colliding_bodies()
	if len(bodies) > 0:
		# Se cambia la gravedad actual del planeta
		var actual_gravity = associated_planet.get_child(2).gravity
		associated_planet.get_child(2).sub_level_gravity()
		print(associated_planet)
		print("ha cambiado su gravedad")
		queue_free()
		
func change_direction_particles():
	direction_particles = (associated_planet.position - global_position).normalized() * 100
	direction_particles = Vector3(direction_particles.x, direction_particles.y, 0)
	particles.process_material.gravity = direction_particles

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Chequea si hay colisiones
	check_colision()
	
	# Este bloque se podria mejorar en terminos de rendimiento, funciona pero no es lo optimo
	if !is_direction_changed:
		is_direction_changed = true
		change_direction_particles()

