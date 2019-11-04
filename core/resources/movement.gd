extends Resource
class_name Movement

#general properties
export var max_force: float
export var mass: float

#seek properties
export var max_seek_speed: float
export var seek_rotation_speed: float

#pursuit properties
export var max_pursuit_speed: float
export var pursuit_rotation_speed: float

#wander properties
export var max_wander_speed: float
export var cirlce_distance: float
export var circle_radius: float
export var angle_change: float
export var wander_rotation_speed: float

#arrival properties
export var arrival_distance: float
export var arrival_rotation_speed: float
export var max_arrival_speed: float

#evade properties
export var evade_distance: float
export var evade_rotation_speed: float
export var max_evade_speed: float
