extends Node2D

onready var stats_screen = $CanvasLayer/Stats
onready var score_screen = $CanvasLayer/Score
onready var minimap = $CanvasLayer/Minimap
onready var start_screen = $CanvasLayer/StartScreen
onready var game_over_screen = $CanvasLayer/GameOverScreen
onready var message_screen = $CanvasLayer/MessageScreen
onready var player: PackedScene = preload("res://core/characters/player/Player.tscn")

func _ready() -> void:
	
	before_new_game()	

func _unhandled_key_input(event: InputEventKey) -> void:
	
	GameManager.quit_game(event)

func _on_Event_player_died() -> void:
	
	end_game()

func _on_StartScreen_start_button_pressed() -> void:
	
	start_new_game()

func _on_StartScreen_exit_button_pressed() -> void:
	
	GameManager.quit_game()

func _on_GameOverScreen_exit_button_pressed() -> void:
	
	GameManager.quit_game()

func _on_GameOverScreen_restart_button_pressed() -> void:
	
	restart_game()
	
func on_Event_message_sent(_text: String) -> void:
	
	message_screen.set_message(_text)
	message_screen.show()
	yield(get_tree().create_timer(3.0), "timeout")
	message_screen.hide()
	
func add_player_to_game() -> void:
	
	GameManager.player = player.instance()
	GameManager.player_exists = true
	add_child(GameManager.player)
	Event.connect("player_died", self, "_on_Event_player_died")

func before_new_game() -> void:
	
	start_screen.show()
	game_over_screen.hide()
	score_screen.hide()
	stats_screen.hide()
	minimap.hide()
	message_screen.hide()
	get_tree().paused = true
	Event.connect("message_sent", self, "on_Event_message_sent")
	
func start_new_game() -> void:
		
	add_player_to_game()
	GameManager.stats_ui = stats_screen
	GameManager.spawn_point_container = $SpawnPointContainer
	GameManager.start_game()
	start_screen.hide()
	score_screen.show()
	stats_screen.show()
	minimap.show()
	
func end_game() -> void:
	
	yield(get_tree().create_timer(1.0), "timeout")
	game_over_screen.set_score(GameManager.score_ui.score)
	game_over_screen.show()
	GameManager.end_game()	

func restart_game() -> void:
	
	game_over_screen.hide()
	GameManager.restart_game()