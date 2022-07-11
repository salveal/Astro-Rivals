extends Control

# Variables botones
onready var button_reset = $VBoxContainer/Reset
onready var button_exit = $VBoxContainer/Exit
var actual_level_areas_spawn_items
var actual_level_string_scene
var scene_node
var scene

# Called when the node enters the scene tree for the first time.
func _ready():
	button_reset.connect("pressed", self, "_on_button_reset_pressed")
	button_exit.connect("pressed", self, "_on_button_exit_pressed")
	
func set_variables(areas, path, node):
	actual_level_areas_spawn_items = areas
	actual_level_string_scene = path
	scene_node = node

func _on_button_reset_pressed():
	scene = load(actual_level_string_scene).instance()
	scene.set_spawn_areas(actual_level_areas_spawn_items)
	scene.set_scene_string(actual_level_string_scene)
	get_tree().get_root().add_child(scene)
	get_tree().get_root().remove_child(scene_node)
	
func _on_button_exit_pressed():
	scene = load("res://scenes/backgroundMenu.tscn").instance()
	get_tree().get_root().add_child(scene)
	get_tree().get_root().remove_child(scene_node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
