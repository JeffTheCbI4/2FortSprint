extends Area2D

@export var direction: Vector2
@export var speed: float

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = direction.normalized().angle()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	global_position += direction * speed * delta


func _on_screen_exited():
	queue_free()
	pass # Replace with function body.


func _on_body_entered(body):
	queue_free()
	pass # Replace with function body.
