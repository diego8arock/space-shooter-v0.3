extends Node2D

var enemy
var sprite_scale
onready var sprite = $Sprite

func _ready() -> void:

	sprite_scale = sprite.global_scale

func _process(delta: float) -> void:
	
	if EnemyManager.is_enemy_alive(enemy):		
		look_at(enemy.global_position)
		var distance = global_position.distance_to(enemy.global_position)
		sprite.global_scale = clamp_scale(sprite_scale / (distance / 1250))
		
func assing_enemy(_enemy) -> void:
	
	enemy = _enemy	
	enemy.connect("screen_entered", self, "on_Enemy_screen_entered")
	enemy.connect("screen_exited", self, "on_Enemy_screen_exited")	

func clamp_scale(_scale: Vector2) -> Vector2:
	
	if _scale < sprite_scale:
		return sprite_scale
	else:
		return _scale
		
func on_Enemy_screen_entered() -> void:
	
	hide()		
		
func on_Enemy_screen_exited() -> void:
	
	show()

	
	
