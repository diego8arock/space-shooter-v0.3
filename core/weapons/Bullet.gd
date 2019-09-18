extends Area2D

onready var timer = $Timer
onready var explosion_effect: PackedScene = preload("res://effects/bullet_explosion/BulletExplosion.tscn")
onready var debug = $Debug

var velocity: Vector2
var max_speed: float = 300.0
var speed_multiplier: float = 4.0
var damage: float = 0.0

func _ready() -> void:
	
	debug.add_property("velocity")

func _physics_process(delta: float) -> void:
	
	global_position += Time.adjust_velocity(velocity) * delta
	
func shoot(_position: Vector2, _rotation: Vector2, _damage: float) -> void:
	
	global_position = _position
	global_rotation = _rotation.angle()
	damage = _damage
	velocity = _rotation * max_speed * speed_multiplier
	WeaponManager.add(self)

func _on_Timer_timeout() -> void:
	
	debug.delete_all_properties()
	call_deferred("free")

func _on_Bullet_body_entered(body: PhysicsBody2D) -> void:
	
	if body is Actor and body.health.get_current_health() != 0.0:
		timer.stop()
		set_physics_process(false)
		hide()
		WeaponManager.show_explosion(explosion_effect.instance(), global_position, global_scale * 2)
		body.take_damage(damage)	
		debug.delete_all_properties()
		call_deferred("free")
