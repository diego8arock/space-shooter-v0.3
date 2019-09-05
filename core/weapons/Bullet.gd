extends Area2D

onready var explosion: PackedScene = preload("res://effects/bullet_explosion/BulletExplosion.tscn")
var velocity: Vector2
var max_speed: float = 300.0
var speed_multiplier: float = 3.0
var damage: float = 0.0

func _process(delta: float) -> void:
	
	global_position += velocity * delta
	
func shoot(_position: Vector2, _rotation: Vector2, _damage: float) -> void:
	
	global_position = _position
	global_rotation = _rotation.angle()
	damage = _damage
	velocity = _rotation * max_speed * speed_multiplier
	WeaponManager.add(self)

func _on_Timer_timeout() -> void:
	
	call_deferred("free")

func _on_Bullet_body_entered(body: PhysicsBody2D) -> void:
	
	if body.health != 0.0:
		WeaponManager.show_explosion(explosion.instance(), body.global_position, global_scale)
		body.take_damage(damage)	
		call_deferred("free")
