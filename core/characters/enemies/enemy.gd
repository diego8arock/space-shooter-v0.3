extends Actor
class_name Enemy

#movement static
var velocity: Vector2
var steering: Vector2
var desired_velocity: Vector2
var future_position: Vector2
var wander_angle: float = 0.0

#movement to define
var max_force: float
var mass: float
var max_seek_speed: float
var max_pursuit_speed: float
var max_wander_speed: float
var cirlce_distance: float
var circle_radius: float
var angle_change: float
var wander_rotation_speed: float
var arrival_distance: float
var flee_distance: float

#target
var player
var location

#core data
var points: int

#state
enum STATE {IDLE, SEEK, ATTACK, EVADE, ARRIVE, FLEE}
var state_name = ["IDLE", "SEEK", "ATTACK", "EVADE", "ARRIVE", "FLEE"]
var state

#signals
#warning-ignore:unused_signal
signal screen_entered()
#warning-ignore:unused_signal
signal screen_exited()

#ui
var health_bar

func _ready() -> void:

	var m = movement as Movement
	max_force = m.max_force
	mass = m.mass
	max_seek_speed = m.max_seek_speed
	max_pursuit_speed = m.max_pursuit_speed
	max_wander_speed = m.max_wander_speed
	cirlce_distance = m.cirlce_distance
	circle_radius = m.circle_radius
	angle_change = m.angle_change
	wander_rotation_speed = m.wander_rotation_speed
	arrival_distance = m.arrival_distance
	flee_distance = m.flee_distance	

	var d = data as CoreData
	collision_damage = d.collision_damage
	points = d.points

func seek(_target_position: Vector2) -> Vector2:

	desired_velocity = (_target_position - global_position).normalized() * Time.adjust_speed(max_seek_speed)
	steer(desired_velocity - velocity)
	return (velocity + steering).clamped(Time.adjust_speed(max_seek_speed))
	
func flee(_target_position: Vector2) -> Vector2:

	desired_velocity = (global_position - _target_position).normalized() * Time.adjust_speed(max_pursuit_speed)
	steer(desired_velocity - velocity)
	return (velocity + steering).clamped(Time.adjust_speed(max_pursuit_speed))
	
func arrive(_target_position: Vector2) -> Vector2:
	
	desired_velocity = _target_position - global_position
	var distance = desired_velocity.length()
	if distance < arrival_distance:
		desired_velocity = desired_velocity.normalized() * Time.adjust_speed(max_seek_speed) * (distance / arrival_distance)
	else:
		desired_velocity = desired_velocity.normalized() * Time.adjust_speed(max_seek_speed)
	steer(desired_velocity - velocity)
	return (velocity + steering).clamped(Time.adjust_speed(max_seek_speed))

func pursuit(_target_position: Vector2, _target_velocity: Vector2) -> Vector2:

	var distance = _target_position - global_position
	var T = distance.length() / Time.adjust_speed(max_pursuit_speed)
	future_position = _target_position + _target_velocity * T
	steer(seek(future_position))
	return (velocity + steering).clamped(Time.adjust_speed(max_pursuit_speed))
	
func evade(_target_position: Vector2, _target_velocity: Vector2) -> Vector2:

	var distance = _target_position - global_position
	var T = distance.length() / Time.adjust_speed(max_pursuit_speed)
	future_position = _target_position + _target_velocity * T
	steer(flee(future_position))
	return (velocity + steering).clamped(Time.adjust_speed(max_pursuit_speed))

func wander(_delta) -> Vector2:

	var circle_center: Vector2 = velocity
	circle_center = circle_center.normalized()
	circle_center *= cirlce_distance

	var displacement: Vector2 = Vector2(0, -1)
	displacement *= circle_radius

	var rad_wander_angle = deg2rad(wander_angle)
	var length = displacement.length()
	displacement.x = cos(rad_wander_angle) * length
	displacement.y = sin(rad_wander_angle) * length

	randomize()
	wander_angle += randf() * angle_change - angle_change * 0.5

	var wander_force: Vector2 = circle_center + displacement

	steer(wander_force)
	return (velocity + steering).clamped(Time.adjust_speed(max_wander_speed))

func steer(_start: Vector2) -> void:

	steering = _start
	steering = steering.clamped(max_force)
	steering /= mass

func died() -> void:

	set_physics_process(false)
	set_process(false)
	hide()
	Event.emit_signal("enemy_destroyed", global_position)
	#if put on a function, the yield wont work
	if audio:
		audio.bus = "EnemyDeathExplosion"
		audio.stream = death_explosion
		audio.play()
		yield(audio, "finished")
	EnemyManager.delete_enemy(self)
	
func chage_state(_state) -> void:
	
	state = _state