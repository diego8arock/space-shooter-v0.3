extends Node2D

onready var anim_player = $AnimationPlayer

func _ready() -> void:
	
	randomize()
	global_rotation += deg2rad(rand_range(90, 360))
	anim_player.play("explode")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	
	anim_player.stop(false)
	call_deferred("free")
