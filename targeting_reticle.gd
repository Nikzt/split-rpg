extends Node2D

func _process(delta):
  var player = get_tree().get_first_node_in_group("player")
  visible = player != null and player.target == get_parent()

func _draw():
  draw_arc(Vector2.ZERO, 40, 0, TAU, 64, Color.RED, 2.0)
