extends Node2D

@export var background_speed: float
@export var is_running: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (is_running):
		for child in get_children():
			child.global_position += Vector2(-1, 0) * background_speed * delta
	pass
	

func _on_background_entered_screen(background):
	var new_background = preload("res://scenes/background.tscn").instantiate()
	new_background.connect("background_entered_screen", _on_background_entered_screen)
	add_child(new_background)
	new_background.global_position = background.global_position + Vector2(1280, 0)
	
	pass # Replace with function body.
