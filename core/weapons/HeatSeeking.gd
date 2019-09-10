extends Area2D

onready var explosion: PackedScene = preload("res://effects/bullet_explosion/BulletExplosion.tscn")
var speed:float = 300.0
var speed_multiplier: float = 3.0
var damage: float = 0.0

var velocity: Vector2
var acceleration: Vector2
var target = null
var max_force = 100.0

enum STATE { FIRE, SEEK }
var state = STATE.FIRE

onready var debug = $Debug

func _ready() -> void:
	
	debug.add_property("target")
	debug.add_property("velocity")
	debug.add_property("acceleration")
	
func seek() -> Vector2:
	
	var steer: Vector2 = Vector2.ZERO
	var desired = (target.global_position - global_position).normalized() * speed
	steer = (desired - velocity).normalized() * max_force	
	return steer
	
func _physics_process(delta: float) -> void:
	
	if EnemyManager.is_enemy_alive(target):
		
		match state:
			STATE.FIRE:
				global_position += velocity * delta
			STATE.SEEK:
				acceleration += seek()
				velocity += acceleration * delta
				velocity = velocity.clamped(speed)
				global_rotation = velocity.angle()
				global_position += velocity * delta
	else:
		debug.delete_all_properties()
		call_deferred("free")
	
func shoot(_position: Vector2,  _rotation: Vector2, _damage: float) -> void:
	
	damage = _damage
	global_position = _position
	global_rotation = _rotation.angle()
	WeaponManager.add(self)
	velocity = _rotation * Time.adjust_speed(speed) * speed_multiplier
	if not find_target():
		debug.delete_all_properties()
		call_deferred("free")
	
func find_target() -> bool:
	
	var enemies = EnemyManager.get_all_enemies()
	if enemies.size() == 0:
		return false
	
	var min_distance: float = 4000.0
	var new_target = null
	for e in enemies:
		var distance = global_position.distance_to(e.global_position)
		if distance < min_distance:
			min_distance = distance
			new_target = e
			
	if new_target:
		target = new_target
		return true
	else: 
		return false
	
func _on_HeatSeeking_body_entered(body: PhysicsBody2D) -> void:
	
	if body is Actor and body.health.get_current_health() != 0.0:
		WeaponManager.show_explosion(explosion.instance(), body.global_position, global_scale)
		body.take_damage(damage)
		debug.delete_all_properties()	
		call_deferred("free")

func _on_TimerStateChange_timeout() -> void:
	
	state = STATE.SEEK

func _on_TimeToLive_timeout() -> void:
	
	debug.delete_all_properties()	
	call_deferred("free")
