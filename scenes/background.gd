extends Node2D

signal background_entered_screen(background)

# Called when the node enters the scene tree for the first time.
func _ready():
	#var bg_names = $Sprite2D.get_sprite_frames().get_animation_names()
	#var randomi = randi_range(0, bg_names.size() - 1) 
	#$Sprite2D.animation = bg_names[randomi]
	pass # Replace with function body.

func set_sprite(texture):
	$Sprite2D.set_texture(texture)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_entered():
	emit_signal("background_entered_screen", self)
	pass # Replace with function body.
