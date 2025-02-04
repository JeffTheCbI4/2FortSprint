extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("player_lost_life", on_player_lost_life)
	get_node("Sprite2D").texture.region = Rect2(0,0,100,100)
	pass # Replace with function body.

func on_player_lost_life(current_life):
	var pixel = (3 - current_life) * 100
	get_node("Sprite2D").texture.region = Rect2(pixel,pixel,100,100)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
