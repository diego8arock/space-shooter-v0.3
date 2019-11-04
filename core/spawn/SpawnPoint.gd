extends Node2D

onready var container = $EnemyContainer
onready var timer = $Timer
onready var ray = $RayCast2D

var fighter: PackedScene = preload("res://core/characters/enemies/fighter/Fighter.tscn")
var frigate: PackedScene = preload("res://core/characters/enemies/frigate/Frigate.tscn")
var shield: PackedScene = preload("res://core/characters/enemies/shield/Shield.tscn")
var homing: PackedScene = preload("res://core/characters/enemies/homing/Homing.tscn")

enum TIER {ONE, TWO, THREE}
export(TIER) var tier = TIER.ONE

var max_enemies: int
var enemy: PackedScene 

func _ready() -> void:
	
	randomize()
	var angle = rand_range(0.0, 270.0)
	ray.global_rotation_degrees = angle
	angle = rand_range(0.0, 270.0)
	global_rotation_degrees = angle	
	
	match tier:
		TIER.ONE:			
			timer.wait_time = rand_range(4.0, 6.0)
			timer.start()
			max_enemies = 3
			enemy = fighter
		TIER.TWO:
			timer.wait_time = rand_range(4.0, 6.0)
			timer.start()
			max_enemies = 3
			enemy = fighter
	
func _on_Timer_timeout() -> void:

	if container.get_child_count() == max_enemies:
		return

	var new_enemy: Enemy = enemy.instance()
	container.add_child(new_enemy)
	new_enemy.global_position = global_position + Vector2(50, 50)
	new_enemy.global_rotation = ray.global_rotation
	new_enemy.wander_angle = rad2deg(global_rotation)
	new_enemy.global_scale = Vector2(0.5, 0.5)
	new_enemy.location = GameManager.chekpoint_container.get_closest_checkpoint(new_enemy.global_position)
	EnemyManager.add_enemies(new_enemy)
	timer.wait_time = rand_range(4.0, 6.0)
	timer.start()

func delete_all_enemies() -> void:
	
	for c in container.get_children():
		EnemyManager.delete_enemy(c, false)
