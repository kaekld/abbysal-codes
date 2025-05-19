extends Node3D

@export var camera : Camera3D
@export var mouse_sensibility : float = 0.005

var tween : Tween

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Controla el movimiento del mouse en horizontal y vertical, así como el máximo y mínimo
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensibility
		rotation.y = wrapf(rotation.y, 0.0, TAU)
		
		rotation.x -= event.relative.y * mouse_sensibility
		rotation.x = clamp(rotation.x, -PI/2, PI/4)
		
func _on_player_set_movement_state(_movement_state: MovementState) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(camera, "fov", _movement_state.camera_fov, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
