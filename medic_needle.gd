extends Node2D
class_name MedicNeedle

@export var speed: float
var _target
var _isActive: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func params(target):
	_target = target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (_isActive):
		var angle = global_position.angle_to_point(_target.global_position)
		rotation = angle
		var direction = Vector2.from_angle(global_position.angle_to_point(_target.global_position))
		global_position += direction.normalized() * speed * delta
		pass



func _on_hitbox_area_entered(area):
	if (area.owner is Player && _isActive):
		call_deferred("after_colliding", area)
		
	pass # Replace with function body.

func after_colliding(area):
	_isActive = false 
	reparent(area.owner)
	area.owner.add_child(self)
	$Hitbox.collision_layer = 0
	$Hitbox.collision_mask = 0
	$DisappearTimer.start()

func _on_disappear_timer_timeout():
	queue_free()
	pass # Replace with function body.
