extends Node2D


@onready var player: AnimatableBody2D = $Player
@onready var time_score: Label = $CanvasLayer/TimeScore

var _time_score: int = 0


func _ready() -> void:
	player.position.x = get_viewport_rect().size.x / 2
	player.position.y = get_viewport_rect().size.y - get_viewport_rect().size.y / 10


func _process(delta: float) -> void:
	_time_score += int(delta * 1000)
	
	var minutes: int = _time_score / 60000
	var seconds: int = (_time_score % 60000) / 1000
	var milli: int = _time_score % 1000
	
	time_score.text = "%02d:%02d:%03d" % [minutes, seconds, milli]
