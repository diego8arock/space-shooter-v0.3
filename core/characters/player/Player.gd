extends Actor
class_name Player

onready var explosion: PackedScene = preload("res://effects/small_explosion/SmallExplosion.tscn")
onready var ship_sprite = $Sprite
onready var collision = $CollisionShape2D
onready var camera = $Camera2D
onready var trail = $Trail
onready var debug = $Debug
onready var turret = $Turret
onready var thruster = $Sprite/Thruster

const MAX_HEALTH: float = 100.0

#movement
var direction: Vector2 = Vector2.UP
var velocity: Vector2
var rotation_speed: float = 2.0
var current_speed: float = 0.0
var max_speed: float = 5.0
var min_speed: float = 0.0
var acceleration: float = 2.5
var velocity_rotation: float = 0.0
var super_speed: float = 3.0
var curren_super_speed: float = 1.0
var max_super_speed: float = 3.0
var min_super_speed: float = 1.0
var super_speed_acceleration: float = 2.5

#time
var is_bullet_time_on: bool = false
var max_bullet_Time: float = 100.0
var min_bullet_time: float = 0.0
var bullet_time_use_rate: float = 0.5
var bullet_time_recharge_rate: float = 0.3
var current_bullet_time: float

func _ready() -> void:
	
	start()

func _process(delta: float) -> void:

	if Input.is_action_pressed("player_forward"):
		current_speed += acceleration * delta
		current_speed = clamp(current_speed, min_speed, max_speed)
	
	if Input.is_action_pressed("player_backwards"):
		current_speed -= acceleration * delta
		current_speed = clamp(current_speed, min_speed, max_speed)
		
	if Input.is_action_pressed("player_left"):
		velocity_rotation += rotation_speed * delta	* -1
	
	if Input.is_action_pressed("player_right"):
		velocity_rotation += rotation_speed * delta		
		
	if Input.is_action_pressed("super_speed") and not is_bullet_time_on:
		curren_super_speed += super_speed_acceleration * delta
	else:
		curren_super_speed -= super_speed_acceleration * delta
	curren_super_speed = clamp(curren_super_speed, min_super_speed, max_super_speed)	
		
	if is_bullet_time_on:
		current_bullet_time -= bullet_time_use_rate	
	else:
		current_bullet_time += bullet_time_recharge_rate
	current_bullet_time = clamp(current_bullet_time, min_bullet_time, max_bullet_Time)
	GameManager.stats_ui.set_energy(current_bullet_time)
	
	if is_bullet_time_on and current_bullet_time <= min_bullet_time:
		is_bullet_time_on = false
		camera.is_bullet_time_on = false
		Event.emit_signal("normal_time")
		
func _physics_process(delta: float) -> void:
	
	velocity = direction.normalized().rotated(velocity_rotation) * Time.adjust_speed(current_speed) * Time.adjust_speed(curren_super_speed)
	ship_sprite.global_rotation = velocity_rotation
	collision.global_rotation = velocity_rotation
	move_and_collide(velocity)
	
func _input(event: InputEvent) -> void:
	
	if event is InputEventKey:
		if event.is_action_pressed("super_speed"):
			turret.using_super_speed = true
		if event.is_action_released("super_speed"):
			turret.using_super_speed = false
			
	if event is InputEventMouseButton:
		if event.is_action_pressed("bullet_time"):
			if not is_bullet_time_on:
				Event.emit_signal("slow_down_time")
				is_bullet_time_on = true
			else:
				Event.emit_signal("normal_time")
				is_bullet_time_on = false
			camera.is_bullet_time_on = is_bullet_time_on
	
func take_damage(_damage: float) -> void:
	
	health.take_damage(_damage)	
	GameManager.stats_ui.set_health(health.get_current_health())

func _on_Health_health_depleated() -> void:
	
	died()
	
func died() -> void:
	
	hide()
	trail.hide()
	WeaponManager.show_small_explosion(global_position, global_scale * 1.5)
	Event.emit_signal("player_died")
	set_physics_process(false)
	
func start() -> void:
	
	health = $Health
	health.set_max_health(MAX_HEALTH)
	health.set_full_health()
	collision_damage = 100.0
	current_bullet_time = max_bullet_Time
	Event.connect("health_restored", self, "on_Event_health_restore")
	debug.add_property("is_bullet_time_on")
	
func restart() -> void:
	
	current_speed = min_speed
	curren_super_speed = min_speed
	current_bullet_time = max_bullet_Time
	direction = Vector2.UP
	velocity = Vector2.UP
	velocity_rotation = deg2rad(0)
	show()
	health.set_full_health()
	GameManager.stats_ui.set_health(health.get_current_health())
	camera.restart()
	set_physics_process(true)

func on_Event_health_restore() -> void:
	
	health.set_full_health()
	GameManager.stats_ui.set_health(health.get_current_health())