extends CharacterBody2D

var speed = 90.0
var target: Node2D = null
var stop_distance = 70.0
var health = 30

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var aggro_range: Area2D = $AggroRange

func _ready():
	aggro_range.body_entered.connect(_on_aggro_body_entered)
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = stop_distance

func _on_aggro_body_entered(body):
	if body is CharacterBody2D and body != self:
		target = body

func _physics_process(delta):
	if target == null:
		return

	var distance = global_position.distance_to(target.global_position)
	if distance <= stop_distance:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	nav_agent.target_position = target.global_position
	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
