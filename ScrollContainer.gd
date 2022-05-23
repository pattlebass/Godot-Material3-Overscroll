extends ScrollContainer

onready var container = $VBoxContainer

var initial_touch

func _on_ScrollContainer_scroll_ended():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(container, "rect_scale", Vector2.ONE, 0.08)


func _input(event):
	if event is InputEventScreenTouch:
		if !event.pressed:
			initial_touch = null
	if event is InputEventScreenDrag:
		if !initial_touch:
			initial_touch = event.position
		
		# For horizontal scrolling, uncomment these lines
#		if scroll_horizontal_enabled:
#			var distance = abs(initial_touch.x - event.position.x)
#			if scroll_horizontal == 0:
#				container.rect_pivot_offset.x = 0
#			elif scroll_horizontal == container.rect_size.x - rect_size.x:
#				container.rect_pivot_offset.x = container.rect_size.x
#			else:
#				return
#			container.rect_scale.x = clamp(0.01 * log(distance*0.1) + 1, 1, 1.1)
		
		# For vertical scrolling
		if scroll_vertical_enabled and get_v_scrollbar().visible:
			var distance = abs(initial_touch.y - event.position.y)
			if scroll_vertical == 0:
				container.rect_pivot_offset.y = 0
			elif scroll_vertical == int(container.rect_size.y - rect_size.y):
				container.rect_pivot_offset.y = container.rect_size.y
			else:
				return
			container.rect_scale.y = clamp(0.01 * log(distance*0.1) + 1, 1, 1.1)
