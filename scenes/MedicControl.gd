extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("medic_used", _turn_off)
	EventBus.connect("medic_available", _turn_on)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ($Timer.visible):
		$Timer.text = str(Global.medic_call_left_time)
	pass

func _turn_off():
	$Sprite2D.frame = 1
	$Timer.visible = true
	
func _turn_on():
	$Sprite2D.frame = 0
	$Timer.visible = false
