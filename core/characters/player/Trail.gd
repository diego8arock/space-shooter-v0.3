extends Line2D

onready var target = get_parent()
var trail_length = 10
var point

func _ready() -> void:
	
	set_as_toplevel(true)

func _process(delta: float) -> void:
	
	point = to_local(target.global_position)
	add_point(point)
	while get_point_count() > trail_length:
		remove_point(0)
	