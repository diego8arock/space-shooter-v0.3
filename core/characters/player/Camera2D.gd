extends Camera2D

const ZOOM_RATE: Vector2 = Vector2(0.5, 0.5)
const MAX_ZOOM: Vector2 =  Vector2(2.2, 2.2)
const NORMAL_ZOOM: Vector2 = Vector2(1.7, 1.7)
var is_bullet_time_on: bool = false

func _process(delta: float) -> void:
	
	if Input.is_action_pressed("super_speed") and not is_bullet_time_on:
		if zoom <= MAX_ZOOM:
			zoom += ZOOM_RATE * delta
	else:
		if zoom >= NORMAL_ZOOM:
			zoom -= ZOOM_RATE * delta	
	
