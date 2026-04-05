extends HBoxContainer

var _ability_slot_scene: PackedScene = preload("res://action_bar_ability.tscn")
var _empty_slot_scene: PackedScene = preload("res://action_bar_slot.tscn")

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	var player_abilities = player.get_node("PlayerAbilities")
	for i in range(4):
		var ability = player_abilities.abilities[i]
		if ability != null:
			var slot = _ability_slot_scene.instantiate()
			slot.ability = ability
			add_child(slot)
		else:
			var slot = _empty_slot_scene.instantiate()
			add_child(slot)
