extends Node

@export var animation_tree : AnimationTree
@export var player : CharacterBody3D

var tween: Tween

func _on_player_set_movement_state(_movement_state: MovementState) -> void:
		if tween:
			tween.kill()
		
		tween = create_tween()
		tween.tween_property(animation_tree, "parameters/BlendSpace2D/blend_position", _movement_state.position, 0.25)
		tween.parallel().tween_property(animation_tree, "parameters/TimeScale/scale", _movement_state.animation_speed, 0.7)
