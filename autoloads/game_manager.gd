extends Node

var spawn_point_container
var score_ui
var player: Player
var stats_ui

var do_background_parallax: bool = false

func quit_game(_event: InputEvent = null) -> void:
	
	if _event:
		if _event.is_action_pressed("ui_cancel"):
			get_tree().quit()
	else:
		get_tree().quit()

func start_game() -> void:
	
	do_background_parallax = true
	player.global_scale *= 0.6
	player.global_position = OS.window_size / 2	
	get_tree().paused = false
	
func end_game() -> void:
	
	do_background_parallax = false
	get_tree().paused = true
	
func restart_game() -> void:

	for s in spawn_point_container.get_children():
		s.delete_all_enemies()
	do_background_parallax = true
	player.global_position = OS.window_size / 2	
	player.restart()
	score_ui.set_score(0)
	get_tree().paused = false
	