extends Node2D

@export var animation_duration_seconds: float = 1
@export var bounce_scale: float = 1.3
@export var bounce_start_time_relative: float = 0.0
@export var bounce_end_time_relative: float = 0.3
@export var float_start_time_relative: float = 0.1
@export var float_end_time_relative: float = 1.0
@export var float_distance_px: float = 40.0
@export var fade_start_time_relative: float = 0.5
@export var fade_end_time_relative: float = 1.0

var _number_scene: PackedScene = preload("res://floating_combat_number.tscn")

func _ready() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		_connect_enemy(enemy)
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node: Node) -> void:
	if node.is_in_group("enemies"):
		_connect_enemy(node)

func _connect_enemy(enemy: Node) -> void:
	if enemy.has_signal("damage_taken") and not enemy.damage_taken.is_connected(_on_damage_taken):
		enemy.damage_taken.connect(_on_damage_taken)

func _on_damage_taken(amount: int, pos: Vector2, damage_type: String = "auto_attack") -> void:
	var number = _number_scene.instantiate()
	number.damage_amount = amount
	number.damage_type = damage_type
	number.global_position = pos
	add_child(number)
