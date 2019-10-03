extends Area2D

onready var timer = $TimerColorChange
onready var anim_player = $AnimationPlayer
enum STATE { STABLE, CHANGING }
var state = STATE.STABLE
enum COLOR {GREEN, BLUE}
var color = COLOR.BLUE

func _ready() -> void:
	
	timer.start()

func _physics_process(delta: float) -> void:
	
	rotation_degrees += 90.0 * delta;

func _on_ShieldField_area_entered(area: Area2D) -> void:
	
	if color == COLOR.BLUE:
		randomize()
		var direction = 1 if randi() % 2 == 0 else -1
		area.global_rotation += deg2rad(135 * direction)
		area.velocity = area.velocity.rotated(deg2rad(135 * direction))

func _on_TimerColorChange_timeout() -> void:
	
	state = STATE.CHANGING
	var animation = "change_to_green" if color == COLOR.BLUE else "change_to_blue"
	anim_player.play(animation)

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	
	color = COLOR.GREEN if color == COLOR.BLUE else COLOR.BLUE;
	timer.start()
