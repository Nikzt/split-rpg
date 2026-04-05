extends Node
class_name Ability

var ability_name: String = ""
var description: String = ""
var icon: Texture2D = null
var cooldown_time: float = 0.0
var requires_target: bool = false
var ability_range: float = 0.0

var cooldown_remaining: float = 0.0
var is_on_cooldown: bool:
	get:
		return cooldown_remaining > 0.0

func _process(delta: float) -> void:
	if cooldown_remaining > 0.0:
		cooldown_remaining -= delta
		if cooldown_remaining < 0.0:
			cooldown_remaining = 0.0

func can_use(player: Node2D) -> bool:
	if is_on_cooldown:
		return false
	if requires_target:
		if player.target == null:
			return false
		if not is_instance_valid(player.target):
			return false
		var distance = player.global_position.distance_to(player.target.global_position)
		if distance > ability_range:
			return false
	return true

func use(player: Node2D) -> void:
	pass

func start_cooldown() -> void:
	cooldown_remaining = cooldown_time
