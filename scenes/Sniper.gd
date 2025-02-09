extends Node2D

@export var angular_speed: float
@export var speed_slowing: float
var target
var state: SniperState = SniperState.AIMING

enum SniperState { AIMING, READY_TO_FIRE }

# Called when the node enters the scene tree for the first time.
func _ready():
	var target = Global.player
	get_node("ReadySound").play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if (angular_speed > 0.005):
		angular_speed -= speed_slowing
	if (!target):
		target = Global.player
	if (state == SniperState.AIMING):
		_process_ray_cast(delta)
	if (target):
		var target_vector = (target.global_position - global_position).normalized()
		var current_angle = rotation
		var current_vector = Vector2.from_angle(current_angle).normalized()
		var product = target_vector.x * current_vector.y - target_vector.y * current_vector.x
		if (product > 0):
			current_angle -= angular_speed
		elif (product < 0):
			current_angle += angular_speed
		rotation = current_angle
		
func _process_ray_cast(delta):
	var ray:RayCast2D = get_node("RayCast2D")
	if (ray.is_colliding() && ray.get_collider()):
		state = SniperState.READY_TO_FIRE
		get_node("Line2D").default_color = Color.SKY_BLUE
		get_node("ShootingTimer").start()
		pass


func _on_shooting_timer_timeout():
	var ray:RayCast2D = get_node("RayCast2D")
	EventBus.emit_signal("play_stream", preload("res://audio/sniper/sniper_shoot.wav"))
	if (ray.is_colliding() && ray.get_collider() && ray.get_collider().owner is Player):
		target.lose_life()
		if (target.current_state == Player.State.DEAD):
			EventBus.emit_signal("play_character_sound", AudioManager.Character.SNIPER, AudioManager.CharacterSoundType.WIN)
	else:
		EventBus.emit_signal("play_character_sound", AudioManager.Character.SNIPER, AudioManager.CharacterSoundType.FAIL)
	queue_free()
	pass # Replace with function body.
