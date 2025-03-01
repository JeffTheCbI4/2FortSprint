extends Node2D


@export var speed:float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2(-1, 0)
	global_position = global_position + direction * speed * delta
	pass

func _on_screen_exited():
	queue_free()
	pass # Replace with function body.


func _on_area_2d_area_entered(area):
	area.owner.get_life()
	queue_free()
	pass # Replace with function body.
