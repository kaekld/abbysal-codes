extends Node

@onready var menuButtons = $Menu_Buttons
@onready var startAnimation = $Menu_Buttons/AnimationPlayer

@onready var fade_transition: Control = $FadeTransition
@onready var fade_player: AnimationPlayer = $FadeTransition/FadePlayer

var characterSelection : int
var scene_changing := false

func _ready() -> void:
	fade_transition.visible = true
	fade_player.play("fade_in")
	menuButtons.visible = true

func _on_start_pressed() -> void:
	if scene_changing:
		return
	scene_changing = true
	
	GLOBALTIMER.reset_timer()
	GLOBAL.reactors_disable = 0
	GLOBAL.reactor1 = false
	GLOBAL.reactor2 = false
	GLOBAL.reactor3 = false
	PLAYERSTATS.hp = 100
	PLAYERSTATS.key1 = false
	PLAYERSTATS.key2 = false
	fade_player.play("fade_out")
	await fade_player.animation_finished
	changeScene()
	
func _on_exit_pressed() -> void:
	get_tree().quit()

func changeScene() -> void:
	GLOBAL.selectScreen = true
	get_tree().change_scene_to_file("res://src/scenes/Screens/Loading/loading_2.tscn")
	
