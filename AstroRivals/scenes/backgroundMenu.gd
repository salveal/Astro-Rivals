extends Control

onready var Background = $ParallaxBackground
onready var start = $VBoxContainer/Button
onready var credits = $VBoxContainer/Button2
onready var exit = $VBoxContainer/Button3

var speed = 5
var direction = Vector2(-1,0)


func _ready():
	start.connect("pressed", self, "_on_start_pressed")
	credits.connect("pressed",self,"_on_credits_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")

func _on_start_pressed():
	get_tree().change_scene("res://scenes/levels/Level1.tscn")
	
func _on_credits_pressed():
	get_tree().change_scene("res://scenes/levels/Level2.tscn")

func _on_exit_pressed():
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Background.scroll_base_offset += direction * speed * delta
