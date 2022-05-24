extends ScrollContainer


export(NodePath) onready var container = get_node(container) as Control

var initial_touch


func _ready():
# warning-ignore:return_value_discarded
	connect("scroll_ended", self, "_on_ScrollContainer_scroll_ended")


func _input(event):
	if event is InputEventScreenTouch:
		if !event.pressed:
			initial_touch = null
	if event is InputEventScreenDrag:
		if !initial_touch:
			initial_touch = event.position
		
		var distance: Vector2 = (initial_touch - event.position).abs()
		
		# For horizontal scrolling
		if get_h_scrollbar().visible:
			if scroll_horizontal == 0:
				container.rect_pivot_offset.x = 0
			elif scroll_horizontal == int(container.rect_size.x - rect_size.x):
				container.rect_pivot_offset.x = container.rect_size.x
			else:
				return
			container.rect_scale.x = clamp(easeOutQuad(distance.x*0.00001) + 1, 1, 1.03)
		
		# For vertical scrolling
		if get_v_scrollbar().visible:
			if scroll_vertical == 0:
				container.rect_pivot_offset.y = 0
			elif scroll_vertical == int(container.rect_size.y - rect_size.y):
				container.rect_pivot_offset.y = container.rect_size.y
			else:
				return
			container.rect_scale.y = clamp(easeOutQuad(distance.y*0.00001) + 1, 1, 1.03)


func easeOutQuad(x: float) -> float:
	# From https://easings.net/#easeOutQuad
	# The variable x represents the absolute progress of the animation in the
	# bounds of 0 (beginning of the animation) and 1 (end of animation).
	return 1 - (1 - x) * (1 - x)


func _on_ScrollContainer_scroll_ended():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(container, "rect_scale", Vector2.ONE, 0.08)
