extends Ability

func _ready() -> void:
	ability_name = "Fireball"
	description = "Hurls a ball of fire at the target."
	icon = preload("res://assets/icons/ability_icon_fireball.png")
	cooldown_time = 10.0
	requires_target = true
	ability_range = 400.0

func use(player: Node2D) -> void:
	var damage = player.attack_power * 2
	player.target.take_damage(damage, "ability")
	player.target.handle_is_dead()
	start_cooldown()
