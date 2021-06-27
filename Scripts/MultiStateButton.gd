class_name MultiStateButton
extends TextureButton

signal on_state_changed(state)

export(Array, Texture) var states = []
var state = 0

func _ready():
	connect("pressed", self, "on_press")
func _process(delta):
	texture_normal = states[state]
func on_press():
	state += 1
	if state >= len(states):
		state = 0
	emit_signal("on_state_changed", state)
