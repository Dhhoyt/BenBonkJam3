extends Scene

var playerHealth = 3
var villagersLeft = 0

const HOUSE = preload("res://Objects/House.tscn")
const VILLAGER = preload("res://Objects/Villager.tscn")

func _ready():
	randomize()
	generate()
	for player in get_tree().get_nodes_in_group("Player"):
		player.connect("hit", self, "on_player_hit")
	#for villager in get_tree().get_nodes_in_group("Villagers"):
	#	villager.connect("death", self, "on_villager_death")
func generate():
	var possibleHousePositions = [Vector2(32, 32), Vector2(32+128, 32), Vector2(32, 32+64), Vector2(32+128, 32+64), Vector2(32, 32+64*2), Vector2(32+128, 32+64*2), Vector2(32, 32+64*3), Vector2(32+128, 32+64*3)]
	for i in range(min(Globals.level+randi()%2, 8)):
		var pos = possibleHousePositions[randi()%len(possibleHousePositions)]
		possibleHousePositions.erase(pos)
		
		var newHouse = HOUSE.instance()
		$HBoxContainer/Day/Viewport/Day/Houses.add_child(newHouse)
		newHouse.position = pos
		newHouse.update_color(newHouse.valid_colors[i])
		
		newHouse = HOUSE.instance()
		$HBoxContainer/Night/Viewport/Night/Houses.add_child(newHouse)
		newHouse.position = pos
		newHouse.update_color(newHouse.valid_colors[i])
		
		var newVillager = VILLAGER.instance()
		$HBoxContainer/Day/Viewport/Day/Villagers.add_child(newVillager)
		newVillager.set_color(newVillager.valid_colors[i])
		newVillager.position = pos
		newVillager.mode = 5
		#newVillager.connect("death", self, "on_villager_death")
		
		newVillager = VILLAGER.instance()
		$HBoxContainer/Night/Viewport/Night/Villagers.add_child(newVillager)
		newVillager.set_color(newVillager.valid_colors[i])
		newVillager.position = pos
		newVillager.mode = 5
		#newVillager.connect("death", self, "on_villager_death")
	
	var daymap = $HBoxContainer/Day/Viewport/Day/Village/Navigation2D/TileMap
	var nightmap = $HBoxContainer/Night/Viewport/Night/Village/Navigation2D/TileMap
	
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.period = 0.2
	noise.persistence = 0.2
	for x in range(-1, 13):
		for y in range(0, 17):
			var rand = randi()%7
			var grassnum = 0 if rand < 5 else 1 if rand < 6 else 2
			if noise.get_noise_2d(round(x/2)*2, round(y/2)*2) < (float(Globals.level)/5)-1:
				daymap.set_cell(x, y, 0)
				nightmap.set_cell(x, y, 2)
			else:
				daymap.set_cell(x, y, 1, false, false, false, Vector2(0, grassnum))
				nightmap.set_cell(x, y, 3, false, false, false, Vector2(0, grassnum))
	daymap.update_bitmask_region(Vector2(0, 0), Vector2(13, 15))
	nightmap.update_bitmask_region(Vector2(0, 0), Vector2(13, 15))
	
	$HBoxContainer/Day/Viewport/Day/Werewolf.position = Vector2(382/4, 256/2)
	$HBoxContainer/Night/Viewport/Night/Werewolf.position = Vector2(382/4, 256/2)
func on_player_hit():
	playerHealth -= 1
	if playerHealth <= 0:
		change_scene("res://Scenes/Title.tscn")
func on_villager_death():
	villagersLeft -= 1
	if villagersLeft <= 0:
		Globals.level += 1
		change_scene("res://Scenes/Split.tscn")
