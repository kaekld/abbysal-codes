extends Control

@onready var ambient_audio: AudioStreamPlayer = $MainAudio/AmbientAudio
@onready var load: AudioStreamPlayer = $MainAudio/Load
@onready var failed: AudioStreamPlayer = $MainAudio/Failed
@onready var complete: AudioStreamPlayer = $MainAudio/Complete

@onready var title: Label = $MainInformation/Header/Title
@onready var title_player: AnimationPlayer = $MainInformation/Header/TitlePlayer

@onready var character_1_scan: VideoStreamPlayer = $Character1_Scan
@onready var character_2_scan: VideoStreamPlayer = $Character2_Scan
@onready var character_3_scan: VideoStreamPlayer = $Character3_Scan

@onready var reactors: Label = $Stats/VBoxContainer/Reactors
@onready var time: Label = $Stats/VBoxContainer/Time
@onready var damage: Label = $Stats/VBoxContainer/Damage

@onready var final_result: Label = $FinalResult
@onready var fired: Control = $Fired
@onready var go_to_main: Button = $GoToMain


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	await get_tree().create_timer(0.3).timeout
	title.visible = true
	title_player.play("loading_results")
	await get_tree().create_timer(0.5).timeout
	if GLOBAL.character_selected == 1:
		character_1_scan.visible = true
	elif GLOBAL.character_selected == 2:
		character_2_scan.visible = true
	elif GLOBAL.character_selected == 3:
		character_3_scan.visible = true
	
	await get_tree().create_timer(0.3).timeout
	load.play()
	reactors.text = "Reactores deshabilitados: "+str(GLOBAL.reactors_disable)
	reactors.visible = true
	
	var total_seconds = GLOBALTIMER.elapsed_time
	var minutes = int(total_seconds / 60)
	var seconds = int(total_seconds % 60)
	var formatted_time = "%d:%02d" % [minutes, seconds]
	
	await get_tree().create_timer(2).timeout
	load.play()
	time.text = "Tiempo de la misión: " + formatted_time
	time.visible = true
	
	await get_tree().create_timer(2).timeout
	load.play()
	damage.text = "Porcentaje de lesión: " + str(100-PLAYERSTATS.hp) + "%"
	damage.visible = true
	
	await get_tree().create_timer(2).timeout
	if GLOBAL.reactors_disable < 2:
		fired.visible = true
		final_result.text = "MISIÓN FALLIDA"
		failed.play()
	else:
		final_result.text = "MISIÓN CUMPLIDA"
		complete.play()
	final_result.visible = true
	
	title_player.stop()
	title_player.seek(3.0,true)
	
	go_to_main.visible = true
	
func _on_go_to_main_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/Screens/Loading/loading_1.tscn")
