extends Node2D

onready var sprite = $Sprite
onready var debug = $Debug

var radius
var enemy: Actor
var out_of_range: float = 4000.0

func _ready() -> void:
	
	sprite.position = Vector2(radius , 0)

func _process(delta: float) -> void:
	
	if GameManager.player_exists and EnemyManager.is_enemy_alive(enemy):				
		var distance = GameManager.player.global_position.distance_to(enemy.global_position)
		if distance <= out_of_range:
			distance = distance / 20
			sprite.position = Vector2(distance , 0)
		else:
			sprite.position = Vector2(radius , 0)
		rotation = GameManager.player.global_position.angle_to_point(enemy.global_position) + deg2rad(90)						
	
func assing_radius(_radius: float) -> void:
	
	radius = _radius	

func assing_enemy(_enemy: Actor) -> void:
	
	enemy = _enemy	