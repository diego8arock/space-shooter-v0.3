extends VBoxContainer

onready var debug_info = preload("res://debug/DebugInfo.tscn")

func _ready() -> void:
	
	Debug.debug = self

func debug_add_label(_name: String) -> Node:
	
	var label = debug_info.instance()
	label.set_name_label(_name)
	add_child(label)
	return label
	
func debug_delete_label(_name: String) -> void:
	
	for c in get_children():
		if c.name_label.text == _name:
			remove_child(c)
			return
	