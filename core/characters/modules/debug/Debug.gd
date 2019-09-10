extends Node

export var enabled: bool = true
onready var parent = get_parent()
var properties = {}
var node_properties = {}

func add_property(_name: String, _node: Node = null) -> void:
	
	if enabled:
		if _node:
			var l = Debug.add(parent.name + str(parent.get_instance_id()) + "-" + _node.name + " " + _name)
			node_properties[_node.name + "-" +  _name] = l
		else:
			var l = Debug.add(parent.name + str(parent.get_instance_id()) + " " + _name)
			properties[_name] = l
			
func delete_property(_name: String, _node: Node = null) -> void:
	
	if enabled:
		if _node:
			var name_label = parent.name + str(parent.get_instance_id()) + "-" + _node.name + " " + _name
			Debug.delete(name_label)
			node_properties.erase(_node.name + "-" +  _name)
		else:
			var name_label = parent.name + str(parent.get_instance_id()) + " " + _name
			Debug.delete(name_label)
			properties.erase(name_label)
			
func delete_all_properties() -> void:
	
	if enabled:
		for n in node_properties:
			Debug.delete(parent.name + str(parent.get_instance_id()) + "-" + n)
		for p in properties:
			Debug.delete(parent.name + str(parent.get_instance_id()) + " " + p)
	
func _process(delta: float) -> void:
	
	if enabled:
		for p in properties:
			var l = properties[p]
			l.update_data(str(parent.get(p)))
			
		for n in node_properties:
			var subj = n.split("-")
			var node = get_parent().get_node(subj[0])
			var l = node_properties[n]
			l.update_data(str(node.get(subj[1])))
		
