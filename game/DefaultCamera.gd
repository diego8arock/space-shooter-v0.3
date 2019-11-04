extends Camera2D

var camera_speed: float = 25.0
const ZOOM_RATE: Vector2 = Vector2(0.5, 0.5)
const MAX_ZOOM: Vector2 =  Vector2(5.0, 5.0)
const NORMAL_ZOOM: Vector2 = Vector2(1.0, 1.0)

func _process(delta: float) -> void:
	
	if not GameManager.player_exists:		
		if Input.is_action_pressed("ui_left"):
			global_position.x -= camera_speed
		if Input.is_action_pressed("ui_right"):
			global_position.x += camera_speed
		if Input.is_action_pressed("ui_down"):
			global_position.y += camera_speed
		if Input.is_action_pressed("ui_up"):
			global_position.y -= camera_speed
		if Input.is_action_pressed("zoom_out"):
			if zoom <= MAX_ZOOM:
				zoom += ZOOM_RATE * delta
		if Input.is_action_pressed("zoom_in"):
			if zoom >= NORMAL_ZOOM:
				zoom -= ZOOM_RATE * delta	
			
func _input(event: InputEvent) -> void:
	
	if not GameManager.player_exists:	
		if Input.is_action_pressed("snap_on_enemy"):
			var enemies = EnemyManager.get_all_enemies()
			if enemies.size() >= 1:
				var e = enemies[0]
				global_position = e.global_position