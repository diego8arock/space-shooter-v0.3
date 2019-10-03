extends Enemy

onready var turret_controller = $TurretsController
onready var debug = $Debug
var bullet_damage: float = 5.0

enum TURRET_STATE { STOPPED, ATTACKING }
var turret_state

var sprite_radius
var health_bar_pos_y

func _ready() -> void:
	
	chage_state(STATE.IDLE)
	health = $Health
	health_bar = $HealthBar
	turret_state = TURRET_STATE.STOPPED
	var d = data as CoreData
	health.set_max_health(d.max_health)
	health_bar.set_max_value(d.max_health)
	health.set_full_health()
	debug.add_property("current_health", health)
	debug.add_property("velocity")
	turret_controller.set_damage(bullet_damage)
	audio = $AudioStreamPlayer2D
	var texture_size = $Sprite.texture.get_size()
	sprite_radius = texture_size.x if texture_size.x > texture_size.y else texture_size.y
	health_bar_pos_y = sprite_radius + (sprite_radius * 0.3)

func _process(delta: float) -> void:
	
	health_bar.global_position = Vector2(global_position.x - (sprite_radius / 2), global_position.y - health_bar_pos_y)
	health_bar.global_rotation = deg2rad(0)

func _physics_process(delta: float) -> void:	
	
	match state:
		STATE.IDLE:
			velocity = wander(delta)
			var current_direction = Vector2.RIGHT.rotated(global_rotation)
			global_rotation = current_direction.normalized().slerp(velocity.normalized(), wander_rotation_speed * delta).angle()
			stop_attack()
		STATE.ATTACK:
			start_attack()
		
	var collision = move_and_collide(velocity)	
	if collision:
		collision.collider.take_damage(collision_damage)
		take_damage(collision.collider.collision_damage)

func take_damage(_damage: float) -> void:
	
	health.take_damage(_damage)
	health_bar.take_damage(_damage)

func start_attack() -> void:
	
	if turret_state != TURRET_STATE.ATTACKING:
		turret_controller.attack_player(player)
		turret_state = TURRET_STATE.ATTACKING
		
func stop_attack() -> void:
	
	if turret_state != TURRET_STATE.STOPPED:
		turret_controller.stop_attack()
		turret_state = TURRET_STATE.STOPPED

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	
	chage_state(STATE.ATTACK)
	player = body

func _on_Area2D_body_exited(body: PhysicsBody2D) -> void:
	
	chage_state(STATE.IDLE)

func _on_Health_health_depleated() -> void:
	
	died()
	
func died() -> void:
	
	remove_child($CollisionPolygon2D)
	turret_controller.stop_attack()
	WeaponManager.show_big_explosion(global_position, global_scale * 1.5)	
	.died()
