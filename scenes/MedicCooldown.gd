extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!is_stopped()):
		Global.medic_call_left_time = time_left
	pass


func _on_timeout():
	EventBus.emit_signal("medic_available")
	pass # Replace with function body.
