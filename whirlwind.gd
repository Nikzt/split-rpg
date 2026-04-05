extends Ability

func _ready() -> void:
	ability_name = "Whirlwind"
	description = "Damages all nearby enemies."
	icon = preload("res://assets/icons/ability_icon_whirlwind.png")
	cooldown_time = 4.0
	requires_target = false
	ability_range = 100.0

func use(player: Node2D) -> void:
	var damage = player.attack_power / 2
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		var distance = player.global_position.distance_to(enemy.global_position)
		if distance <= ability_range:
			enemy.take_damage(damage, "ability")
			enemy.handle_is_dead()
	start_cooldown()
