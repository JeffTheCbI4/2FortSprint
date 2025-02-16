extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("player_life_changed", on_player_life_changed)
	#get_node("Sprite2D").texture.region = Rect2(0,0,100,100)
	pass # Replace with function body.

func on_player_life_changed(current_life):
	#var pixel = (3 - current_life) * 100
	#get_node("Sprite2D").texture.region = Rect2(pixel,pixel,100,100)
	$Sprite2D.frame = 3 - current_life

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
