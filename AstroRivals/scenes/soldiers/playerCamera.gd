extends Camera2D


var initialZoom : float = 0.5

export var min_zoom = 0.4
export var max_zoom = 1.0
export var zoom_factor = 0.1
export var zoom_duration = 0.2

var _zoom_level := initialZoom setget _change_zoom

onready var tween: Tween = $Tween

func set_zoom_value(zoom_value):
	set_zoom(Vector2(zoom_value, zoom_value))

# Called when the node enters the scene tree for the first time.
func _ready():
	set_zoom_value(initialZoom)

func reset_camera():
	set_zoom_value(initialZoom)

func _change_zoom(value: float):
	_zoom_level = clamp(value, min_zoom, max_zoom)
	
	tween.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(_zoom_level, _zoom_level),
		zoom_duration,
		tween.TRANS_SINE,
		# Easing out means we start fast and slow down as we reach the target value.
		tween.EASE_OUT
	)
	tween.start()

func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		# Inside a given class, we need to either write `self._zoom_level = ...` or explicitly
		# call the setter function to use it.
		_change_zoom(_zoom_level - zoom_factor)
		#print(_zoom_level)
	if event.is_action_pressed("zoom_out"):
		#print(_zoom_level + zoom_factor)
		_change_zoom(_zoom_level + zoom_factor)
		#print(_zoom_level)
