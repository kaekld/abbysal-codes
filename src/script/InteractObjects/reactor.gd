extends Node3D

signal reactor_disable

var area_range: bool = false
var disable: bool = false

@onready var label_3d: Label3D = $Label3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var reactor_off: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	label_3d.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and area_range and !disable:
		disable = true
		label_3d.visible = false
		mesh_instance_3d.visible = true
		
		GLOBAL.reactors_disable += 1
		reactor_off.play()
		
		emit_signal("reactor_disable")
		
func _on_area_3d_body_entered(body: Node3D) -> void:
	if "Player" in body.name and !disable:
		area_range = true
		label_3d.visible = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if "Player" in body.name:
		area_range = false
		label_3d.visible = false
		
