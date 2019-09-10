extends Node

var debug

func add(_name: String) -> Node:
	return debug.debug_add_label(_name)
	
func delete(_name: String) -> void:
	debug.debug_delete_label(_name)