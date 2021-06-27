extends Scene
func _ready():
	$CanvasLayer/Panel/Label.text = "Score:"+str(Globals.score)+" High:"+str(Globals.highscore)
	$CanvasLayer/Panel/VolumeButton.state = 0 if Globals.volume_percent == 0 else (1 if Globals.volume_percent == 0.75 else 2)
	$CanvasLayer/Panel/MusicButton.state = 0 if Globals.music else 1
	$CanvasLayer/Panel/DeviceButton.state = 1 if Globals.mobile else 0
func set_volume(state):
	if state == 0:
		Globals.set_volume(0)
	elif state == 1:
		Globals.set_volume(0.75)
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
