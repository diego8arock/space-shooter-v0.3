extends Node

var enemies = {}
signal enemy_added(enemy)
signal enemy_deleted(enemy)

func add_enemies(_enemy) -> void:
	enemies[_enemy] = true
	emit_signal("enemy_added", _enemy)
	
func is_enemy_alive(_enemy) -> bool:
	return enemies[_enemy]
	
func delete_enemy(_enemy, add_points: bool = true) -> void:
	enemies[_enemy] = false
	emit_signal("enemy_deleted", _enemy)
	if add_points:
		GameManager.score_ui.add_score(_enemy.points)

func on_Indicator_indicator_deleted(_enemy) -> void:
	enemies.erase(_enemy)
	_enemy.call_deferred("free")
	
	