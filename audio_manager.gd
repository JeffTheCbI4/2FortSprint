extends Node2D
class_name AudioManager

var characters_can_speak = true
@export var audio_dict: Dictionary
	
@export var characters_sounds: Dictionary
	
enum Character { SNIPER, SOLDIER }
enum CharacterSoundType { WIN, FAIL, CRY }

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("play_character_sound", play_character_sound)
	EventBus.connect("play_sound", play_sound)
	EventBus.connect("play_stream", play_stream)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_character_sound(stream):
	if (characters_can_speak):
		characters_can_speak = false
		get_node("CharacterAudioCooldown").start()
		play_stream(stream)
	pass
	
func play_sound(name):
	var stream = audio_dict.get(name)
	for i in range(1,6):
		var player = get_node(str("Player",i))
		if (player && !player.playing):
			player.stream = stream
			player.play()
			break
	pass
	
func play_stream(stream):
	for i in range(1,6):
		var player = get_node(str("Player",i))
		if (player && !player.playing):
			player.stream = stream
			player.play()
			break
	pass


func _on_character_audio_cooldown_timeout():
	characters_can_speak = true
	pass # Replace with function body.
