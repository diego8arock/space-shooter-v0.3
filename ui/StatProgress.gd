extends HBoxContainer

onready var progress = $TextureProgress

func set_progress(_value: float) -> void:
	
	progress.value = _value
