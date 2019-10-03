extends Enemy
class_name Fighter

onready var bullet: PackedScene = preload("res://core/weapons/EnemyBullet.tscn")
onready var muzzle = $Sprite/Muzzle
onready var rpm = $TimerRPM
onready var debug = $Debug

var can_shoot: bool = true
var bullet_damage: float = 5.0

func _ready() -> void:	

	chage_state(STATE.IDLE)
	health = $Health
	var d = data as CoreData
	health.set_max_health(d.max_health)
	health.set_full_health()
	debug.add_property("points")

func _physics_process(delta: float) -> void:	
	
	match state:
		STATE.IDLE:
			velocity = wander(delta)
			var current_direction = Vector2.RIGHT.rotated(global_rotation)
			global_rotation = current_direction.normalized().slerp(velocity.normalized(), wander_rotation_speed * delta).angle()
		STATE.SEEK:
			velocity = seek(player.global_position)
			look_at(player.global_position)	
		STATE.ATTACK:
			velocity = pursuit(player.global_position, player.velocity)	
			look_at(player.global_position)	
			shoot_bullet() 
		
	var collision = move_and_collide(velocity)	
	if collision:
		collision.collider.take_damage(collision_damage)
		take_damage(collision.collider.collision_damage)	
		
func _on_SeekArea_body_entered(body: PhysicsBody2D) -> void:

	chage_state(STATE.SEEK)
	player = body	

func _on_SeekArea_body_exited(body: PhysicsBody2D) -> void:
	
	chage_state(STATE.IDLE)

func _on_PursuitArea_body_entered(body: PhysicsBody2D) -> void:
	
	chage_state(STATE.ATTACK)

func _on_PursuitArea_body_exited(body: PhysicsBody2D) -> void:
	
	chage_state(STATE.SEEK)

func shoot_bullet() -> void:
	
	if can_shoot:
		var new_bullet = bullet.instance()
		var direction = Vector2.RIGHT.rotated(muzzle.global_rotation)
		new_bullet.global_scale = Vector2(0.3, 0.3)
		new_bullet.shoot(muzzle.global_position, direction, bullet_damage)
		can_shoot = false
		rpm.start()	

func take_damage(_damage: float) -> void:
	
	health.take_damage(_damage)
	
func _on_Health_health_depleated() -> void:
	
	died()
		
func died() -> void:
	
	WeaponManager.show_small_explosion(global_position, global_scale * 1.5)	
	.died()

func _on_VisibilityNotifier2D_screen_entered() -> void:
	
	emit_signal("screen_entered")

func _on_VisibilityNotifier2D_screen_exited() -> void:
	
	emit_signal("screen_exited")

func _on_TimerRPM_timeout() -> void:
	
	can_shoot = true



