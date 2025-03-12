extends Node2D

@export var background_speed: float
@export var is_running: bool
@export var bg_index: int
var is_switching = false
var bg_array = [
	[
		preload("res://art/background_red1.png"),
		preload("res://art/background_red2.png")
	],
	[
		preload("res://art/background_bridge.png")
	],
	[
		preload("res://art/background_blue.png")
	]
]

var bg_switches = [
	preload("res://art/red_bridge_bg_switch.png"),
	preload("res://art/blue_bridge_bg_switch.png")
]


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("player_body_fell", player_body_fell)
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
	var texture = null
	if (is_switching):
		texture = bg_switches[bg_index]
		bg_index += 1
		is_switching = false
	else:
		texture = bg_array[bg_index].pick_random()
	new_background.set_sprite(texture)
	add_child(new_background)
	new_background.global_position = background.global_position + Vector2(1280, 0)
	pass # Replace with function body.

func player_body_fell():
	is_running = false
	pass
	
func switch_next():
	is_switching = true
	pass
