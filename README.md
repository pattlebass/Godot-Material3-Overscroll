# Material 3 Overscroll Stretch for Godot 3

This is a demo showcasing the Material 3 overscroll animation in Godot.


## Code
```
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
```
