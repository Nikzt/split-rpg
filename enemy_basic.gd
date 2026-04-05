extends CharacterBody2D

signal damage_taken(amount: int, pos: Vector2, damage_type: String)

var floating_number_offset_y: float = -40.0

var speed = 90.0
var target: Node2D = null
var stop_distance = 70.0
var health = 30
var auto_attack_range: float = 70.0
var attack_power: int = 5
var auto_attack_time_seconds: float = 2.0

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var aggro_range: Area2D = $AggroRange

func _ready():
	aggro_range.body_entered.connect(_on_aggro_body_entered)
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = stop_distance

func _on_aggro_body_entered(body):
	if body.is_in_group("player"):
		target = body

func _physics_process(delta):
	if target == null:
		return

	var distance = global_position.distance_to(target.global_position)
	var separation = _get_separation_force()

	if distance <= stop_distance:
		velocity = separation * speed
	else:
		nav_agent.target_position = target.global_position
		var next_pos = nav_agent.get_next_path_position()
		var direction = (next_pos - global_position).normalized()
		velocity = (direction + separation).normalized() * speed

	move_and_slide()

func _get_separation_force() -> Vector2:
	var force = Vector2.ZERO
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy == self:
			continue
		var offset = global_position - enemy.global_position
		var dist = offset.length()
		if dist < stop_distance and dist > 0:
			force += offset.normalized() * (1.0 - dist / stop_distance)
	return force.normalized() if force.length() > 0 else Vector2.ZERO

func get_floating_number_position() -> Vector2:
	return global_position + Vector2(0, floating_number_offset_y)

func take_damage(amount: int, damage_type: String = "auto_attack") -> void:
	health -= amount
	damage_taken.emit(amount, get_floating_number_position(), damage_type)

func handle_is_dead() -> void:
	if health <= 0:
		queue_free()
