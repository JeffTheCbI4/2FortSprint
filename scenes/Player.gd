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
signal player_died

var bullet_scene = preload("res://scenes/bullet.tscn")

enum State { ON_FLOOR, FLYING, DEAD }
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
	if (current_state != State.DEAD):
		_process_player_input(delta)
	if (current_state != State.ON_FLOOR):
		set_falling_velocity(falling_velocity + gravity_force)
		var collision = move_and_collide(Vector2(0, falling_velocity) * delta)
		if (collision && current_state != State.DEAD && collision.get_angle() == 0):
			current_state = State.ON_FLOOR
			get_node("BulletsCooldown").stop()
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
	var spacePresses = Input.is_key_pressed(KEY_SPACE)
	if (spacePresses):
		set_falling_velocity(falling_velocity - jump_force)
		if (current_state == State.ON_FLOOR):
			current_state = State.FLYING
			get_node("BulletsCooldown").start()
	#if (collidedBody):
		#falling_velocity = 0
	pass
	
func set_falling_velocity(new_velocity):
	if (new_velocity > max_velocity):
		falling_velocity = max_velocity
	elif (new_velocity < min_velocity):
		falling_velocity = min_velocity
	else:
		falling_velocity = new_velocity

func lose_life():
	if (current_state != State.DEAD && health_state != HealthState.INVINCIBLE):
		life -= 1
		if (life <= 0):
			die()
		if (current_state != State.DEAD):
			get_node("CollisionCooldown").start()
			health_state = HealthState.INVINCIBLE
			get_node("InvincibleFlickerTimer").start()
		EventBus.emit_signal("player_lost_life", life)

func die():
	current_state = State.DEAD
	get_node("BulletsCooldown").stop()
	_set_animation("dead")
	emit_signal("player_died")
	pass
	
func _set_animation(animation_name):
	get_node("AnimatedSprite2D").animation = animation_name
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
