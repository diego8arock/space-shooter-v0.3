extends Node2D

var turrets = []

func _ready() -> void:
	
	turrets = get_children()

func set_damage(_damage: float) -> void:
	
	for t in turrets:		
		t.damage = _damage
	
func attack_player(_player) -> void:
	
	var attack_distances = {}
	var distances = []
	for t in turrets:
		var dist = t.global_position.distance_to(_player.global_position)
		distances.push_back(dist)
		attack_distances[dist] = t
	
	distances.sort()
	
	for d in distances:
		attack_distances[d].attack_player(_player)
		yield(get_tree().create_timer(1.0), "timeout")	
	
func stop_attack() -> void:
	
	for t in turrets:	
		t.stop_attack()
