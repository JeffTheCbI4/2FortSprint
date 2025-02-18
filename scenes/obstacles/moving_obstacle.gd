extends Path2D

@export var progress_speed: float
@export var moving_speed:float
var impact_sounds = [
	preload("res://audio/saw/sawblade_impact1.wav"),
	preload("res://audio/saw/sawblade_impact2.wav")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$PathFollow2D/Area2D/AnimationSprite2D.play()
	$PathFollow2D/Area2D/SawSpinning.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_progress(delta)
	pass
	
func _progress(delta):
	var pathFollow = get_node("PathFollow2D")
	var newProgress = pathFollow.progress + progress_speed * delta
	pathFollow.set_progress(newProgress)
	
func _physics_process(delta):
	var direction = Vector2(-1, 0)
	global_position = global_position + direction * moving_speed * delta


func on_screen_exited():
	queue_free()
	pass # Replace with function body.


func _on_saw_spinning_finished():
	$PathFollow2D/Area2D/SawSpinning.play()
	pass # Replace with function body.


func _on_area_2d_area_entered(area):
	if (area.owner is Player):
		EventBus.emit_signal("play_stream", impact_sounds.pick_random())
	pass # Replace with function body.
