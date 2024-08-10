extends Node2D


@onready var player: Area2D = $Player
@onready var time_score: Label = $CanvasLayer/TimeScore
@onready var game_over: VBoxContainer = $CanvasLayer/GameOver
@onready var game_over_background: ColorRect = $CanvasLayer/GameOverBackground


var _game_over: bool = false
var _time_score: int = 0


func _ready() -> void:
	game_over.hide()
	game_over_background.hide()
	
	player.position.x = get_viewport_rect().size.x / 2
	player.position.y = get_viewport_rect().size.y - get_viewport_rect().size.y / 10
	
	GameManager.player_hit.connect(_on_player_hit)


func _process(delta: float) -> void:
	if _game_over: 
		if Input.is_key_pressed(KEY_SPACE):
			get_tree().reload_current_scene()
		
		return
 	
	_update_time_score(delta)


func _update_time_score(delta: float) -> void:
	_time_score += int(delta * 1000)
	
	var minutes: int = _time_score / 60000
	var seconds: int = (_time_score % 60000) / 1000
	var milli: int = _time_score % 1000
	
	time_score.text = "%02d:%02d:%03d" % [minutes, seconds, milli]


func _on_player_hit(player: Player, other: Node2D) -> void:
	if !other.is_in_group("obstacle"): return
	
	_game_over = true
	game_over.show()
	game_over_background.show()
	
	GameManager.game_over.emit()
