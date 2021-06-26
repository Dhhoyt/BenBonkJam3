extends KinematicBody2D

var mode = 0 # 0 is run 1 is fork 2 is dead 3 is hidden 
var color = "Red"
onready var sprite = $AnimatedSprite
onready var collision = $CollisionShape2D
onready var timer = $DeadTimer

var valid_colors = ["Red", "Orange", "Yellow", "Lime", "Green", "Cyan", "Blue", "Purple"]
export(Array, float) var speeds = [4, 3, 2, 1]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if mode == 0:
		sprite.animation = color + "_Run"
	elif mode == 1:
		sprite.animation = color + "_Fork"
	elif mode == 2:
		sprite.animation = color + "_Dead"
	elif mode == 3:
		collision.set_deferred("disabled", true)
		timer.start()
		set_process(false)


func _on_Timer_timeout():
	queue_free()
