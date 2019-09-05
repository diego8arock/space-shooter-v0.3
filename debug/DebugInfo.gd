extends HBoxContainer

onready var name_label = $Name
onready var data_label = $Data

func _ready() -> void:
	pass

func set_name_label(_text: String) -> void:
	$Name.text = _text
	
func update_data(_text: String) -> void:
	$Data.text = _text