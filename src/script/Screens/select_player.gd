extends Control

@onready var character_1: Control = $Character1
@onready var character_2: Control = $Character2
@onready var character_3: Control = $Character3

@onready var main_information: Control = $MainInformation
@onready var buttons: Control = $Buttons

@onready var start_audio: AudioStreamPlayer = $MainAudio/StartAudio
@onready var ambient_audio: AudioStreamPlayer = $MainAudio/AmbientAudio

@onready var screen_transition: TextureRect = $Transition/ScreenTransition
@onready var screen_transition_2: TextureRect = $Transition/ScreenTransition2

var _characters = [1,2,3]
var _characterSelected = 0

func _ready() -> void:
	start_audio.play()
	
	await get_tree().create_timer(2.0).timeout
	screen_transition.visible = true
	await get_tree().create_timer(0.3).timeout
	screen_transition.visible = false
	screen_transition_2.visible = true
	await get_tree().create_timer(0.3).timeout
	screen_transition_2.visible = false
	
	main_information.visible = true
	buttons.visible = true
	await get_tree().create_timer(2.0).timeout
	character_1.visible = true


func checkSelectedCharacter():
	var selected = _characters[_characterSelected]

	if selected == 1:
		character_1.visible = true
		character_2.visible = false
		character_3.visible = false
		
	elif selected == 2:
		character_1.visible = false
		character_2.visible = true
		character_3.visible = false
	elif selected == 3:
		character_1.visible = false
		character_2.visible = false
		character_3.visible = true

# LÓGICA UTILIZADA PARA RECORRER CIRCULARMENTE EL ARREGLO PARA PODER RECORRERLO
func prevCharacter():
	_characterSelected = (_characterSelected - 1 + _characters.size()) % _characters.size()
func nextCharacter():
	_characterSelected = (_characterSelected + 1) % _characters.size()

# BOTONES DEL SELECTOR Y SU FUNCIONAMIENTO
func _on_button_left_pressed() -> void:
	prevCharacter()
	checkSelectedCharacter()

func _on_button_right_pressed() -> void:
	nextCharacter()
	checkSelectedCharacter()

func _on_start_audio_finished() -> void:
	ambient_audio.play()

func _on_selected_character_pressed() -> void:
	GLOBAL.character_selected = _characterSelected + 1
	GLOBAL.main_to_level0 = true
	get_tree().change_scene_to_file("res://src/scenes/Screens/Loading/loading_2.tscn")
