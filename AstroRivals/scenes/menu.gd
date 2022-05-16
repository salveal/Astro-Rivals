extends MarginContainer

onready var start = $PanelContainer/VBoxContainer/Start
onready var credits = $PanelContainer/VBoxContainer/Credits
onready var exit = $PanelContainer/VBoxContainer/Exit

func _ready():
	start.connect("pressed", self, "_on_start_pressed")
	credits.connect("pressed",self,"_on_credits_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")

func _on_start_pressed():
	get_tree().change_scene("res://scenes/levels/Level1.tscn")
	
func _on_credits_pressed():
	get_tree().change_scene("res://scenes/levels/demo.tscn")

func _on_exit_pressed():
	get_tree().quit()
