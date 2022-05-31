extends Control

onready var exit = $VBoxContainer/Button3

func _ready():
	exit.connect("pressed", self, "_on_exit_pressed")

func _on_exit_pressed():
	get_tree().change_scene("res://scenes/backgroundMenu.tscn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
