extends Node2D

onready var player_sprite = $Player
onready var enemies = $Enemies
onready var line = $Line2D
onready var indicator: PackedScene = preload("res://core/minimap/Indicator.tscn")
var enemy_indicator_map = {}
signal indicator_deleted(_enemy)

var radius
onready var viewport_size = OS.window_size
onready var radar_rect = $Radar.get_rect().size
func _ready() -> void:	
	
	var p1: Vector2 = line.points[0]
	var p2: Vector2 = line.points[1]
	radius = p1.distance_to(p2) 	
	line.hide()
	
	EnemyManager.connect("enemy_added", self, "on_EnemyManager_enemy_added")
	EnemyManager.connect("enemy_deleted", self, "on_EnemyManager_enemy_deleted")
	connect("indicator_deleted", EnemyManager, "on_Indicator_indicator_deleted")

func _process(delta: float) -> void:
	
	if GameManager.player_exists:
		global_rotation = GameManager.player.velocity_rotation * -1 + deg2rad(90)
		player_sprite.global_rotation = deg2rad(-90)
	
func on_EnemyManager_enemy_added(_enemy) -> void:
	
	create_indicator(_enemy)	
	
func create_indicator(_enemy) -> void:
	
	var new_indicator = indicator.instance()
	new_indicator.assing_enemy(_enemy)
	new_indicator.assing_radius(radius)
	enemies.add_child(new_indicator)	
	enemy_indicator_map[_enemy] = new_indicator

func on_EnemyManager_enemy_deleted(_enemy) -> void:
	
	delete_indicator(_enemy)
	
func delete_indicator(_enemy) -> void:
	
	var indicator = enemy_indicator_map[_enemy]
	indicator.call_deferred("free")
	emit_signal("indicator_deleted", _enemy)


