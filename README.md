# Material 3 Overscroll Stretch for Godot 3

This is a demo showcasing the Material 3 overscroll animation in Godot.

https://user-images.githubusercontent.com/49322676/200324045-e56be740-8390-40d8-a07c-15fc779dece8.mov

## Code

```
extends ScrollContainer


export(NodePath) onready var container = get_node(container) as Control

var initial_touch

const MAX_DISTANCE = 300
const MAX_ADD_SCALE = 0.03


func _ready():
# warning-ignore:return_value_discarded
	connect("scroll_ended", self, "_on_ScrollContainer_scroll_ended")


func _input(event) -> void:
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
			container.rect_scale.x = get_computed_scale(distance.x)
		
		# For vertical scrolling
		if get_v_scrollbar().visible:
			if scroll_vertical == 0:
				container.rect_pivot_offset.y = 0
			elif scroll_vertical == int(container.rect_size.y - rect_size.y):
				container.rect_pivot_offset.y = container.rect_size.y
			else:
				return
			container.rect_scale.y = get_computed_scale(distance.y)


func get_computed_scale(x: float) -> float:
	return 1 + easeOutQuad(min(x / MAX_DISTANCE, 1)) * MAX_ADD_SCALE


func easeOutQuad(x: float) -> float:
	# From https://easings.net/#easeOutQuad
	# The variable x represents the absolute progress of the animation in the
	# bounds of 0 (beginning of the animation) and 1 (end of animation).
	return 1 - (1 - x) * (1 - x)


func _on_ScrollContainer_scroll_ended() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(container, "rect_scale", Vector2.ONE, 0.08)

```
