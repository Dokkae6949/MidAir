extends AnimatableBody2D


@export_group("Movement")
## The amount of rotation to the left/right that should be applied
@export var max_rotation_degrees: float = 45.0
@export var rotation_speed: float = 10.0
@export var movement_speed: float = 300.0
## Allows the ship to center the rotation back to 0 when nothing is inputted
@export var allow_rotation_reset: bool = false

@onready var sprite: Sprite2D = $Sprite

var _target_rotation_degrees: float = 0.0


func _process(delta: float) -> void:
	var input = Input.get_axis("player_move_left", "player_move_right");
	
	if input < 0:
		_target_rotation_degrees = -max_rotation_degrees
	elif input > 0:
		_target_rotation_degrees = max_rotation_degrees
	elif allow_rotation_reset:
		_target_rotation_degrees = 0
	
	# TODO: Refactor this to make teleportation smoother
	if position.x < 0.0:
		position.x = get_viewport_rect().size.x
	if position.x > get_viewport_rect().size.x:
		position.x = 0


func _physics_process(delta: float) -> void:
	rotation_degrees = lerpf(rotation_degrees, _target_rotation_degrees, rotation_speed * delta)
	
	# Movement input depends on how much we have rotated compared to the target rotation
	var movement_input = rotation_degrees / max_rotation_degrees
	position.x += movement_input * movement_speed * delta
