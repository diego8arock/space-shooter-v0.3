extends MarginContainer

signal restart_button_pressed()
signal exit_button_pressed()

func set_score(_score: float) -> void:
	
	$VBoxContainer/Score.text = "SCORE " + str(_score)

func _on_Restart_pressed() -> void:
	
	emit_signal("restart_button_pressed")

func _on_Exit_pressed() -> void:
	
	emit_signal("exit_button_pressed")
