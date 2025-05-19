extends Control

@onready var character_1_scan: VideoStreamPlayer = $Character1_Scan
@onready var character_2_scan: VideoStreamPlayer = $Character2_Scan
@onready var character_3_scan: VideoStreamPlayer = $Character3_Scan
@onready var title: Label = $Title
@onready var fired: Control = $Fired
@onready var go_to_main: Button = $GoToMain

@onready var load: AudioStreamPlayer = $Load
@onready var failed: AudioStreamPlayer = $Failed

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	await get_tree().create_timer(1.0).timeout
	load.play()
	title.visible = true
	
	await get_tree().create_timer(1.0).timeout
	if GLOBAL.character_selected == 1:
		character_1_scan.visible = true
	elif GLOBAL.character_selected == 2:
		character_2_scan.visible = true
	elif GLOBAL.character_selected == 3:
		character_3_scan.visible = true
	
	failed.play()
	fired.visible = true
	
	go_to_main.visible = true

func _on_go_to_main_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/Screens/Loading/loading_1.tscn")
