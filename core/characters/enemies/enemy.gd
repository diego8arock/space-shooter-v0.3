extends Actor
class_name Enemy

#movement static
var velocity: Vector2
var steering: Vector2
var desired_velocity: Vector2
var future_position: Vector2
var wander_angle: float = 0.0

#general properties
var max_force: float
var mass: float

#seek properties
var max_seek_speed: float
var seek_rotation_speed: float

#pursuit properties
var max_pursuit_speed: float
var pursuit_rotation_speed: float

#wander properties
var max_wander_speed: float
var cirlce_distance: float
var circle_radius: float
var angle_change: float
var wander_rotation_speed: float

#arrival properties
var arrival_distance: float
var arrival_rotation_speed: float
var max_arrival_speed: float

#evade properties
var evade_distance: float
var evade_rotation_speed: float
var max_evade_speed: float

#target
var player
var location

#core data
var points: int

#state
enum STATE {IDLE, SEEK, ATTACK, EVADE, ARRIVE, FLEE}
var state_name = ["IDLE", "SEEK", "ATTACK", "EVADE", "ARRIVE", "FLEE"]
var state

#ui
var health_bar

func _ready() -> void:

	parse_movement()

	var d = data as CoreData
	collision_damage = d.collision_damage
	points = d.points
	
func parse_movement() -> void:
	
	var m = movement as Movement
	
	max_force = m.max_force
	mass = m.mass
	
	max_seek_speed = m.max_seek_speed
	max_pursuit_speed = m.max_pursuit_speed
	max_wander_speed = m.max_wander_speed
	max_evade_speed = m.max_evade_speed
	max_arrival_speed = m.max_arrival_speed
	
	wander_rotation_speed = m.wander_rotation_speed
	seek_rotation_speed = m.seek_rotation_speed
	pursuit_rotation_speed = m.pursuit_rotation_speed
	arrival_rotation_speed = m.arrival_rotation_speed
	evade_rotation_speed = m.evade_rotation_speed
	
	cirlce_distance = m.cirlce_distance
	circle_radius = m.circle_radius
	angle_change = m.angle_change
	
	arrival_distance = m.arrival_distance
	evade_distance = m.evade_distance	

func seek(_target_position: Vector2) -> Vector2:

	desired_velocity = (_target_position - global_position).normalized() * Time.adjust_speed(max_seek_speed)
	steer(desired_velocity - velocity)
	return (velocity + steering).clamped(Time.adjust_speed(max_seek_speed))
	
func flee(_target_position: Vector2) -> Vector2:

	desired_velocity = (global_position - _target_position).normalized() * Time.adjust_speed(max_evade_speed)
	steer(desired_velocity - velocity)
	return (velocity + steering).clamped(Time.adjust_speed(max_evade_speed))
	
func arrive(_target_position: Vector2) -> Vector2:
	
	desired_velocity = _target_position - global_position
	var distance = desired_velocity.length()
	if distance < arrival_distance:
		desired_velocity = desired_velocity.normalized() * Time.adjust_speed(max_arrival_speed) * (distance / arrival_distance)
	else:
		desired_velocity = desired_velocity.normalized() * Time.adjust_speed(max_arrival_speed)
	steer(desired_velocity - velocity)
	return (velocity + steering).clamped(Time.adjust_speed(max_arrival_speed))

func pursuit(_target_position: Vector2, _target_velocity: Vector2) -> Vector2:

	var distance = _target_position - global_position
	var T = distance.length() / Time.adjust_speed(max_pursuit_speed)
	future_position = _target_position + _target_velocity * T
	steer(seek(future_position))
	return (velocity + steering).clamped(Time.adjust_speed(max_pursuit_speed))
	
func evade(_target_position: Vector2, _target_velocity: Vector2) -> Vector2:

	var distance = _target_position - global_position
	var T = distance.length() / Time.adjust_speed(max_evade_speed)
	future_position = _target_position + _target_velocity * T
	steer(flee(future_position))
	return (velocity + steering).clamped(Time.adjust_speed(max_evade_speed))

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
	
func rotate_to(_rotation_speed: float, _delta: float) -> void:
	var current_direction = Vector2.RIGHT.rotated(global_rotation)
	global_rotation = current_direction.normalized().slerp(velocity.normalized(), _rotation_speed * _delta).angle()

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