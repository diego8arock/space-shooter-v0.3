extends Area2D

onready var timer = $Timer
onready var explosion_effect: PackedScene = preload("res://effects/bullet_explosion/BulletExplosion.tscn")

var velocity: Vector2
var steering: Vector2
var desired_velocity: Vector2
var max_speed: float = 6.0
var damage: float = 0.0
var max_force: float = 2.0
var mass: float = 3.0
var target: Node2D
var shooted: bool = false

signal destroyed

func _physics_process(delta: float) -> void:
	
	if shooted:
		velocity = seek(target.global_position)
		global_position += velocity
		look_at(target.global_position)	
		
func align_with_ship(_position: Vector2, _rotation: float) -> void:
	
	global_position = _position
	global_rotation = _rotation

func shoot( _target: Node2D) -> void:
	
	target = _target
	shooted = true
	timer.start()

func prepare(_damage: float) -> void:
	
	damage = _damage
	WeaponManager.add(self)
	
func seek(_target_position: Vector2) -> Vector2:

	desired_velocity = (_target_position - global_position).normalized() * Time.adjust_speed(max_speed)
	steer(desired_velocity - velocity)
	return (velocity + steering).clamped(Time.adjust_speed(max_speed))
	
func steer(_start: Vector2) -> void:

	steering = _start
	steering = steering.clamped(max_force)
	steering /= mass

func _on_Missile_area_entered(area: Area2D) -> void:
	
	destroy() 

func _on_Missile_body_entered(body: PhysicsBody2D) -> void:
	
	if body is Actor and body.health.get_current_health() != 0.0:
		body.take_damage(damage)	
		destroy() 	

func destroy() -> void:
	
	emit_signal("destroyed")
	if timer:
		timer.stop()
	set_physics_process(false)
	hide()
	WeaponManager.show_explosion(explosion_effect.instance(), global_position, global_scale)
	call_deferred("free")

func _on_Timer_timeout() -> void:
	
	destroy() 