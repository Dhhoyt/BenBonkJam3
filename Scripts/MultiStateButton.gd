class_name MultiStateButton
extends TextureButton

signal on_state_changed(state)

export var states = []
export var state = 0

func _ready():
	connect("pressed", self, "on_press")
	
	texture_normal = states[state]
	emit_signal("on_state_changed", state)
func on_press():
	state += 1
	if state >= len(states):
		state = 0
	texture_normal = states[state]
	emit_signal("on_state_changed", state)
