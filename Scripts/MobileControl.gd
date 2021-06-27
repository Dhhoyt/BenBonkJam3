extends Sprite

var screenTouchPosition

func _process(delta):
	visible = Globals.mobile
	if Globals.mobile:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			$FingerPoint.position = get_global_mouse_position() - position
			if $FingerPoint.position.length_squared() > 32*32:
				$FingerPoint.position = $FingerPoint.position.normalized()*32
		elif screenTouchPosition != null:
			$FingerPoint.position = screenTouchPosition - position
			if $FingerPoint.position.length_squared() > 32*32:
				$FingerPoint.position = $FingerPoint.position.normalized()*32
		else:
			$FingerPoint.position = Vector2(0, 0)
		if $FingerPoint.position.y < -16:
			Input.action_press("ui_up")
		else:
			Input.action_release("ui_up")
		if $FingerPoint.position.y > 16:
			Input.action_press("ui_down")
		else:
			Input.action_release("ui_down")
		if $FingerPoint.position.x < -16:
			Input.action_press("ui_left")
		else:
			Input.action_release("ui_left")
		if $FingerPoint.position.x > 16:
			Input.action_press("ui_right")
		else:
			Input.action_release("ui_right")

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			screenTouchPosition = event.position
		else:
			screenTouchPosition = null
	elif event is InputEventScreenDrag:
		screenTouchPosition = event.position
