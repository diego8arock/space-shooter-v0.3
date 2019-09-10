extends Node

onready var power_up: PackedScene = preload("res://core/power_ups/PowerUp.tscn")

onready var helath
onready var shotgun
onready var rapid_fire
onready var heatseeking

enum POWER_UP { HEALTH, SHOTGUN, RAPID_FIRE, HEATSEEKING, EMPTY }
var weights = { POWER_UP.HEALTH:0.1, POWER_UP.SHOTGUN:0.3, POWER_UP.RAPID_FIRE:0.3, POWER_UP.HEATSEEKING:0.15, POWER_UP.EMPTY: 0.8 }
var sum_of_weights: float = 0.0
var power_up_container

func _ready() -> void:
	
	Event.connect("enemy_destroyed", self, "on_Event_enemy_destroyed")
	for w in weights:
		sum_of_weights += weights[w]

func on_Event_enemy_destroyed(_enemy_position: Vector2) -> void:
	
	call_deferred("generate_power_up", _enemy_position)

func generate_power_up(_enemy_position: Vector2) -> void:
	
	randomize()
	var type = select_power_up_by_weight()
	
	if type == POWER_UP.EMPTY:
		return
			
	var new_power_up = power_up.instance()
	power_up_container.add_child(new_power_up)
	new_power_up.set_type(type)
	new_power_up.set_icon()
	new_power_up.set_initial_position(_enemy_position)
	new_power_up.eject_power_up()
	
func select_power_up_by_weight() -> int:
		
	var random_weight = rand_range(0.0, sum_of_weights)
	for w in weights:
		random_weight = random_weight - weights[w]
		if random_weight <= 0:
			return w
	return POWER_UP.EMPTY

	