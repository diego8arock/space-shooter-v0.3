extends Node2D

onready var bar = $MarginContainer/TextureProgress

func set_max_value(_max_value: int) -> void:
	
	bar.max_value = _max_value
	bar.value = _max_value
	
func take_damage(_damage: float) -> void:
	
	bar.value -= _damage