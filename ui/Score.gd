extends MarginContainer

onready var label = $VBoxContainer/Label
var score: int = 0

func _ready() -> void:
	
	GameManager.score_ui = self
	label.text = str(score)
	
func add_score(_add: int) -> void:
	
	score += _add	
	label.text = str(score)
	
func set_score(_score: int) -> void:
	
	score = _score
	label.text = str(score)
