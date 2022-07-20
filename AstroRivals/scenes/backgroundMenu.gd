extends Control

onready var Background = $ParallaxBackground
onready var start = $VBoxContainer/Button
onready var credits = $VBoxContainer/Button2
onready var exit = $VBoxContainer/Button3

var speed = 5
var direction = Vector2(-1,0)
onready var scene
var spawn_area_items
var string_scene

func _ready():
	start.connect("pressed", self, "_on_start_pressed")
	credits.connect("pressed",self,"_on_credits_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")

func replace_scene():
	scene = load(string_scene).instance()
	scene.set_spawn_areas(spawn_area_items)
	scene.set_scene_string(string_scene)
	get_tree().get_root().add_child(scene)
	get_tree().get_root().remove_child(self)

func _on_start_pressed():
	scene = load("res://scenes/levelSelector.tscn").instance()
	get_tree().get_root().add_child(scene)
	get_tree().get_root().remove_child(self)
	
func _on_credits_pressed():
	pass
	
func _on_exit_pressed():
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Background.scroll_base_offset += direction * speed * delta
	
	if Background.scroll_base_offset.x < -1000 or Background.scroll_base_offset.x > 0:
		direction = - direction
