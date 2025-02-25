extends Area2D

@export var velocity: float
@export var acceleration: float
@export var angular_speed: float
@export var direction: Vector2
@export var state: RocketState
var target

var explode_sounds = [
	preload("res://audio/explode1.wav"),
	preload("res://audio/explode2.wav"),
	preload("res://audio/explode3.wav")
]

var soldier_cries = [
	preload("res://audio/soldier/soldier_battlecry01.mp3"),
	preload("res://audio/soldier/soldier_if_you_know.wav"),
	preload("res://audio/soldier/soldier_screaming_eagles.mp3"),
	preload("res://audio/soldier/soldier_battlecry05.mp3")
]

var soldier_winning = [
	preload("res://audio/soldier/soldier_laughevil02.mp3"),
	preload("res://audio/soldier/soldier_laughhappy03.mp3"),
	preload("res://audio/soldier/laughlong03.mp3"),
	preload("res://audio/soldier/taunts17.mp3"),
	preload("res://audio/soldier/taunts18.mp3")
]

enum RocketState { FLYING, EXPLODING }

# Called when the node enters the scene tree for the first time.
func _ready():
	target = Global.player
	EventBus.emit_signal("play_stream", preload("res://audio/soldier/rocket_blackbox_shoot.wav"))
	EventBus.emit_signal("play_character_sound", soldier_cries.pick_random())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if (state != RocketState.EXPLODING):
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
	_explode()


func _on_body_entered(body):
	_explode()

func _explode():
	if (state != RocketState.EXPLODING):
		$Sprite2D.set_visible(false)
		$ExplosionParticles.emitting = true
		collision_layer = 0
		state = RocketState.EXPLODING
		$ExplosionSound.play()
		if (target is Player && target.life_state == Player.LifeState.DEAD):
			EventBus.emit_signal("play_stream", soldier_winning.pick_random())
			pass
	pass # Replace with function body.
	

func _on_explosion_particles_finished():
	queue_free()
	pass # Replace with function body.
