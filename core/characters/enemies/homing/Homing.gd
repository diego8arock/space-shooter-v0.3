extends Enemy

onready var shoot = $TimerShoot

var missile: PackedScene = preload("res://core/weapons/Missile.tscn")
var ready_missile
var can_shoot = true

func _ready() -> void:
	
	chage_state(STATE.IDLE)
	health = $Health
	var d = data as CoreData
	health.set_max_health(d.max_health)
	health.set_full_health()
	var new_missile = missile.instance()
	new_missile.prepare(10, self)	
	ready_missile = new_missile

func _physics_process(delta: float) -> void:
	
	match state:
		STATE.IDLE:
			velocity = wander(delta)
			var current_direction = Vector2.RIGHT.rotated(global_rotation)
			global_rotation = current_direction.normalized().slerp(velocity.normalized(), wander_rotation_speed * delta).angle()
		STATE.SEEK:
			velocity = seek(player.global_position)
			look_at(player.global_position)	
			if can_shoot:
				shoot.start()
				can_shoot = false
			
	var collision = move_and_collide(velocity)	
	if collision:
		collision.collider.take_damage(collision_damage)
		take_damage(collision.collider.collision_damage)	

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	
	player = body
	chage_state(STATE.SEEK)	

func _on_TimerShoot_timeout() -> void:
	
	ready_missile.shoot(player)
