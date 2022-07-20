extends Control

onready var preview_sprite = $ColorRect/Preview
onready var Background = $ParallaxBackground
onready var level1 = $VBoxContainer/Button
onready var level2 = $VBoxContainer/Button2
onready var level3 = $VBoxContainer/Button3
onready var backToMenu = $Button4

var speed = 5
var direction = Vector2(-1,0)
onready var scene
var spawn_area_items
var string_scene

func _ready():
	level1.connect("pressed", self, "_level1_selected")
	level2.connect("pressed",self,"_level2_selected")
	level3.connect("pressed", self, "_level3_selected")
	backToMenu.connect("pressed", self, "_on_exit_pressed")
	
# Funcion para poder remplazar la escena y poder 
func replace_scene():
	scene = load(string_scene).instance()
	scene.set_spawn_areas(spawn_area_items)
	scene.set_scene_string(string_scene)
	get_tree().get_root().add_child(scene)
	get_tree().get_root().remove_child(self)

# Funcion para cargar el nivel 1
func _level1_selected():
	string_scene = "res://scenes/levels/Level1.tscn"
	scene = load(string_scene).instance()
	spawn_area_items = [
		{"top_left": Vector2(64,64), "y_len": 960, "x_len": 458},
		{"top_left": Vector2(1408,64), "y_len": 960, "x_len": 458}
	]
	replace_scene()
	
# Funcion para cargar el nivel 2
func _level2_selected():
	string_scene = "res://scenes/levels/Level2.tscn"
	spawn_area_items = [
		{"top_left": Vector2(256,64), "y_len": 192, "x_len": 1408},
		{"top_left": Vector2(256,832), "y_len": 192, "x_len": 1408}
	]
	replace_scene()
	
# Funcion para cargar el nivel 3
func _level3_selected():
	string_scene = "res://scenes/levels/Level3.tscn"
	spawn_area_items = [
		{"top_left": Vector2(704,64), "y_len": 576, "x_len": 192},
		{"top_left": Vector2(1024,384), "y_len": 576, "x_len": 256}
	]
	replace_scene()

# Fucion para poder volver al menu principal
func _on_exit_pressed():
	scene = load("res://scenes/backgroundMenu.tscn").instance()
	get_tree().get_root().add_child(scene)
	get_tree().get_root().remove_child(self)

# Funcnion para poder cambiar la preview del nivel seleccionado
func buttons_hovered():
	if level1.is_hovered():
		 preview_sprite.texture = load("res://assets/levels/preview_levels/preview_level1.png")
		
	elif level2.is_hovered():
		preview_sprite.texture = load("res://assets/levels/preview_levels/preview_level2.png")
		
	elif level3.is_hovered():
		preview_sprite.texture = load("res://assets/levels/preview_levels/preview_level3.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	buttons_hovered()
	Background.scroll_base_offset += direction * speed * delta
	
	if Background.scroll_base_offset.x < -1000 or Background.scroll_base_offset.x > 0:
		direction = - direction
