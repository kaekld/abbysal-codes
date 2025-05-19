extends CanvasLayer

signal paused()

@onready var vhs: CanvasLayer = $VHS
@onready var pause_sound: AudioStreamPlayer = $"../PauseSound"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if get_tree().paused:
			resume_game()
		else:
			pause_game()
			
func pause_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true              
	self.visible = true        
	vhs.visible = true
	pause_sound.play()
	emit_signal("paused")    

func resume_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false     
	pause_sound.stop()
	self.visible = false 
	vhs.visible = false

func _on_continue_pressed() -> void:
	resume_game()

func _on_exit_pressed() -> void:
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://src/scenes/Screens/Loading/loading_1.tscn")
	
