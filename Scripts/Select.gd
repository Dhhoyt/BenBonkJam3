extends TextureRect
signal state_changed(state)
var state = 0
func _ready():
	$Up.connect("pressed", self, "up")
	$Down.connect("pressed", self, "down")
func _process(delta):
	texture.region.position.y = state*32

func up():
	state -= 1
	if state < 0:
		state = (texture.atlas.get_height()-32)/32
	emit_signal("state_changed", state)
func down():
	state += 1
	if state >= texture.atlas.get_height()/32:
		state = 0
	emit_signal("state_changed", state)
