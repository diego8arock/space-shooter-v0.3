extends Node

var speed_state: float
const NORMAL: float = 1.0
const SLOWDOWN: float = 2.0

func _ready() -> void:
	
	normal()
	Event.connect("normal_time", self, "on_Event_normal_time")
	Event.connect("slow_down_time", self, "on_Event_slow_down_time")
	
func on_Event_slow_down_time() -> void:
	
	slow_down()
	
func on_Event_normal_time() -> void:
	
	normal()
	
func normal() -> void:
	
	speed_state = NORMAL
	
func slow_down() -> void:
	
	speed_state = SLOWDOWN

func adjust_speed(_speed: float) -> float:
	
	return _speed / speed_state
