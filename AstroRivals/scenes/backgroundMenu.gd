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

func _on_start_pressed():
	string_scene = "res://scenes/levels/Level1.tscn"
	scene = load(string_scene).instance()
	spawn_area_items = [
		{"top_left": Vector2(64,64), "y_len": 960, "x_len": 458},
		{"top_left": Vector2(1408,64), "y_len": 960, "x_len": 458}
	]
	replace_scene()
	
func _on_credits_pressed():
	string_scene = "res://scenes/levels/Level2.tscn"
	spawn_area_items = [
		{"top_left": Vector2(256,64), "y_len": 192, "x_len": 1408},
		{"top_left": Vector2(256,832), "y_len": 192, "x_len": 1408}
	]
	replace_scene()
	
func replace_scene():
	scene = load(string_scene).instance()
	scene.set_spawn_areas(spawn_area_items)
	scene.set_scene_string(string_scene)
	get_tree().get_root().add_child(scene)
	get_tree().get_root().remove_child(self)

func _on_exit_pressed():
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Background.scroll_base_offset += direction * speed * delta
	
	if Background.scroll_base_offset.x < -2000 or Background.scroll_base_offset.x > 0:
		direction = - direction
