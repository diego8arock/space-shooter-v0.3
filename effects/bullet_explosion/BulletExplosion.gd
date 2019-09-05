extends Node2D

onready var player = $Sprite/AnimationPlayer


func _ready() -> void:
	player.play("explode")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	call_deferred("free")
