extends Control

@onready var continue_button = $continue
@onready var exit_button = $exit

var is_paused: bool = false

func _ready():
	continue_button.pressed.connect(_on_continue_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

	visible = false 
func _input(event):
	if event.is_action_pressed("menu"):
		toggle_pause_menu()

func toggle_pause_menu():
	is_paused = !is_paused
	visible = is_paused 
	get_tree().paused = is_paused
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if is_paused else Input.MOUSE_MODE_CAPTURED)

func _on_continue_button_pressed():
	toggle_pause_menu()
	print("continuar")

func _on_exit_button_pressed():
	get_tree().quit()
	print("salir")
	
