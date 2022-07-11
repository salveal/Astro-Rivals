extends Control

onready var exit = $Button3

func _ready():
	exit.connect("pressed", self, "_on_exit_pressed")

func _on_exit_pressed():
	var scene = load("res://scenes/backgroundMenu.tscn").instance()
	get_tree().get_root().add_child(scene)
	get_tree().get_root().remove_child(self)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
