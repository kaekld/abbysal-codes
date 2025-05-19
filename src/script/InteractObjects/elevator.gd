extends Node

@onready var labelEntrance = $ElevadotUp/LabelEntrance
@onready var label_entrance_exit = $ElevatorDown/LabelEntranceExit

@onready var animationElevator = $Elevator/AnimationPlayer
@onready var animationElevatorUp = $Elevator/AnimationPlayer2

var opened = false
var closed = false
var opened_2 = false

var inRange = false
var inRange_2 = false
var inRange_3 = false

var elevator_used = false

@onready var moving: AudioStreamPlayer3D = $Sounds/Moving
@onready var open: AudioStreamPlayer3D = $Sounds/Open
@onready var close: AudioStreamPlayer3D = $Sounds/Close


func _ready():
	labelEntrance.visible = false
	label_entrance_exit.visible = false
	
	if GLOBAL.back_state:
		animationElevatorUp.play("down")
		animationElevatorUp.stop()
	
func _process(_delta):
	if !GLOBAL.back_state:
		if Input.is_action_just_pressed("interact") and !opened and inRange:
			open.play()
			opened = true
			labelEntrance.visible = false
			animationElevator.play("02_open")
			await get_tree().create_timer(2.0).timeout  
			animationElevator.stop()
			animationElevator.seek(2, true)
		
		if inRange_2 and !closed:
			closed = true
			animationElevator.play("02_open")
			animationElevator.seek(7, true)	
			await get_tree().create_timer(4.0).timeout  
			animationElevator.stop()
			
			close.play()
			animationElevatorUp.play("up")
			moving.play()
			
			await animationElevatorUp.animation_finished
			
		if inRange_3 and !opened_2:
			opened_2 = true
			open.play()
			animationElevator.play("02_open")
			await get_tree().create_timer(2.0).timeout  
			animationElevator.stop()
			animationElevator.seek(2, true)	
	else:
		if Input.is_action_just_pressed("interact") and !opened and inRange:
			open.play()
			opened = true 
			label_entrance_exit.visible = false
			animationElevator.play("02_open")
			await get_tree().create_timer(2.0).timeout  
			animationElevator.stop()
			animationElevator.seek(2, true)
		
		if inRange_2 and !closed:
			print("dentro")
			closed = true
			animationElevator.play("02_open")
			animationElevator.seek(7, true)	
			await get_tree().create_timer(4.0).timeout  
			animationElevator.stop()
			
			close.play()
			animationElevatorUp.play("down")
			moving.play()
			await animationElevatorUp.animation_finished
			
		if inRange_3 and !opened_2:
			opened_2 = true
			open.play()
			animationElevator.play("02_open")
			await get_tree().create_timer(2.0).timeout  
			animationElevator.stop()
			animationElevator.seek(2, true)	

func _on_elevator_entrance_body_entered(body: Node3D) -> void:
	if "Player" in body.name and !GLOBAL.back_state:
		labelEntrance.visible = true
		inRange = true
		
	if "Player" in body.name and opened and !GLOBAL.back_state:
		labelEntrance.visible = false

func _on_elevator_entrance_body_exited(body: Node3D) -> void:
	if "Player" in body.name and !GLOBAL.back_state:
		labelEntrance.visible = false
		inRange = false

func _on_inside_body_entered(body: Node3D) -> void:
	if "Player" in body.name and !GLOBAL.back_state:
		inRange_2 = true

func _on_elevator_up_body_entered(body: Node3D) -> void:
	if "Player" in body.name and !GLOBAL.back_state:
		inRange_3 = true

#Elevador abajo

func _on_elevator_entrance_exit_body_entered(body: Node3D) -> void:
	if "Player" in body.name and GLOBAL.back_state:
		label_entrance_exit.visible = true
		inRange = true
		
	if "Player" in body.name and opened and GLOBAL.back_state:
		label_entrance_exit.visible = false

func _on_elevator_entrance_exit_body_exited(body: Node3D) -> void:
	if "Player" in body.name and GLOBAL.back_state:
		label_entrance_exit.visible = false
		inRange = false

func _on_inside_down_body_entered(body: Node3D) -> void:
	if "Player" in body.name and GLOBAL.back_state:
		inRange_2 = true

func _on_elevator_down_body_entered(body: Node3D) -> void:
	if "Player" in body.name and GLOBAL.back_state:
		inRange_3 = true
