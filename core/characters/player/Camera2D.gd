extends Camera2D

const ZOOM_RATE: Vector2 = Vector2(0.5, 0.5)
const MAX_ZOOM: Vector2 =  Vector2(1.4, 1.4)
const NORMAL_ZOOM: Vector2 = Vector2(1, 1)

func _process(delta: float) -> void:
	
	if Input.is_action_pressed("super_speed"):
		if zoom <= MAX_ZOOM:
			zoom += ZOOM_RATE * delta
	else:
		if zoom >= NORMAL_ZOOM:
			zoom -= ZOOM_RATE * delta	
	
