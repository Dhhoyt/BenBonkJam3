extends KinematicBody2D

export (int) var speed = 200
export (int) var waterSpeed = 75

var velocity = Vector2()
var inWater = false
var night = true

onready var tileMap = $"../Village/Navigation2D/TileMap"

func _ready():
	$Timer.connect("timeout", $Timer, "start")
	$Timer.connect("timeout", $Walk, "play")
	$WerewolfRunning.animation = str(Globals.wolf_skin)
	$HumanRunning.animation = str(Globals.human_skin)
func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * (waterSpeed if inWater else speed)

func _physics_process(delta):
	inWater = tileMap.get_cellv(tileMap.world_to_map(position)) == 0 or tileMap.get_cellv(tileMap.world_to_map(position)) == 2
	get_input()
	velocity = move_and_slide(velocity)

func _process(delta):
	$WerewolfRunning.visible = night
	$HumanRunning.visible = !night
	$WerewolfRunning.playing = velocity.length_squared() > 1
	$HumanRunning.playing = velocity.length_squared() > 1
	if velocity.length_squared() > 1:
		$WerewolfRunning.flip_h = velocity.x > 0 or velocity.y > 0
		if !$Timer.is_connected("timeout", $Walk, "play"):
			$Timer.connect("timeout", $Walk, "play")
	else:
		$WerewolfRunning.frame = 0
		if $Timer.is_connected("timeout", $Walk, "play"):
			$Timer.disconnect("timeout", $Walk, "play")
