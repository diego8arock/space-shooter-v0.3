extends MarginContainer

onready var message = $Message

func set_message(_text: String) -> void:
	
	message.text = _text
