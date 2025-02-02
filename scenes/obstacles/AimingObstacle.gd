extends Area2D

@export var velocity: float
@export var acceleration: float
@export var angular_speed: float
@export var direction: Vector2
var target


# Called when the node enters the scene tree for the first time.
func _ready():
	target = Global.player
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	_calculate_angle()
	global_position -= direction * velocity * delta
	rotation = direction.normalized().angle()
	_accelerate()

func _accelerate():
	velocity += acceleration

func _calculate_angle():
	if (target):
		var angle = (global_position - target.global_position).angle()
		var current_angle = direction.normalized().angle()
		if (angle > current_angle):
			current_angle += angular_speed
		elif (angle < current_angle):
			current_angle -= angular_speed
		direction = Vector2.from_angle(current_angle)


func _on_screen_exited():
	queue_free()
	pass # Replace with function body.


func _on_area_entered(area):
	queue_free()
	pass # Replace with function body.


func _on_body_entered(body):
	queue_free()
	pass # Replace with function body.
