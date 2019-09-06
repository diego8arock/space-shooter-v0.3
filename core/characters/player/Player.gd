extends Actor

onready var explosion: PackedScene = preload("res://effects/small_explosion/SmallExplosion.tscn")

export var ui_path: NodePath
var ui

onready var ship_sprite = $Sprite
onready var collision = $CollisionShape2D
onready var camera = $Camera2D
onready var indicators = $Indicators
onready var trail = $Trail
onready var health = $Health
onready var debug = $Debug

var direction: Vector2 = Vector2(1, 0)
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

signal player_died()

func _ready() -> void:
	
	ui = get_node(ui_path)
	health.set_max_health(100.0)
	health.set_full_health()
	debug.add_property("max_super_speed")
	debug.add_property("current_health", health)

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
		
	if Input.is_action_pressed("super_speed"):
		curren_super_speed += super_speed_acceleration * delta
		curren_super_speed = clamp(curren_super_speed, min_super_speed, max_super_speed)
	else:
		curren_super_speed -= super_speed_acceleration * delta
		curren_super_speed = clamp(curren_super_speed, min_super_speed, max_super_speed)		
		
func _physics_process(delta: float) -> void:
	
	velocity = direction.normalized().rotated(velocity_rotation) * current_speed * curren_super_speed
	ship_sprite.global_rotation = velocity_rotation + deg2rad(90)
	collision.global_rotation = velocity_rotation
	move_and_collide(velocity)
	
func take_damage(_damage: float) -> void:
	
	health.take_damage(_damage)	
	ui.set_progress(health.get_current_health())

func _on_Health_health_depleated() -> void:
	
	died()
	
func died() -> void:
	
	hide()
	trail.hide()
	WeaponManager.show_small_explosion(global_position, global_scale * 1.5)
	emit_signal("player_died")
	
func restart() -> void:
	
	current_speed = 0.0
	curren_super_speed = 0.0
	velocity = Vector2()
	global_position = Vector2(1024, 600)
	global_rotation = deg2rad(0)
	ship_sprite.global_rotation = deg2rad(90)
	collision.global_rotation = deg2rad(90)
	show()
	health.set_full_health()
	yield(get_tree().create_timer(1.0), "timeout")
	trail.show()
