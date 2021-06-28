extends AnimatedSprite

var burning = false
var color = "Red"
var valid_colors = ["Red", "Orange", "Yellow", "Lime", "Green", "Cyan", "Blue", "Purple"]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func update_color(new_color):
	if valid_colors.find(new_color) != -1:
		color = new_color
		animation = color + "_Normal"

func _on_Area2D_body_entered(body):
	if body.is_in_group("Villager"):
		if body.mode == 7:
			burning = true
			animation = color + "_Fire"
			$Light2D.visible = true
