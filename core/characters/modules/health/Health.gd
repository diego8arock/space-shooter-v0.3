extends Node

var current_health: float setget set_current_health, get_current_health
var max_health: float setget set_max_health
const MIN_HEALTH: float = 0.0

signal health_depleated()

func set_current_health(_value: float) -> void:
	
	current_health = _value
	
func get_current_health() -> float:
	
	return current_health

func set_max_health(_value: float) -> void:
	
	max_health = _value
	
func set_full_health() -> void:
	
	assert max_health
	current_health = max_health

func take_damage(_damage: float) -> void:
	
	if current_health == MIN_HEALTH:
		return
	
	if current_health > MIN_HEALTH:
		current_health -= _damage
		current_health = clamp(current_health, MIN_HEALTH, max_health)
	
	if current_health <= MIN_HEALTH:
		emit_signal("health_depleated")
	
func regain_health(_health: float) -> void:
	
	if current_health < max_health:
		current_health += _health
		current_health = clamp(current_health, MIN_HEALTH, max_health)
	
	