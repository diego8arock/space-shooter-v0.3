extends KinematicBody2D
class_name Actor

#resouces
export var movement: Resource
export var data: Resource

#nodes
var health: Health

#core data
var collision_damage: float

#sounds
onready var death_explosion = preload("res://assets/sounds/explosions/explosion1.ogg")
var audio: AudioStreamPlayer2D

#override this method
func take_damage(_damage: float) -> void:
	#If assert then method was not overriden
	assert(false)
