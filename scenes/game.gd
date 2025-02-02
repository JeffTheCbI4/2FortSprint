extends Node

@export var initial_scene: PackedScene
var current_scene_instance
@export var scenes_list: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	current_scene_instance = initial_scene.instantiate()
	add_child(current_scene_instance)
	EventBus.connect("set_game_scene", set_game_scene)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_game_scene(scene_name):
	current_scene_instance.queue_free()
	var new_scene_instance = scenes_list[scene_name].instantiate()
	current_scene_instance = new_scene_instance
	add_child(current_scene_instance)
