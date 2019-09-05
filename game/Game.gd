extends Node2D
onready var sprite = $ParallaxBackground/ParallaxLayer/Sprite
onready var parallax_layer = $ParallaxBackground/ParallaxLayer
onready var paralax_bg = $ParallaxBackground
onready var start_screen = $CanvasLayer/StartScreen
onready var game_over_screen = $CanvasLayer/GameOverScreen
export var player_path: NodePath
var player
var scroll = Vector2(0,3) 

func _ready() -> void:
	
	game_over_screen.hide()
	parallax_layer.motion_mirroring = sprite.texture.get_size().rotated(sprite.global_rotation)
	player = get_node(player_path)
	GameManager.spawn_point_container = $SpawnPointContainer
	get_tree().paused = true

func _process(delta: float) -> void:	
	
	if player != null:
    	scroll += player.velocity / 200
	paralax_bg.scroll_offset += scroll

func _unhandled_key_input(event: InputEventKey) -> void:
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_Player_player_died() -> void:
	
	yield(get_tree().create_timer(1.0), "timeout")
	game_over_screen.set_score(GameManager.score_ui.score)
	game_over_screen.show()
	get_tree().paused = true

func _on_StartScreen_start_button_pressed() -> void:
	
	start_screen.hide()
	get_tree().paused = false

func _on_StartScreen_exit_button_pressed() -> void:
	
	get_tree().quit()

func _on_GameOverScreen_exit_button_pressed() -> void:
	
	get_tree().quit()

func _on_GameOverScreen_restart_button_pressed() -> void:
	
	for s in $SpawnPointContainer.get_children():
		s.delete_all_enemies()
	game_over_screen.hide()
	player.restart()	
	GameManager.score_ui.set_score(0)
	get_tree().paused = false
