extends Node
var volume_percent = 1
var music = true
var mobile = false
var level = 1
var highscore = 0

var config_file
const CONFIG_FILEPATH = "user://highscores.cfg"

func _ready():
	config_file = ConfigFile.new()
	load_player_data()
func set_volume(v):
	volume_percent = v
	var audioPlayers = get_tree().get_nodes_in_group("Sound")
	for audioPlayer in audioPlayers:
		audioPlayer.volume_db = volume_percent*10 if volume_percent > 0 else 80
func set_music(m):
	music = m
	var musicPlayers = get_tree().get_nodes_in_group("Music")
	for musicPlayer in musicPlayers:
		musicPlayer.playing = m
func set_mobile(m):
	mobile = m

func save_player_data(new_score):
	# Open the config file
	config_file.load(CONFIG_FILEPATH)
	# Get the current highscore, if it exists
	highscore = config_file.get_value("player_data", "highscore", -INF)
	# see if the new score is better and if it is, save it!
	if new_score >= highscore:
		config_file.set_value("player_data", "highscore", new_score)
	config_file.save(CONFIG_FILEPATH)
func load_player_data():
	config_file.load(CONFIG_FILEPATH)
	highscore = config_file.get_value("player_data", "highscore", -INF)
