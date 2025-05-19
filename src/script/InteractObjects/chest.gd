extends Node

signal chest_opened  

@onready var animationPlayer = $AnimationPlayer
@onready var label = $Label3D
@onready var open_sound: AudioStreamPlayer3D = $OpenSound

var opened = false
var inRange = false

func _ready():
	label.visible = false
	if PLAYERSTATS.key1:
		animationPlayer.play("open")
		animationPlayer.seek(2.084,true)

func _process(delta):
	if Input.is_action_just_pressed("interact") and !opened and inRange and !PLAYERSTATS.key1:
		opened = true
		label.visible = false
		open_sound.play()
		animationPlayer.play("open")
		chest_opened.emit()  

func _on_area_3d_body_entered(body: Node3D) -> void:
	if "Player" in body.name and !PLAYERSTATS.key1:
		label.visible = true
		inRange = true
	
	if "Player" in body.name and opened:
		label.visible = false

func _on_area_3d_body_exited(body: Node3D) -> void:
	if "Player" in body.name:
		label.visible = false
		inRange = false
