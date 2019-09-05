extends MarginContainer

signal start_button_pressed()
signal exit_button_pressed()

func _on_Start_pressed() -> void:
	
	emit_signal("start_button_pressed")

func _on_Exit_pressed() -> void:
	
	emit_signal("exit_button_pressed")
