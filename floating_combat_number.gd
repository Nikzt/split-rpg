extends RichTextLabel

var damage_amount: int = 0
var damage_type: String = "auto_attack"

func _ready() -> void:
	modulate.a = 0.0

	bbcode_enabled = true
	fit_content = true
	scroll_active = false
	autowrap_mode = TextServer.AUTOWRAP_OFF

	var color_tag = ""
	var color_end = ""
	if damage_type == "ability":
		color_tag = "[color=yellow]"
		color_end = "[/color]"
	text = "[center]" + color_tag + str(damage_amount) + color_end + "[/center]"

	await get_tree().process_frame
	_start_animation()

func _start_animation() -> void:
	position -= size / 2.0
	pivot_offset = size / 2.0
	modulate.a = 1.0

	var p = get_parent()
	var dur = p.animation_duration_seconds

	# Bounce (scale)
	var bounce_start = p.bounce_start_time_relative * dur
	var bounce_end = p.bounce_end_time_relative * dur
	var bounce_dur = bounce_end - bounce_start
	if bounce_dur > 0.0:
		var half = bounce_dur / 2.0
		var tween_bounce = create_tween()
		if bounce_start > 0.0:
			tween_bounce.tween_interval(bounce_start)
		tween_bounce.tween_property(self, "scale", Vector2.ONE * p.bounce_scale, half) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween_bounce.tween_property(self, "scale", Vector2.ONE, half) \
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)

	# Float (position.y)
	var float_start = p.float_start_time_relative * dur
	var float_end = p.float_end_time_relative * dur
	var float_dur = float_end - float_start
	if float_dur > 0.0:
		var tween_float = create_tween()
		if float_start > 0.0:
			tween_float.tween_interval(float_start)
		tween_float.tween_property(self, "position:y", position.y - p.float_distance_px, float_dur) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

	# Fade (modulate.a)
	var fade_start = p.fade_start_time_relative * dur
	var fade_end = p.fade_end_time_relative * dur
	var fade_dur = fade_end - fade_start
	if fade_dur > 0.0:
		var tween_fade = create_tween()
		if fade_start > 0.0:
			tween_fade.tween_interval(fade_start)
		tween_fade.tween_property(self, "modulate:a", 0.0, fade_dur)

	# Self-destruct after full duration
	await get_tree().create_timer(dur).timeout
	queue_free()
