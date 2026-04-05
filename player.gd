extends CharacterBody2D

var speed = 200.0
var health = 100
var target: Node2D = null
var potential_targets: Array[Node2D] = []
var targeting_range_in_px: float = 500.0
var auto_attack_range: float = 100.0
var attack_power: int = 10
var auto_attack_time_seconds: float = 1.5
var _prev_target_list_empty: bool = true

func _physics_process(delta):
	var input = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_pressed("ui_right"):
		input.x += 1
	if Input.is_action_pressed("ui_up"):
		input.y -= 1
	if Input.is_action_pressed("ui_down"):
		input.y += 1

	velocity = input.normalized() * speed
	move_and_slide()

func _process(delta):
	update_target_list()
	handle_auto_target()

func _unhandled_input(event):
	if event.is_action_pressed("ui_target"):
		cycle_target()

func update_target_list():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		var dist = global_position.distance_to(enemy.global_position)
		var in_list = potential_targets.has(enemy)
		if dist <= targeting_range_in_px and not in_list:
			potential_targets.append(enemy)
		elif dist > targeting_range_in_px and in_list:
			potential_targets.erase(enemy)
	# Remove freed/invalid nodes
	potential_targets = potential_targets.filter(func(e): return is_instance_valid(e))

func handle_auto_target():
	var is_empty = potential_targets.is_empty()

	if _prev_target_list_empty and not is_empty:
		target = potential_targets[0]
	elif not _prev_target_list_empty and is_empty:
		target = null

	_prev_target_list_empty = is_empty

	# Ensure current target is still valid
	if target != null and not potential_targets.has(target):
		if potential_targets.is_empty():
			target = null
		else:
			target = potential_targets[0]
			
	if target == null and potential_targets.size() > 0:
		target = potential_targets[0];

func cycle_target():
	if potential_targets.is_empty():
		return
	if target == null or not potential_targets.has(target):
		target = potential_targets[0]
		return
	var current_index = potential_targets.find(target)
	var next_index = (current_index + 1) % potential_targets.size()
	target = potential_targets[next_index]

func take_damage(amount: int, damage_type: String = "auto_attack") -> void:
	health -= amount

func handle_is_dead() -> void:
	if health <= 0:
		queue_free()
