extends MarginContainer


func set_progress(_value: float) -> void:
	
	$VBoxContainer/HBoxContainer/TextureProgress.value = _value
