extends Node2D

onready var sprite = $Sprite
onready var debug = $Debug

var radius
var distance_scaled
var player: Actor
var enemy: Actor
var size_to_scale: float = 5.0
var radius_fit: float =  0.7
var distance_to_target: Vector2
var distance
var is_enemy_on_screen: bool = false
var angle_to
var angle_to_local
var out_of_range: float = 2000.0
var to_global_position
var to_local_position

func _ready() -> void:
	
	sprite.position = Vector2(radius , 0)

func _process(delta: float) -> void:
	
	if EnemyManager.is_enemy_alive(enemy):		
		rotation = player.global_position.angle_to_point(enemy.global_position) + deg2rad(90)
		if player.global_position.distance_to(enemy.global_position) <= out_of_range:
			position = enemy.global_position / 0.5 / 100	
			
					
	
func assing_radius(_radius: float) -> void:
	
	radius = _radius	

func assing_player(_player: Actor) -> void:
	
	player = _player

func assing_enemy(_enemy: Actor) -> void:
	
	enemy = _enemy	
	enemy.connect("screen_entered", self, "on_Enemy_screen_entered")
	enemy.connect("screen_exited", self, "on_Enemy_screen_exited")	

func assing_distance_to_target(_distance: Vector2) -> void:
	
	distance_to_target = _distance

func on_Enemy_screen_entered() -> void:
	
	is_enemy_on_screen = true	
		
func on_Enemy_screen_exited() -> void:
	
	is_enemy_on_screen = false