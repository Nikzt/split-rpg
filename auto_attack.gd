extends Node

var auto_attack_ready: bool = true

func _process(delta: float) -> void:
	var parent = get_parent()
	if parent.target == null:
		return
	if not is_instance_valid(parent.target):
		parent.target = null
		return
	var distance = parent.global_position.distance_to(parent.target.global_position)
	if distance <= parent.auto_attack_range and auto_attack_ready:
		auto_attack_ready = false
		parent.target.take_damage(parent.attack_power)
		parent.target.handle_is_dead()
		get_tree().create_timer(parent.auto_attack_time_seconds).timeout.connect(_on_cooldown_finished)

func _on_cooldown_finished() -> void:
	auto_attack_ready = true
