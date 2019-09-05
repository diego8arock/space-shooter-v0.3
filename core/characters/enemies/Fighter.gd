extends KinematicBody2D

#variables
var velocity: Vector2
var max_seek_speed: float = 3.0
var max_pursuit_speed: float = 4.0	
var max_wander_speed: float = 2.0
var desired_velocity: Vector2
var steering: Vector2
var future_position: Vector2
var max_force: float = 2.0
var mass: float = 3.0
var player
var wander_angle: float = 0.0
const CIRCLE_DISTANCE: float = 20.0
const CIRCLE_RADIUS: float = 10.0
const ANGLE_CHANGE: float = 5.0
var wander_rotation_speed: float = 2.0

enum STATE {IDLE, SEEK, PURSUIT}
var state_name = ["IDLE", "SEEK", "PURSUIT"]
var state 

var health: float = 100.0
onready var bullet: PackedScene = preload("res://core/weapons/EnemyBullet.tscn")
onready var muzzle = $Sprite/Muzzle
onready var rpm = $TimerRPM
var can_shoot: bool = true
var bullet_damage: float = 5.0
var collision_damage: float = 15.0
var points: int = 10
var is_alive: bool = true

onready var explosion: PackedScene = preload("res://effects/small_explosion/SmallExplosion.tscn")

#signals
signal screen_entered()
signal screen_exited()

#debug
var debug_state
var debug_T
var debug_velocity
var debug_angle
var debug_collider

func _ready() -> void:
	
	#debug_state = Debug.add("fighter-state")
	#debug_T = Debug.add("fighter-T")
	#debug_velocity = Debug.add("fighter-velocity")
	#debug_angle = Debug.add("fighter-angle")
	#debug_collider = Debug.add("fighter-collider")
	chage_state(STATE.IDLE)

func _physics_process(delta: float) -> void:	
	
	match state:
		STATE.IDLE:
			velocity = wander(delta)
			var current_direction = Vector2(1, 0).rotated(global_rotation)
			global_rotation = current_direction.normalized().slerp(velocity.normalized(), wander_rotation_speed * delta).angle()
		STATE.SEEK:
			velocity = seek(player.global_position)
			look_at(player.global_position)	
		STATE.PURSUIT:
			velocity = pursuit(player.global_position, player.velocity)	
			look_at(player.global_position)	
			shoot_bullet() 
		
	var collision = move_and_collide(velocity)	
	if collision:
		collision.collider.take_damage(collision_damage)
		kill()
			
		
func seek(_target_position: Vector2) -> Vector2:
	
	desired_velocity = (_target_position - global_position).normalized() * max_seek_speed
	steer(desired_velocity - velocity)
	return (velocity + steering).clamped(max_seek_speed)
	
func pursuit(_target_position: Vector2, _target_velocity: Vector2) -> Vector2:
	
	var distance = _target_position - global_position
	var T = distance.length() / max_pursuit_speed
	#debug_T.update_data(str(T))
	future_position = _target_position + _target_velocity * T
	steer(seek(future_position))
	return (velocity + steering).clamped(max_pursuit_speed)

func wander(_delta) -> Vector2:
	
	var circle_center: Vector2 = velocity
	circle_center = circle_center.normalized()
	circle_center *= CIRCLE_DISTANCE
		
	var displacement: Vector2 = Vector2(0, -1)
	displacement *= CIRCLE_RADIUS
		
	var rad_wander_angle = deg2rad(wander_angle)
	var length = displacement.length()
	displacement.x = cos(rad_wander_angle) * length
	displacement.y = sin(rad_wander_angle) * length
		
	randomize()
	wander_angle += randf() * ANGLE_CHANGE - ANGLE_CHANGE * 0.5
		
	var wander_force: Vector2 = circle_center + displacement
		
	steer(wander_force)		
	return (velocity + steering).clamped(max_wander_speed)

func steer(_start: Vector2) -> void:	
	
	steering = _start
	steering = steering.clamped(max_force)
	steering /= mass

func _on_SeekArea_body_entered(body: PhysicsBody2D) -> void:

	chage_state(STATE.SEEK)
	player = body	

func _on_SeekArea_body_exited(body: PhysicsBody2D) -> void:
	
	chage_state(STATE.IDLE)

func _on_PursuitArea_body_entered(body: PhysicsBody2D) -> void:
	
	chage_state(STATE.PURSUIT)

func _on_PursuitArea_body_exited(body: PhysicsBody2D) -> void:
	
	chage_state(STATE.SEEK)
	
func chage_state(_state) -> void:
	
	state = _state
	#debug_state.update_data(state_name[state])

func shoot_bullet() -> void:
	
	if can_shoot:
		var new_bullet = bullet.instance()
		var direction = Vector2(1, 0).rotated(muzzle.global_rotation)
		new_bullet.global_scale = Vector2(0.3, 0.3)
		new_bullet.shoot(muzzle.global_position, direction, bullet_damage)
		can_shoot = false
		rpm.start()	

func take_damage(_damage: float) -> void:
	
	health -= _damage
	if health <= 0.0:
		kill()
		
func kill() -> void:
	
	hide()
	WeaponManager.show_small_explosion(global_position, global_scale * 1.5)	
	EnemyManager.delete_enemy(self)

func _on_VisibilityNotifier2D_screen_entered() -> void:
	
	emit_signal("screen_entered")

func _on_VisibilityNotifier2D_screen_exited() -> void:
	
	emit_signal("screen_exited")

func _on_TimerRPM_timeout() -> void:
	
	can_shoot = true
