extends Node

var abilities: Array = [null, null, null, null]
var gcd_remaining: float = 0.0
var gcd_time: float = 1.0

var _fireball_scene: PackedScene = preload("res://fireball.tscn")
var _whirlwind_scene: PackedScene = preload("res://whirlwind.tscn")

func _ready() -> void:
	var fireball = _fireball_scene.instantiate()
	add_child(fireball)
	abilities[0] = fireball

	var whirlwind = _whirlwind_scene.instantiate()
	add_child(whirlwind)
	abilities[1] = whirlwind

func _process(delta: float) -> void:
	if gcd_remaining > 0.0:
		gcd_remaining -= delta
		if gcd_remaining < 0.0:
			gcd_remaining = 0.0

func _unhandled_input(event: InputEvent) -> void:
	for i in range(4):
		var action_name = "action_button_" + str(i + 1)
		if event.is_action_pressed(action_name):
			_try_use_ability(i)
			return

func _try_use_ability(slot: int) -> void:
	var ability = abilities[slot]
	if ability == null:
		return
	if gcd_remaining > 0.0:
		return
	var player = get_parent()
	if not ability.can_use(player):
		return
	ability.use(player)
	gcd_remaining = gcd_time
