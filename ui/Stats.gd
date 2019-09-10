extends MarginContainer


func set_health(_value: float) -> void:
	
	$VBoxContainer/Life.set_progress(_value)

func set_energy(_value: float) -> void:
	
	$VBoxContainer/Energy.set_progress(_value)
