extends KinematicBody2D

export (int) var speed = 200
export (int) var waterSpeed = 75

var velocity = Vector2()
var inWater = false

onready var tileMap = $"../Village/Navigation2D/TileMap"

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
	inWater = tileMap.get_cellv(tileMap.world_to_map(position)) == 0
	get_input()
	velocity = move_and_slide(velocity)
