extends KinematicBody2D

var speed = 20
var map_size = Vector2(192,256)
var padding = 10
var mode = 0 # 0 is wander 1 is runing 2 is running, but outside of the werewolf's range 3 is searching for a house 4 is fighting 5 is hidden 6 is dead
var color = "Red"
var path = PoolVector2Array()
var moving = false
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
	randomize()
	change_state(0) # Replace with function body.
	get_new_goal()

func _process(delta):
	if moving:
		move_along_path(speed * delta)
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
		get_new_goal()

func run():
	if global_position.distance_to(werewolf.global_position) > werewolf_range:
		change_state(2)
		get_new_goal()

func panic():
	if global_position.distance_to(werewolf.global_position) < werewolf_range:
		runtimer.stop()
		change_state(1)
		get_new_goal()

func search():
	if global_position.distance_to(werewolf.global_position) < werewolf_range:
		change_state(1)
		get_new_goal()

func aggro():
	pass

func get_new_goal():
	var new_goal = global_position
	if mode == 0:
		new_goal.x = randf() * (map_size.x - padding * 2) + padding
		new_goal.y = randf() * (map_size.y - padding * 2) + padding
	elif mode == 1:
		werewolf.global_position.linear_interpolate(global_position, 3)
	elif mode == 2:
		pass
	elif mode == 3:
		pass
	elif mode == 4:
		pass
	path = nav_2d.get_simple_path(global_position, new_goal)
	
func move_along_path(distance):
	var start_point = position
	for i in range(path.size()):
		var distance_to_next = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = start_point.linear_interpolate(path[0], distance/distance_to_next)
			break
		elif distance < 0.5:
			position = path[0]
			get_new_goal()
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)

func change_state(new_state : int):
	if (not new_state >= 0) or (not new_state <= 6):
		return
	mode = new_state
	if new_state == 0:
		moving = true
		visible = true
		sprite.animation = color + "_Wander"
	elif new_state == 1:
		moving = true
		visible = true
		sprite.animation = color + "_Run"
	elif new_state == 2:
		moving = true
		visible = true
		runtimer.start()
		sprite.animation = color + "_Run"
	elif new_state == 3:
		moving = true
		visible = true
		sprite.animation = color + "_Wander"
	elif new_state == 4:
		moving = true
		visible = true
		sprite.animation = color + "_Fork"
	elif new_state == 5:
		moving = false
		visible = false
	elif new_state == 6:
		moving = false
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
