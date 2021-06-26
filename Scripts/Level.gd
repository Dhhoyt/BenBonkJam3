extends Scene

var playerHealth = 3
var villagersLeft = 0

func _ready():
	randomize()
	generate()
	for player in get_tree().get_nodes_in_group("Player"):
		player.connect("hit", self, "on_player_hit")
	for villager in get_tree().get_nodes_in_group("Villagers"):
		villager.connect("death", self, "on_villager_death")
func generate():
	print(Globals.level)
	#var houseLocations = []
	var daymap = $HBoxContainer/Day/Viewport/Day/Village/Navigation2D/TileMap
	var nightmap = $HBoxContainer/Night/Viewport/Night/Village/Navigation2D/TileMap
	
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.period = 20.0
	noise.persistence = 0.8
	for x in range(0, 12):
		for y in range(0, 16):
			var rand = randi()%7
			var grassnum = 0 if rand < 5 else 1 if rand < 6 else 2
			#if noise.get_noise_2d(round(x/2)*2, round(y/2)*2) < 0:
			#	daymap.set_cell(x, y, 0)
			#	nightmap.set_cell(x, y, 0)
			#else:
			daymap.set_cell(x, y, 1, false, false, false, Vector2(0, grassnum))
			nightmap.set_cell(x, y, 1, false, false, false, Vector2(0, grassnum))
	daymap.update_bitmask_region(Vector2(0, 0), Vector2(13, 15))
	nightmap.update_bitmask_region(Vector2(0, 0), Vector2(13, 15))
func on_player_hit():
	playerHealth -= 1
	if playerHealth <= 0:
		change_scene("res://Scenes/Title.tscn")
func on_villager_death():
	villagersLeft -= 1
	if villagersLeft <= 0:
		Globals.level += 1
		change_scene("res://Scenes/Split.tscn")
