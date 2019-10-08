extends Node2D

var checkpoint: PackedScene = preload("res://core/locations/player_checkpoint/Checkpoint.tscn")

onready var game_center: Vector2 = OS.window_size / 2	
export var first_line_radius: float = 2000.0
export var second_line_radius: float = 5000.0
export var third_line_radius: float = 9000.0

func _ready() -> void:
	
	GameManager.chekpoint_container = self
	global_position = OS.window_size / 2	
	create_checkpoints(first_line_radius, 4, 1)
	create_checkpoints(second_line_radius, 8, 2)
	create_checkpoints(third_line_radius, 15, 3)	
	
func create_checkpoints(_raidius:float, _count: int, _level: int) -> void:
		
	var rotate_phi: float = deg2rad(360.0 / _count)	
	var current_rotate: float = 0.0
	
	for i in _count:
		var new_checkpoint = checkpoint.instance()
		add_child(new_checkpoint)
		new_checkpoint.global_position += Vector2(0, - _raidius).rotated(current_rotate)
		new_checkpoint.level = _level
		current_rotate += rotate_phi

func get_all_checkpoints() -> Array:
	
	return get_children()
	
func get_furthest_distance_checkpoints() -> Array:
	
	var ckp = []
	var distance: float = 0.0
	for c in get_children():
		var d = global_position.distance_to(c.global_position)
		distance = d if d > distance else distance
	for c in get_children():
		var d = global_position.distance_to(c.global_position)
		if d >= distance:
			ckp.push_back(c)
	return ckp

func get_checkpoints_by_level(_level: int) -> Array:
	
	var ckp = []	
	for c in get_children():
		if c.level == _level:
			ckp.push_back(c)			
	return ckp
	
func get_closest_checkpoint(_position: Vector2) -> Node2D:
	
	var distance: float = 100000.0
	var checkpoint
	for c in get_children():
		var d = _position.distance_to(c.global_position)
		if d < distance:
			checkpoint = c
			distance = d
	return checkpoint
										
