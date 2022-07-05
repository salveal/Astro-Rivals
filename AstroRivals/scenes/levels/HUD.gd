extends CanvasLayer

# Variables de HUD
onready var hudBlueTeam = $HUDBlueTeam
onready var hudRedTeam = $HUDRedTeam
onready var hudSimple = $HUDSimple

# Called when the node enters the scene tree for the first time.
func _ready():
	hudBlueTeam.color = Color(0,0,1,0.58)
	hudRedTeam.color = Color(1,0,0,0.58)

func change_color_hud(new_color: Color):
	hudSimple.color = new_color
	hudSimple.get_node("HUDSimple_rigth").color = new_color
	hudSimple.get_node("HUDSimple_left").color = new_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
