extends KinematicBody2D

var speed = 4
var mode = 0 # 0 is wander 1 is runing 2 is running, but outside of the werewolf's range 3 is searching for a house 4 is fighting 5 is hidden 6 is dead
var color = "Red"
onready var sprite = $AnimatedSprite
onready var collision = $CollisionShape2D
onready var deadtimer = $DeadTimer
onready var runtimer = $RunTimer
onready var werewolf = $"../../Werewolf"
onready var nav_2d = $"../../Village/Navigation2D"

var valid_colors = ["Red", "Orange", "Yellow", "Lime", "Green", "Cyan", "Blue", "Purple"]
export(Array, float) var speeds = [4, 3, 2, 1]
export(float) var werewolf_range = 40

func _ready():
	change_state(0) # Replace with function body.

func _process(delta):
	if mode == 0:
		wander()
	elif mode == 1:
		run()
	elif mode == 2:
		panic()
	elif mode == 3:
		search()
	elif mode == 4:
		aggro()
	elif mode == 5:
		hide()

func wander():
	#TODO: WANDER BEHAVIOR
	if global_position.distance_to(werewolf.global_position) < werewolf_range:
		change_state(1)

func run():
	if global_position.distance_to(werewolf.global_position) > werewolf_range:
		runtimer.start()
		change_state(2)

func panic():
	if global_position.distance_to(werewolf.global_position) < werewolf_range:
		runtimer.stop()
		change_state(1)

func search():
	if global_position.distance_to(werewolf.global_position) < werewolf_range:
		change_state(1)

func aggro():
	pass

# Dont look at this code
func change_state(new_state : int):
	if (not new_state > 0) or (not new_state < 6):
		return
	mode == new_state
	if new_state == 0:
		visible = true
		sprite.animation = color + "_Wander"
	elif new_state == 1:
		visible = true
		sprite.animation = color + "_Run"
	elif new_state == 2:
		visible = true
		sprite.animation = color + "_Run"
	elif new_state == 3:
		visible = true
		sprite.animation = color + "_Wander"
	elif new_state == 4:
		visible = true
		sprite.animation = color + "_Fork"
	elif new_state == 5:
		visible = true
	elif new_state == 6:
		visible = true
		sprite.animation = color + "_Dead"
		deadtimer.start()
		set_process(false)

func set_color(new_color : String):
	if valid_colors.find(new_color) != -1:
		color = new_color
		speed = speeds[int(floor(valid_colors.find(new_color)/2))]

func _on_DeadTimer_timeout():
	queue_free()

func _on_RunTimer_timeout():
	change_state(3)
