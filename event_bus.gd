extends Node

signal player_died
signal set_game_scene(scene_name)
signal player_life_changed(current_life)
signal play_character_sound(stream)
signal play_sound(sound_name)
signal play_stream(stream)
signal medic_used()
signal medic_available()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
