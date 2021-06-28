extends Sprite

signal pickup(type)

var type = 0 setget set_type

func set_type(_type):
	if _type <= 3 and _type >= 0: 
		frame = type
		type = _type

func _on_Area2D_body_entered(body):
	if body.is_in_group("Night_Player") or body.is_in_group("Day_Player"):
		emit_signal("pickup", type)
		queue_free()
