extends CharacterBody2D
class_name Player

@export var max_life: int
@export var life: int
@export var jump_force: float
@export var topMaxPoint: float
@export var bottomMaxPoint: float
@export var gravity_force: float
@export var falling_velocity: float
@export var max_velocity: float
@export var min_velocity: float
@export var current_state: State
@export var health_state: HealthState
@export var life_state: LifeState
signal player_died
signal medic_used

var bullet_scene = preload("res://scenes/bullet.tscn")
var medic_calls = [
	preload("res://audio/scout/medic01.mp3"),
	preload("res://audio/scout/medic02.mp3"),
	preload("res://audio/scout/medic03.mp3")
]
var hurt_sfx = [
	preload("res://audio/scout/hurt/painsharp01.mp3"),
	preload("res://audio/scout/hurt/painsharp02.mp3"),
	preload("res://audio/scout/hurt/painsharp03.mp3"),
	preload("res://audio/scout/hurt/painsharp04.mp3"),
	preload("res://audio/scout/hurt/painsharp05.mp3"),
	preload("res://audio/scout/hurt/painsharp06.mp3"),
	preload("res://audio/scout/hurt/painsharp07.mp3"),
	preload("res://audio/scout/hurt/painsharp08.mp3"),
]
var death_sfx = [
	preload("res://audio/scout/death/paincrticialdeath01.mp3"),
	preload("res://audio/scout/death/paincrticialdeath01.mp3"),
	preload("res://audio/scout/death/paincrticialdeath01.mp3")
]
var healing_sound = preload("res://audio/health_pickup.wav")

enum State { ON_FLOOR, FLYING }
enum LifeState { ALIVE, DEAD }
enum HealthState { INVINCIBLE, VULNERABLE }

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player = self
	get_node("AnimatedSprite2D").play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
	
func _physics_process(delta):
	if (life_state != LifeState.DEAD):
		_process_player_input(delta)
	if (current_state != State.ON_FLOOR):
		set_falling_velocity(falling_velocity + gravity_force)
		var collision = move_and_collide(Vector2(0, falling_velocity) * delta)
		if (collision && collision.get_angle() == 0):
			if (life_state != LifeState.DEAD):
				get_node("BulletsCooldown").stop()
				$Shooting.stop()
				_set_animation("running")
			elif (life_state == LifeState.DEAD && current_state != State.ON_FLOOR):
				_set_animation("dead")
				$BodyFell.play()
			current_state = State.ON_FLOOR
	pass

func generate_bullets():
	var first = generate_bullet(Vector2 (-25, 60), -260 + randf_range(-20, 20))
	var second = generate_bullet(Vector2 (0, 60), -270 + randf_range(-20, 20))
	var third = generate_bullet(Vector2 (25, 60), -280 + randf_range(-20, 20))

func generate_bullet(relational_position, directon_degree):
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position + relational_position
	bullet.direction = Vector2.from_angle(deg_to_rad(directon_degree))
	add_sibling(bullet)

func _process_player_input(delta):
	var spacePressed = Input.is_key_pressed(KEY_SPACE)
	if (spacePressed):
		set_falling_velocity(falling_velocity - jump_force)
		if (current_state == State.ON_FLOOR):
			current_state = State.FLYING
			_set_animation("mid_air")
		if get_node("BulletsCooldown").is_stopped():
			get_node("BulletsCooldown").start()
			$Shooting.play()
	else:
		get_node("BulletsCooldown").stop()
		$Shooting.stop()

	#if (collidedBody):
		#falling_velocity = 0
	pass

func _input(event):
	if (event.is_action_pressed("ui_medic_call")):
		_call_medic()
	pass
	
func _call_medic():
	if (life_state != LifeState.DEAD):
		var stream = medic_calls.pick_random()
		var scout_voice_player = get_node("ScoutVoice")
		scout_voice_player.stream = stream
		scout_voice_player.play()
		var modulate = get_node("HealthRequestSprite").get_modulate()
		modulate.a = 1.0
		get_node("HealthRequestSprite").set_modulate(modulate)
		if ($MedicCooldown.is_stopped()):
			EventBus.emit_signal("medic_used")
			$MedicCooldown.start()

func set_falling_velocity(new_velocity):
	if (new_velocity > max_velocity):
		falling_velocity = max_velocity
	elif (new_velocity < min_velocity):
		falling_velocity = min_velocity
	else:
		falling_velocity = new_velocity

func lose_life():
	if (life_state != LifeState.DEAD && health_state != HealthState.INVINCIBLE):
		set_life(life - 1)
		if (life <= 0):
			die()
		if (life_state != LifeState.DEAD):
			$ScoutVoice.stream = hurt_sfx.pick_random()
			$ScoutVoice.play()
			get_node("CollisionCooldown").start()
			health_state = HealthState.INVINCIBLE
			get_node("InvincibleFlickerTimer").start()
		EventBus.emit_signal("player_life_changed", life)

func get_life():
	set_life(life + 1)
	$HealingSound.play()
	EventBus.emit_signal("player_life_changed", life)
	
func set_life(new_life):
	if (new_life > max_life):
		life = max_life
	elif (new_life < 0):
		life = 0
	else:
		life = new_life

func die():
	life_state = LifeState.DEAD
	get_node("BulletsCooldown").stop()
	$Shooting.stop()
	$ScoutVoice.stream = death_sfx.pick_random()
	$ScoutVoice.play()
	if (current_state == State.FLYING):
		_set_animation("dead_midair")
	if (current_state == State.ON_FLOOR):
		_set_animation("dead")
	emit_signal("player_died")
	pass
	
func _set_animation(animation_name):
	get_node("AnimatedSprite2D").animation = animation_name
	if (animation_name == "dead"):
		EventBus.emit_signal("player_body_fell")
	pass

func _on_area_2d_area_entered(area):
	lose_life()
	pass # Replace with function body.

func _on_bullets_cooldown_timeout():
	if (current_state == State.FLYING):
		generate_bullets()
	pass # Replace with function body.


func _on_collision_cooldown_timeout():
	health_state = HealthState.VULNERABLE
	get_node("InvincibleFlickerTimer").stop()
	visible = true
	pass # Replace with function body.


func _on_invincible_flicker_timer_timeout():
	visible = !visible
	pass # Replace with function body.


func _on_shooting_finished():
	if (current_state == State.FLYING):
		$Shooting.play()
	pass # Replace with function body.

func isDead():
	return life_state == LifeState.DEAD
