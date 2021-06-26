extends Sprite

var color = "Red"
var valid_colors = ["Red", "Orange", "Yellow", "Lime", "Green", "Cyan", "Blue", "Purple"]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func update_color(new_color):
	if valid_colors.find(new_color) != -1:
		color = new_color
		frame_coords.y = valid_colors.find(new_color)
