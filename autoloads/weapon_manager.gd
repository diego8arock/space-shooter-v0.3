extends Node

var small_explosion: PackedScene = preload("res://effects/small_explosion/SmallExplosion.tscn")
var big_explosion: PackedScene = preload("res://effects/big_explosion/BigExplosion.tscn")

var weapon_container: Node2D

func add(_weapon) -> void:
	weapon_container.call_deferred("add_child", _weapon)
	
func show_explosion(_explosion, _position, _scale) -> void:
	
	weapon_container.add_child(_explosion)
	_explosion.global_position = _position
	_explosion.global_scale = _scale
	
func show_small_explosion(_position: Vector2, _scale: Vector2) -> void:
	
	var new_explosion = small_explosion.instance()
	new_explosion.global_position = _position
	new_explosion.global_scale = _scale
	weapon_container.add_child(new_explosion)
	
func show_big_explosion(_position: Vector2, _scale: Vector2) -> void:
	
	var new_explosion = big_explosion.instance()
	new_explosion.global_position = _position
	new_explosion.global_scale = _scale
	weapon_container.add_child(new_explosion)
	