extends Control

onready var Background = $ParallaxBackground
onready var main_menu = $VBoxContainer/Button


var speed = 5
var direction = Vector2(-1,0)
var scene

func _ready():
	main_menu.connect("pressed", self, "_on_main_menu_pressed")
	
func _on_main_menu_pressed():
	var scene = load("res://scenes/backgroundMenu.tscn").instance()
	get_tree().get_root().add_child(scene)
	get_tree().get_root().remove_child(self)

func _process(delta):
	Background.scroll_base_offset += direction * speed * delta
	
	if Background.scroll_base_offset.x < -2000 or Background.scroll_base_offset.x > 0:
		direction = - direction
