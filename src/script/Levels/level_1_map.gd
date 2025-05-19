extends Node

@onready var doorAnimation = $door/AnimationPlayer
@onready var doorEntrance = $"../door"
@onready var open_door: AudioStreamPlayer = $"../Sounds/OpenDoor"

var opened = false
var inRange = false

func _process(_delta):
	if inRange and !opened:
		opened = true
		open_door.play()
		doorAnimation.play("Armature|ArmatureAction")
		await get_tree().create_timer(1.0).timeout  
		doorAnimation.stop()
		doorAnimation.seek(1.0,true)

func _on_door_body_entered(body: Node3D) -> void:
	if "Player" in body.name:
		inRange = true
