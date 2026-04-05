extends Control

var ability: Node = null

@onready var icon: TextureRect = $Icon
@onready var border: TextureRect = $Border
@onready var label: Label = $Label

func _ready() -> void:
	if ability != null and ability.icon != null:
		icon.texture = ability.icon

func _process(_delta: float) -> void:
	if ability == null:
		return
	if ability.cooldown_remaining > 0.0:
		label.text = "%.1f" % ability.cooldown_remaining
	else:
		label.text = ""
	if ability.cooldown_remaining > 0.0:
		icon.modulate = Color(0.4, 0.4, 0.4, 1.0)      # darkened
		border.modulate = Color(0.6, 0.6, 0.6, 1.0)     # slightly dimmed
	else:
		icon.modulate = Color(1.0, 1.0, 1.0, 1.0)       # full brightness
		border.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
