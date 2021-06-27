extends Node
var volume_percent = 1
var music = true
var mobile = false
var level = 0
var score = 0
var highscore = 0
var playerHealth = 3

var config_file
const CONFIG_FILEPATH = "user://highscores.cfg"

func _ready():
	config_file = ConfigFile.new()
	load_player_data()
func _process(delta):
	var audioPlayers = get_tree().get_nodes_in_group("Sound")
	for audioPlayer in audioPlayers:
		audioPlayer.volume_db = volume_percent*80-80
	var musicPlayers = get_tree().get_nodes_in_group("Music")
	for musicPlayer in musicPlayers:
		musicPlayer.playing = music
func set_volume(v):
	volume_percent = v
func set_music(m):
	music = m
func set_mobile(m):
	mobile = m
func reset():
	level = 0
	score = 0
	playerHealth = 3

func save_player_data(new_score):
	# Open the config file
	config_file.load(CONFIG_FILEPATH)
	# Get the current highscore, if it exists
	highscore = config_file.get_value("player_data", "highscore", 0)
	# see if the new score is better and if it is, save it!
	if new_score >= highscore:
		config_file.set_value("player_data", "highscore", new_score)
	config_file.save(CONFIG_FILEPATH)
func load_player_data():
	config_file.load(CONFIG_FILEPATH)
	highscore = config_file.get_value("player_data", "highscore", 0)
