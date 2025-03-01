extends Area2D

@export var speed:float
var isExploding = false

var demoman_winning = [
	preload("res://audio/demoman/laughevil01.mp3"),
	preload("res://audio/demoman/laughlong02.mp3"),
	preload("res://audio/demoman/oh i need a drink.wav"),
	preload("res://audio/demoman/Demoman_specialcompleted10.wav")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var random_degree = randi_range(0, 360)
	set_rotation_degrees(random_degree)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2(-1, 0)
	global_position = global_position + direction * speed * delta
	pass
	

func _on_screen_exited():
	queue_free()
	pass # Replace with function body.


func _on_area_entered(area):
	$ExplosionParticles.set_emitting(true)
	$ExplosionParticles2.set_emitting(true)
	$ExplosionParticles3.set_emitting(true)
	$DetonateSound.play()
	$ExplosionSound.play()
	collision_layer = 0
	$Sprite2D.visible = false
	if (area.owner is Player && area.owner.life_state == Player.LifeState.DEAD):
		EventBus.emit_signal("play_stream", demoman_winning.pick_random())
	pass # Replace with function body.
