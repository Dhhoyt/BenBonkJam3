extends KinematicBody2D

signal death()
signal scared()
signal calm()
signal hit_player()

var speed = 10
var torch_chance = 0.1
var map_size = Vector2(192,256)
var padding = 15
var mode = 0 # 0 is wander 1 is runing 2 is running, but outside of the werewolf's range 3 is searching for a house 4 is fighting 5 is hidden 6 is dead
var color = "Red"
var path = PoolVector2Array()
var moving = false
var going_to_house = false
var is_day = false
onready var sprite = $AnimatedSprite
onready var collision = $CollisionShape2D
onready var deadtimer = $DeadTimer
onready var runtimer = $RunTimer
onready var houses = $"../../Houses"
onready var werewolf = $"../../Werewolf"
onready var nav_2d = $"../../Village/Navigation2D"
onready var villagers = $"../../Villagers/"
onready var tilemap = $"../../Village/Navigation2D/TileMap"

var valid_colors = ["Red", "Orange", "Yellow", "Lime", "Green", "Cyan", "Blue", "Purple"]
export(Array, float) var speeds = [40, 30, 20, 10]
export(float) var werewolf_range = 40

func _ready():
	randomize()
	set_color(color)
	change_mode(4) # Replace with function body.
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
		hiding(delta)
	elif mode == 7:
		torch(delta * speed)

func wander():
	if global_position.distance_to(werewolf.global_position) < werewolf_range and not is_day:
		change_mode(1)
		get_new_goal()

func run():
	if global_position.distance_to(werewolf.global_position) > werewolf_range:
		change_mode(2)
		get_new_goal()

func panic():
	if global_position.distance_to(werewolf.global_position) < werewolf_range and not is_day:
		runtimer.stop()
		change_mode(1)
		get_new_goal()

func search():
	if global_position.distance_to(werewolf.global_position) < werewolf_range and not is_day:
		change_mode(1)
		get_new_goal()

func hiding(delta):
	hide()
	var out = 1
	for i in villagers.get_children():
		if i.mode != 4 and i.mode != 6:
			out += 1
	if randf() < (pow(0.75, out) * delta):
		if randf() < torch_chance:# and !is_day:
			change_mode(7)
			return
		change_mode(0)
		get_new_goal()

func aggro():
	if !$Angry.playing:
		$Angry.play()
	
func torch(distance):
	var distance_to_next = global_position.distance_to(werewolf.global_position)
	global_position = global_position.linear_interpolate(werewolf.global_position, distance/distance_to_next)
	if !$Angry.playing:
		$Angry.play()
	#if tilemap.get_cellv(tilemap.world_to_map(position)) == 0 or tilemap.get_cellv(tilemap.world_to_map(position)) == 2:
	#	change_mode(0)

func get_new_goal():
	var new_goal = global_position
	if mode == 0:
		var temp_goal = Vector2()
		for i in range(5):
			temp_goal.x = randf() * (map_size.x - (padding * 2)) + padding
			temp_goal.y = randf() * (map_size.y - (padding * 2)) + padding
			if is_land(temp_goal):
				new_goal = temp_goal
				break
	elif mode == 1 or mode == 2:
		var temp_goal = Vector2()
		for i in range(1.1, 10, 0.1):
			temp_goal = werewolf.global_position.linear_interpolate(global_position, 3)
			if is_land(temp_goal):
				new_goal = temp_goal
				break
		new_goal.x = clamp(werewolf.global_position.linear_interpolate(global_position, 3).x, padding, map_size.x - padding)
		new_goal.y = clamp(werewolf.global_position.linear_interpolate(global_position, 3).y, padding, map_size.y - padding)
	elif mode == 3:
		var best_distance = 9223372036854775800
		var found_house = false
		for i in houses.get_children():
			if global_position.distance_to(i.global_position) < best_distance and !i.burning:
				best_distance = global_position.distance_to(i.global_position)
				new_goal = i.global_position
				found_house = true
		if found_house:
			going_to_house = true
		else:
			change_mode(2)
	elif mode == 4:
		new_goal = werewolf.global_position
	path = nav_2d.get_simple_path(global_position, new_goal)

func is_land(pos):
	var x = int(pos.x/16)
	var y = int(pos.y/16)
	return tilemap.get_cell(x, y) == 1 or tilemap.get_cell(x, y) == 3

func move_along_path(distance):
	var start_point = position
	for i in range(path.size()):
		var distance_to_next = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			#position = start_point.linear_interpolate(path[0], distance/max(distance_to_next, 0.001))
			move_and_collide((path[0]-start_point).normalized()*distance)
			break
		elif distance < 0.0:
			position = path[0]
			break
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)
	if path.size() == 0:
		if going_to_house == true:
			going_to_house = false
			change_mode(5)
			return
		get_new_goal()

func change_mode(new_mode : int):
	show()
	$Fire.visible = false
	if (not new_mode >= 0) or (not new_mode <= 7):
		return
	mode = new_mode
	if new_mode == 0:
		moving = true
		visible = true
		sprite.animation = color + "_Wander"
	elif new_mode == 1:
		moving = true
		visible = true
		sprite.animation = color + "_Run"
	elif new_mode == 2:
		moving = true
		visible = true
		runtimer.start()
		sprite.animation = color + "_Run"
	elif new_mode == 3:
		moving = true
		visible = true
		sprite.animation = color + "_Run"
	elif new_mode == 4:
		moving = true
		visible = true
		sprite.animation = color + "_Fork"
	elif new_mode == 5:
		moving = false
		visible = false
	elif new_mode == 6:
		moving = false
		visible = true
		sprite.animation = color + "_Dead"
		deadtimer.start()
		emit_signal("death")
		set_process(false)
	elif new_mode == 7:
		moving = false
		visible = true
		sprite.animation = color + "_Torch"
		$Fire.visible = true
	if not is_day:
		if new_mode in [1]:
			emit_signal("scared")
		if new_mode in [0, 4, 5]:
			#emit_signal("calm")
			pass

func set_color(new_color : String):
	if valid_colors.find(new_color) != -1:
		color = new_color
		speed = speeds[int(valid_colors.find(new_color)/2)]

func on_calm():
	change_mode(0)
	
func on_scared():
	change_mode(4)

func _on_DeadTimer_timeout():
	queue_free()

func _on_RunTimer_timeout():
	change_mode(3)

func _on_PathTimer_timeout():
	get_new_goal()

func on_villager_death():
	change_mode(6)

func _on_DeathZone_body_entered(body):
	if body.is_in_group("Night_Player") and mode != 5 and mode != 6:
		if mode == 7:
			change_mode(1)
			emit_signal("hit_player")
			$Hit.play()
		else:
			if !body.on_cooldown:
				body.kill()
				change_mode(6)
				$Death.play()
	if body.is_in_group("Day_Player") and mode == 4:
		change_mode(0)
		emit_signal("hit_player")
		$Hit.play()
