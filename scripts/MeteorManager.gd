class_name MeteorManager
extends Node2D


const MOVEMENT_SPEED_MULTIPLIER_META_NAME = "movement_speed_multiplier"

@export var enabled: bool = true
@export_group("Spawning")
@export var meteors: Array[PackedScene]
@export var spawn_distance_min: float = 50.0
@export var spawn_distance_max: float = 120.0
@export_group("Movement")
@export var movement_speed: float = 40.0
@export var movement_speed_multiplier_min = 0.9
@export var movement_speed_multiplier_max = 1.1
## How much the movement_speed should be increased per second
@export var movement_speed_increase: float = 5.0
@export var movement_direction: Vector2 = Vector2.DOWN

var _spawn_distance: float = 0.0


func _ready() -> void:
	SignalBus.player_hit.connect(_on_player_hit)
	SignalBus.game_over.connect(_on_game_over)


func _process(delta: float) -> void:
	if !enabled: return
	
	if _spawn_distance <= 0.0:
		_spawn_distance = randf_range(spawn_distance_min, spawn_distance_max)
		
		if meteors.size() == 0:
			return
		
		var meteor_scene = meteors.pick_random()
		var meteor: CollisionObject2D = meteor_scene.instantiate()
		add_child(meteor)
		meteor.position = Vector2(randf_range(0, get_viewport_rect().size.x), 0)
		meteor.rotation_degrees = randf_range(-180, 180)
		meteor.set_meta(MOVEMENT_SPEED_MULTIPLIER_META_NAME, randf_range(movement_speed_multiplier_min, movement_speed_multiplier_max))

func _physics_process(delta: float) -> void:
	if !enabled: return
	
	var movement = movement_direction * movement_speed * delta
	
	for child: CollisionObject2D in get_children():
		child.position += movement * child.get_meta(MOVEMENT_SPEED_MULTIPLIER_META_NAME, 1.0)
		if child.position.y >= get_viewport_rect().size.y + 50:
			child.queue_free()
	
	movement_speed += movement_speed_increase * delta
	_spawn_distance -= movement_speed * delta


func _on_player_hit(player: Player, other: Node2D) -> void:
	pass

func _on_game_over() -> void:
	enabled = false
