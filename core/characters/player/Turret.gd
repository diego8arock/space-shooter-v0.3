extends Sprite

onready var rpm = $TimerRPM
onready var pivot = $Pivot
onready var muzzle = $Pivot/Muzzle
onready var bullet: PackedScene = preload("res://core/weapons/PlayerBullet.tscn")
var target: Vector2
var rotate_speed: float = 10.0
var can_shoot: bool = true
var bullet_damage: float = 20.0

func _process(delta: float) -> void:
	
	target = get_global_mouse_position()
	var target_direction = (target - global_position).normalized()
	var current_direction = Vector2(1, 0).rotated(global_rotation)
	global_rotation = current_direction.linear_interpolate(target_direction, rotate_speed * delta).angle()
	
	if can_shoot and Input.is_mouse_button_pressed(BUTTON_LEFT):
		var new_bullet = bullet.instance()
		var direction = Vector2(1, 0).rotated(muzzle.global_rotation)
		new_bullet.global_scale = Vector2(0.3, 0.3)
		new_bullet.shoot(muzzle.global_position, direction, bullet_damage)
		can_shoot = false
		rpm.start()


func _on_TimerRPM_timeout() -> void:
	can_shoot = true
