extends Area2D
class_name Checkpoint

onready var bullet: PackedScene = preload("res://core/weapons/PlayerBullet.tscn")
onready var muzzle = $Gun/Muzzle
onready var gun = $Gun
onready var rpm = $TimerRPM
onready var debug = $Debug
onready var sprite = $Sprite
onready var tween = $Tween

var enemy_qeueue = {}
var damage: float = 1.0
var rotate_speed: float = 10.0
var level: int
var target_adquired: bool = false
var target 
var can_shoot: bool = false

enum FLOAT {AWAY, BACK}
var float_state = FLOAT.AWAY

func _ready() -> void:
	
	debug.add_property("target")
	float_away()

func _process(delta: float) -> void:
	
	if target_adquired:
		var target_direction = (target.global_position - gun.global_position).normalized()
		var current_direction = Vector2.RIGHT.rotated(gun.global_rotation)
		gun.global_rotation = current_direction.linear_interpolate(target_direction, rotate_speed * delta).angle()
		
		if can_shoot:
			shoot_single()
			can_shoot = false
			rpm.start()


func shoot_single() -> void:
	
	var new_bullet = bullet.instance()
	var direction = Vector2.RIGHT.rotated(muzzle.global_rotation)
	new_bullet.global_scale = Vector2(0.3, 0.3)
	new_bullet.shoot(muzzle.global_position, direction, damage)

func _on_Checkpoint_body_entered(body: PhysicsBody2D) -> void:
	
	if body is Enemy:
		if not target_adquired:
			target = body
			target_adquired = true
			can_shoot = true
		else:
			enemy_qeueue[hash(body)] = body
			
func _on_Checkpoint_body_exited(body: PhysicsBody2D) -> void:
	
	if body is Enemy:
		if target_adquired and body == target:
			target_adquired = false
			target = null
		else:
			if enemy_qeueue.size() > 0:
				enemy_qeueue.erase(hash(body))

func _on_TimerRPM_timeout() -> void:
	
	can_shoot = true

func float_away()-> void:
	
	var new_position: Vector2 = sprite.position
	randomize()
	new_position.x += 20 * 1 if randi() % 2 == 0 else -1
	new_position.y += 20 * 1 if randi() % 2 == 0 else -1
	tween.interpolate_property(sprite, "position", Vector2.ZERO , new_position, 3.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	float_state = FLOAT.AWAY
	
func float_back() -> void:
	
	tween.interpolate_property(sprite, "position", sprite.position , Vector2.ZERO, 3.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	float_state = FLOAT.BACK

func _on_Tween_tween_all_completed() -> void:
	
	match float_state:
		FLOAT.AWAY:
			float_back()
		FLOAT.BACK:
			float_away()
