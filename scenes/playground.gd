extends Node

@export var is_incrementing_score: bool

const SCORE = "Score"
const HIGH_SCORE = "HighScore"
var last_bg_score_switch = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("medic_used", _on_player_medic_used)
	var file = FileAccess.open("user://highscore", FileAccess.READ)
	if (file):
		var highscore = file.get_var()
		_set_highscore(highscore)
		file.close()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_process_player_input()
	_increment_score(delta)
	_process_bg()
	pass

func _increment_score(delta):
	if (is_incrementing_score):
		var interface = get_node("GameInterface")
		var score = int(interface.get_value(SCORE))
		var new_score = int(score + 100 * delta)
		interface.set_value(SCORE, str(new_score))

func _process_bg():
	var score = int($GameInterface.get_value(SCORE))
	if (score > 500 && last_bg_score_switch < 500):
		$BackgroundGenerator.switch_next()
		last_bg_score_switch = score
	elif (score > 1000 && last_bg_score_switch < 1000):
		$BackgroundGenerator.switch_next()
		last_bg_score_switch = score

func _on_player_player_died():
	is_incrementing_score = false
	var score = _get_score()
	var highscore = int(_get_highscore())
	if (score > highscore):
		_set_highscore(score)
		var file = FileAccess.open("user://highscore", FileAccess.WRITE)
		file.store_var(score)
		file.close()
	EventBus.emit_signal("player_died")
	pass # Replace with function body.

func _process_player_input():
	var r_pressed = Input.is_key_pressed(KEY_R)
	if (r_pressed):
		EventBus.emit_signal("set_game_scene", "playground")
		
func _get_score():
	var interface = _get_interface()
	return int(interface.get_value(SCORE))
	
func _get_highscore():
	var interface = _get_interface()
	return int(interface.get_value(HIGH_SCORE))
	
func _set_score(score):
	var interface = _get_interface()
	interface.set_value(SCORE, str(score))
	
func _set_highscore(score):
	var interface = _get_interface()
	interface.set_value(HIGH_SCORE, str(score))
	
func _get_interface():
	return get_node("GameInterface")

func _on_music_finished():
	$Music.play()
	pass # Replace with function body.


func _on_player_medic_used():
	var medic_needle = preload("res://medic_needle.tscn").instantiate()
	medic_needle.params($Player)
	add_child(medic_needle)
	medic_needle.global_position = Vector2(-200, 360)
	pass # Replace with function body.
