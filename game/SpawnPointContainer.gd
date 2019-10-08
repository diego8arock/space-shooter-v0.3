extends Node2D

var spawn_point: PackedScene = preload("res://core/spawn/SpawnPoint.tscn")

func _ready() -> void:
	
	global_position = OS.window_size / 2
	generate_spawn_point()


func generate_spawn_point() -> void:
	
	var ckps = []
	ckps = GameManager.chekpoint_container.get_furthest_distance_checkpoints()
	randomize()
	var ckp = ckps[randi() % ckps.size()]
	var new_sp = spawn_point.instance()
	add_child(new_sp)
	new_sp.global_position = calculate_position(ckp)
	
	
func calculate_position(_ckp: Node2D) -> Vector2:
	
	var new_position: Vector2 = _ckp.global_position
	if new_position.x < 0:
		new_position.x -= 2000
	else:
		new_position.x += 2000
	if new_position.y < 0:
		new_position.y -= 2000
	else:
		new_position.y += 2000	
	return new_position
	
		

		