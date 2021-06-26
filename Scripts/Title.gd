extends Scene

func set_volume(state):
	if state == 0:
		Globals.set_volume(0)
	elif state == 1:
		Globals.set_volume(0.5)
	elif state == 2:
		Globals.set_volume(1)
func set_music(state):
	if state == 0:
		Globals.set_music(true)
	else:
		Globals.set_music(false)
func set_device(state):
	if state == 0:
		Globals.set_mobile(false)
	else:
		Globals.set_mobile(true)
