extends Sprite

onready var rpm = $TimerRPM
onready var pivot = $Pivot
onready var muzzle = $Pivot/Muzzle
onready var bullet: PackedScene = preload("res://core/weapons/PlayerBullet.tscn")
onready var heatseeking: PackedScene = preload("res://core/weapons/PlayerHeatSeeking.tscn")

enum WEAPON_TYPE { SINGLE, SHOTGUN, RAPID_FIRE, HEATSEEKING }
var type

var target: Vector2
var rotate_speed: float = 10.0
var can_shoot: bool = true
var using_super_speed: bool = false
var damage: float = 20.0

func _ready() -> void:
	
	Event.connect("power_up_picked_up", self, "on_Event_power_up_picked_up")
	set_weapon_type(WEAPON_TYPE.SINGLE)

func _process(delta: float) -> void:
	
	target = get_global_mouse_position()
	var target_direction = (target - global_position).normalized()
	var current_direction = Vector2(1, 0).rotated(global_rotation)
	global_rotation = current_direction.linear_interpolate(target_direction, rotate_speed * delta).angle()
	
	if can_shoot and not using_super_speed and Input.is_mouse_button_pressed(BUTTON_LEFT):		
		match type:
			WEAPON_TYPE.SINGLE:
				shoot_single()
			WEAPON_TYPE.SHOTGUN: 
				shoot_shotgun()	
			WEAPON_TYPE.RAPID_FIRE: 
				shoot_rapid_fire()	
			WEAPON_TYPE.HEATSEEKING: 
				shoot_heatseeking()
		can_shoot = false
		rpm.start()
		
func shoot_single() -> void:
	
	var new_bullet = bullet.instance()
	var direction = Vector2(1, 0).rotated(muzzle.global_rotation)
	new_bullet.global_scale = Vector2(0.3, 0.3)
	new_bullet.shoot(muzzle.global_position, direction, damage)
	
func shoot_shotgun() -> void:
	
	var left = bullet.instance()
	var center = bullet.instance()
	var right = bullet.instance()
		
	var direction = Vector2(1, 0).rotated(muzzle.global_rotation)
	left.global_scale = Vector2(0.3, 0.3)
	center.global_scale = Vector2(0.3, 0.3)
	right.global_scale = Vector2(0.3, 0.3)
	var angle = 5
	left.shoot(muzzle.global_position, direction.rotated(deg2rad(angle)), damage)
	center.shoot(muzzle.global_position, direction, damage)
	right.shoot(muzzle.global_position, direction.rotated(deg2rad(-angle)), damage)
	
func shoot_rapid_fire() -> void:
	
	var new_bullet = bullet.instance()
	var direction = Vector2(1, 0).rotated(muzzle.global_rotation)
	new_bullet.global_scale = Vector2(0.3, 0.3)
	new_bullet.shoot(muzzle.global_position, direction, damage)
	
func shoot_heatseeking() -> void:
	
	var new_missile = heatseeking.instance()
	var direction = Vector2(1, 0).rotated(muzzle.global_rotation)
	new_missile.global_scale = Vector2(0.3, 0.3)
	new_missile.shoot(muzzle.global_position, direction, damage)

func _on_TimerRPM_timeout() -> void:
	
	can_shoot = true

func on_Event_power_up_picked_up(_type) -> void:
	
	set_weapon_type(_type)
	
func set_weapon_type(_type) -> void:
	
	type = _type
	match type:
			WEAPON_TYPE.SINGLE:
				rpm.wait_time = 0.2
				damage = 35.0
			WEAPON_TYPE.SHOTGUN: 
				rpm.wait_time = 0.8
				damage = 15.0
			WEAPON_TYPE.RAPID_FIRE: 
				rpm.wait_time = 0.09
				damage = 10.0
			WEAPON_TYPE.HEATSEEKING: 
				rpm.wait_time = 0.5
				damage = 20.0
