extends Node


## Triggered when the time scale changes.
## Provides the old and new time scale.
signal time_scale_changed(old: float, new: float)
## Custom time scale meant to be used on everything
## that is supposed to be affected by in game slow down effects.
@export var time_scale: float = Engine.time_scale :
	set(value):
		var old: float = time_scale
		time_scale = value
		time_scale_changed.emit(value, old)

## Triggered when the player gets hit.
signal player_hit(player: Player, other: Node2D)
## Reference to the player or if no player is present null.
@export var player: Player = null

## Triggered when the game ended.
signal game_over()
