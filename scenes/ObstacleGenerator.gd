extends Node2D

@export var progress_speed: float
@export var possible_obstacles: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_progress()
	var randomNum = randi_range(0,100)
	if (randomNum > 99):
		_generate_obstacle()
	pass

func _get_current_path_position():
	return get_node("Path2D/PathFollow2D").position + get_node("Path2D").position
	
func _progress():
	var pathFollow = get_node("Path2D/PathFollow2D")
	var newProgress = pathFollow.progress + progress_speed
	pathFollow.set_progress(newProgress)
	
func _generate_obstacle():
	var obstacle = _get_random_obstacle().instantiate()
	add_child(obstacle)
	obstacle.position = _get_current_path_position()

func _get_random_obstacle():
	var random_index = randi_range(0, possible_obstacles.size() - 1)
	return possible_obstacles[random_index]
