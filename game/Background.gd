extends ParallaxBackground

onready var sprite = $ParallaxLayer/Sprite
onready var parallax_layer = $ParallaxLayer
var scroll = Vector2(0,3) 

func _ready() -> void:
	
	parallax_layer.motion_mirroring = sprite.texture.get_size().rotated(sprite.global_rotation)

func _process(delta: float) -> void:	
	
	if GameManager.do_background_parallax:
		scroll += GameManager.player.velocity / 200
		scroll_offset += scroll