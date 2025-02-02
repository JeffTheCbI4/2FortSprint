extends Area2D

@export var speed:float

# Called when the node enters the scene tree for the first time.
func _ready():
	var random_degree = randi_range(0, 360)
	set_rotation_degrees(random_degree)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var direction = Vector2(-1, 0)
	global_position = global_position + direction * speed * delta

func _on_screen_exited():
	queue_free()
	pass # Replace with function body.
