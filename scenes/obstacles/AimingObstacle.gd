extends Area2D

@export var velocity: float
@export var acceleration: float
@export var angular_speed: float
@export var direction: Vector2
@export var state: RocketState
var target

enum RocketState { FLYING, EXPLODING }

# Called when the node enters the scene tree for the first time.
func _ready():
	target = Global.player
	EventBus.emit_signal("play_stream", preload("res://audio/soldier/rocket_blackbox_shoot.wav"))
	EventBus.emit_signal("play_character_sound", AudioManager.Character.SOLDIER, AudioManager.CharacterSoundType.CRY)
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
	if (state != RocketState.EXPLODING):
		$Sprite2D.set_visible(false)
		$ExplosionParticles.emitting = true
		state = RocketState.EXPLODING
	pass # Replace with function body.


func _on_body_entered(body):
	if (state != RocketState.EXPLODING):
		$Sprite2D.set_visible(false)
		$ExplosionParticles.emitting = true
		state = RocketState.EXPLODING
	pass # Replace with function body.


func _on_explosion_particles_finished():
	queue_free()
	pass # Replace with function body.
