extends Node2D

export var player_path: NodePath
var player

onready var player_sprite = $Player
onready var enemies = $Enemies
onready var line = $Line2D
onready var indicator: PackedScene = preload("res://core/minimap/Indicator.tscn")
var enemy_indicator_map = {}
signal indicator_deleted(_enemy)

var radius
var distance_to_target

func _ready() -> void:
	
	var p1: Vector2 = line.points[0]
	var p2: Vector2 = line.points[1]
	radius = p1.distance_to(p2) 
	#line.hide()
	player = get_node(player_path)
	distance_to_target = get_viewport().size
	
	EnemyManager.connect("enemy_added", self, "on_EnemyManager_enemy_added")
	EnemyManager.connect("enemy_deleted", self, "on_EnemyManager_enemy_deleted")
	connect("indicator_deleted", EnemyManager, "on_Indicator_indicator_deleted")

func _process(delta: float) -> void:
	
	global_rotation = player.velocity_rotation * -1
	player_sprite.global_rotation = deg2rad(-90)
	
func on_EnemyManager_enemy_added(_enemy) -> void:
	
	create_indicator(_enemy)	
	
func create_indicator(_enemy) -> void:
	
	var new_indicator = indicator.instance()
	new_indicator.assing_enemy(_enemy)
	new_indicator.assing_player(player)
	new_indicator.assing_radius(radius)
	new_indicator.assing_distance_to_target(distance_to_target)
	enemies.add_child(new_indicator)	
	enemy_indicator_map[_enemy] = new_indicator

func on_EnemyManager_enemy_deleted(_enemy) -> void:
	
	delete_indicator(_enemy)
	
func delete_indicator(_enemy) -> void:
	
	var indicator = enemy_indicator_map[_enemy]
	indicator.call_deferred("free")
	emit_signal("indicator_deleted", _enemy)


