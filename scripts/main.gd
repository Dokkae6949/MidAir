extends Node2D


@onready var player: AnimatableBody2D = $Player


func _ready() -> void:
	player.position.x = get_viewport_rect().size.x / 2
	player.position.y = get_viewport_rect().size.y - get_viewport_rect().size.y / 10
