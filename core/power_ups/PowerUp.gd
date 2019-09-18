extends RigidBody2D
class_name PowerUP

enum POWER_UP { HEALTH, SHOTGUN, RAPID_FIRE, HEATSEEKING }
var power_up_name_list = { POWER_UP.HEALTH: "HEALTH", POWER_UP.SHOTGUN: "SHOTGUN", POWER_UP.RAPID_FIRE: "RAPID FIRE", POWER_UP.HEATSEEKING: "HEATSEEKING"  }
var type
var power_up_name
onready var sprite = $Sprite
onready var debug= $Debug
onready var label = $Sprite/Label

var initial_direction: Vector2

func _ready() -> void:
	
	randomize()
	var rand_x = rand_range(-1.0, 1.0)
	var rand_y = rand_range(-1.0, 1.0)
	initial_direction = Vector2(rand_x, rand_y).normalized()	
	debug.add_property("power_up_name")
	debug.add_property("initial_direction")
	
func set_type(_type) -> void:
	
	type = _type	
	power_up_name = power_up_name_list[_type]
	label.text = power_up_name
	label.rect_position.x = (label.rect_size.x / 2) * -1
	
func set_icon() -> void:
	
	match type:
		POWER_UP.HEALTH:
			sprite.texture = load("res://assets/power_ups/powerupGreen_shield.png")
		POWER_UP.SHOTGUN:
			sprite.texture = load("res://assets/power_ups/powerupBlue.png")
		POWER_UP.RAPID_FIRE:
			sprite.texture = load("res://assets/power_ups/powerupGreen.png")
		POWER_UP.HEATSEEKING:
			sprite.texture = load("res://assets/power_ups/powerupRed.png")			
	
func set_initial_position(_position: Vector2) -> void:
	
	global_position = _position
	
func eject_power_up() -> void:
	
	add_central_force(initial_direction * 10)

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:	
	
	if type != POWER_UP.HEALTH:
		Event.emit_signal("power_up_picked_up", type)
		Event.emit_signal("message_sent", "PICKED UP POWER UP: " + power_up_name_list[type])
	else:
		Event.emit_signal("health_restored")
		Event.emit_signal("message_sent", "HEALTH RESTORED")
		
	call_deferred("free")


func _on_TimeToLive_timeout() -> void:
	
	call_deferred("free")
