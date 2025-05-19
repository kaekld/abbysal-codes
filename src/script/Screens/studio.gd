extends Node

@onready var video = $VideoStreamPlayer

func _ready() -> void:
	video.play()
	video.finished.connect(_on_video_finished)

func _on_video_finished():
	get_tree().change_scene_to_file("res://src/scenes/Screens/Loading/loading_1.tscn")
