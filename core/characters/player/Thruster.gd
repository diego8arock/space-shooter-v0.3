
extends Node2D

onready var particles = $CPUParticles2D
export var life_time: float = 2.0
export var initial_vel: float = 25.0

func set_life_time(_lifetime: float) -> void:
	
	particles.lifetime = _lifetime
	
func set_initial_velocity(_initial_velocity: float) -> void:
	
	particles.initial_velocity = _initial_velocity
