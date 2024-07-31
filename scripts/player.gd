class_name Player
extends Area2D


@export var enabled: bool = true
@export var rotated_textures: Array[RotatedTexture]
@export_group("Movement")
## The amount of rotation to the left/right that should be applied
@export var max_rotation_degrees: float = 45.0
@export var rotation_speed: float = 10.0
@export var movement_speed: float = 300.0
## Allows the ship to center the rotation back to 0 when nothing is inputted
@export var allow_rotation_reset: bool = false

@onready var sprite: Sprite2D = $Sprite
@onready var collider: CollisionPolygon2D = $CollisionPolygon2D

var _target_rotation_degrees: float = 0.0
var _rotation_degrees: float = 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	SignalBus.game_over.connect(_on_game_over)


func _process(delta: float) -> void:
	if !enabled: return
	
	var input = Input.get_axis("player_move_left", "player_move_right");
	
	if input < 0:
		_target_rotation_degrees = -max_rotation_degrees
	elif input > 0:
		_target_rotation_degrees = max_rotation_degrees
	elif allow_rotation_reset:
		_target_rotation_degrees = 0
	
	_update_sprite()


func _physics_process(delta: float) -> void:
	if !enabled: return
	
	_rotation_degrees = lerpf(_rotation_degrees, _target_rotation_degrees, rotation_speed * delta)
	
	# Movement input depends on how much we have rotated compared to the target rotation
	var movement_input = _rotation_degrees / max_rotation_degrees
	position.x += movement_input * movement_speed * delta
	
	_handle_bounds()


# TODO: Refactor this to make teleportation smoother
func _handle_bounds() -> void:
	if position.x < 0.0:
		position.x = get_viewport_rect().size.x
	if position.x > get_viewport_rect().size.x:
		position.x = 0


func _update_sprite() -> void:
	var closest_distance: float = INF
	var closest: RotatedTexture
	for rotated_texture in rotated_textures:
		var distance = abs(rotated_texture.rotation_target - _rotation_degrees)
		if distance < closest_distance:
			closest_distance = distance
			closest = rotated_texture
	if sprite.texture != closest.texture:
		sprite.texture = closest.texture
		sprite.position = closest.texture_offset
		collider.rotation_degrees = closest.rotation_target


func _on_body_entered(body: Node2D) -> void:
	SignalBus.player_hit.emit(self, body)

func _on_area_entered(body: Node2D) -> void:
	SignalBus.player_hit.emit(self, body)

func _on_game_over() -> void:
	enabled = false
