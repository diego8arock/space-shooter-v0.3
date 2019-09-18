extends Sprite

onready var rpm = $TimerRPM
onready var muzzle = $Pivot/Muzzle
onready var bullet: PackedScene = preload("res://core/weapons/EnemyBullet.tscn")

var rotate_speed: float = 10.0
var target
var is_target_in_range: bool = false
var can_shoot: bool = false
var damage

func _ready() -> void:
	
	rpm.start()

func _process(delta: float) -> void:
	
	if is_target_in_range:
		var target_direction = (target.global_position - global_position).normalized()
		var current_direction = Vector2.RIGHT.rotated(global_rotation)
		global_rotation = current_direction.linear_interpolate(target_direction, rotate_speed * delta).angle()
		
		if can_shoot:
			shoot_single()
			can_shoot = false
			rpm.start()
			

func attack_player(_player) -> void:
	
	target = _player
	is_target_in_range = true
	
func stop_attack() -> void:
	
	is_target_in_range = false

func _on_TimerRPM_timeout() -> void:
	
	can_shoot = true

func shoot_single() -> void:
	
	var new_bullet = bullet.instance()
	var direction = Vector2.RIGHT.rotated(muzzle.global_rotation)
	new_bullet.global_scale = Vector2(0.3, 0.3)
	new_bullet.shoot(muzzle.global_position, direction, damage)