extends Node2D

@export var progress_speed: float
@export var possible_obstacles: Array
@export var initial_progress_ratio: float

@export var obsctacle_cooldown: float;

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("GenerationTimer").wait_time = obsctacle_cooldown
	$Path2D/PathFollow2D.set_progress_ratio(initial_progress_ratio)
	EventBus.connect("player_died", _on_player_died)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_progress(delta)
	pass

func _get_current_path_position():
	return get_node("Path2D/PathFollow2D").position + get_node("Path2D").position
	
func _progress(delta):
	var pathFollow = get_node("Path2D/PathFollow2D")
	var newProgress = pathFollow.progress + progress_speed * delta
	pathFollow.set_progress(newProgress)
	
func _generate_obstacle():
	var obstacle = _get_random_obstacle().instantiate()
	add_child(obstacle)
	obstacle.position = _get_current_path_position()

func _get_random_obstacle():
	var random_index = 0
	random_index = randi_range(0, possible_obstacles.size() - 1)
	return possible_obstacles[random_index]

func _on_generation_timer_timeout():
	_generate_obstacle()
	pass # Replace with function body.
	
func _on_player_died():
	$GenerationTimer.stop()
