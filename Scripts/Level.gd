extends Scene

var villagersLeft = 0

const HOUSE = preload("res://Objects/House.tscn")
const VILLAGER = preload("res://Objects/Villager.tscn")
const LIFE = preload("res://Art/life.png")

func _ready():
	randomize()
	generate()
	update_health()
	#for player in get_tree().get_nodes_in_group("Player"):
		#player.connect("hit", self, "on_player_hit")
	#for villager in get_tree().get_nodes_in_group("Villagers"):
	#	villager.connect("death", self, "on_villager_death")
func generate():
	var possibleHousePositions = [Vector2(32, 32), Vector2(32+128, 32), Vector2(32, 32+64), Vector2(32+128, 32+64), Vector2(32, 32+64*2), Vector2(32+128, 32+64*2), Vector2(32+64, 32+64*2), Vector2(32+128, 32+64*3)]
	villagersLeft = 0
	for i in range(min(int(Globals.level/2)+randi()%2+2, 8)):
		villagersLeft += 1
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
		
		var newVillager_day = VILLAGER.instance()
		$HBoxContainer/Day/Viewport/Day/Villagers.add_child(newVillager_day)
		newVillager_day.set_color(newVillager_day.valid_colors[i])
		newVillager_day.position = pos
		newVillager_day.mode = 5
		newVillager_day.is_day = true
		newVillager_day.connect("hit_player", self, "on_player_hit")
		
		var newVillager_night = VILLAGER.instance()
		$HBoxContainer/Night/Viewport/Night/Villagers.add_child(newVillager_night)
		newVillager_night.set_color(newVillager_night.valid_colors[i])
		newVillager_night.position = pos
		newVillager_night.mode = 5
		newVillager_night.connect("death", self, "on_villager_death")
		newVillager_night.connect("death", newVillager_day, "on_villager_death")
		newVillager_night.connect("scared", newVillager_day, "on_scared")
		newVillager_night.connect("calm", newVillager_day, "on_calm")
	
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
	$HBoxContainer/Day/Viewport/Day/Werewolf.night = false
	$HBoxContainer/Night/Viewport/Night/Werewolf.position = Vector2(382/4, 256/2)
func on_player_hit():
	$HBoxContainer/Day/Viewport/Camera2D.shake(0.2, 15, 8)
	Globals.playerHealth -= 1
	if Globals.playerHealth <= 0:
		change_scene("res://Scenes/Title.tscn")
		Globals.save_player_data(Globals.score)
	else:
		update_health()
func on_villager_death():
	#print(villagersLeft)
	$HBoxContainer/Night/Viewport/Camera2D.shake(0.2, 15, 8)
	villagersLeft -= 1
	if villagersLeft <= 0:
		Globals.level += 1
		Globals.score += 1
		$LevelComplete.play()
		change_scene("res://Scenes/Split.tscn")
func update_health():
	if $LifeCount.get_child_count() < Globals.playerHealth:
		for i in range(Globals.playerHealth):
			var newHeart = TextureRect.new()
			newHeart.texture = LIFE
			$LifeCount.add_child(newHeart)
	else:
		while $LifeCount.get_child_count() > Globals.playerHealth:
			$LifeCount.get_children()[0].queue_free()
			$LifeCount.remove_child($LifeCount.get_children()[0])
