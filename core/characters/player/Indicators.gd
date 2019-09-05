extends Node2D

onready var indicator: PackedScene = preload("res://core/characters/player/EnemyIndicator.tscn")
var enemy_indicator_map = {}
signal indicator_deleted(_enemy)

func _ready() -> void:

	EnemyManager.connect("enemy_added", self, "on_EnemyManager_enemy_added")
	EnemyManager.connect("enemy_deleted", self, "on_EnemyManager_enemy_deleted")
	connect("indicator_deleted", EnemyManager, "on_Indicator_indicator_deleted")

func on_EnemyManager_enemy_added(_enemy) -> void:
	
	create_indicator(_enemy)	
	
func create_indicator(_enemy) -> void:
	
	var new_indicator = indicator.instance()
	new_indicator.assing_enemy(_enemy)
	add_child(new_indicator)	
	enemy_indicator_map[_enemy] = new_indicator

func on_EnemyManager_enemy_deleted(_enemy) -> void:
	
	delete_indicator(_enemy)
	
func delete_indicator(_enemy) -> void:
	
	var indicator = enemy_indicator_map[_enemy]
	indicator.call_deferred("free")
	emit_signal("indicator_deleted", _enemy)
	
