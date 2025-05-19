extends Node

@onready var fade = $AnimationPlayer
@onready var labelLevel = $LevelNotification/Level
@onready var labelLevelAnimation = $LevelNotification/AnimationPlayer
@onready var fade_screen: ColorRect = $AnimationPlayer/ColorRect

@onready var playerPosition = $PlayerSpawn
@onready var exit_label: Label3D = $ExitArea/ExitLabel

@onready var reactor: Node3D = $Reactor
@onready var reactor_2: Node3D = $Reactor2

@onready var mission_list: Label = $MissionOverlay/MissionList
@onready var open_door: AudioStreamPlayer = $Sounds/OpenDoor

var player : CharacterBody3D = null

var inRange_exit := false
var scene_changing = false

func _ready() -> void:
	
	if GLOBAL.character_selected == 1:
		var player_scene = preload("res://src/scenes/Player/player_default.tscn").instantiate()
		player = player_scene
		add_child(player)
	
	if GLOBAL.character_selected == 2:
		var player_scene = preload("res://src/scenes/Player/player_2.tscn").instantiate()
		player = player_scene
		add_child(player)
	
	if GLOBAL.character_selected == 3:
		var player_scene = preload("res://src/scenes/Player/player_3.tscn").instantiate()
		player = player_scene
		add_child(player)
	
	player.transform.origin = playerPosition.transform.origin
	
	fade_screen.visible = true
	labelLevel.visible = false
	exit_label.visible = false
	
	if GLOBAL.reactor1:
		reactor.disable = true
		reactor.mesh_instance_3d.visible = true
	
	if GLOBAL.reactor2:
		reactor_2.disable = true
		reactor_2.mesh_instance_3d.visible = true
	
	reactor.reactor_disable.connect(_on_reactor_disable)
	reactor_2.reactor_disable.connect(_on_reactor2_disable)
	
	mission_list.text = ">REACTORES :  "+str(GLOBAL.reactors_disable)+"/3"
	
	fade.play("fade_in")
	await get_tree().create_timer(4.0).timeout
	
	labelLevelAnimation.play("fade_in")
	await get_tree().create_timer(0.1).timeout
	labelLevel.visible = true
	
	await get_tree().create_timer(4.0).timeout
	labelLevelAnimation.play("fade_out")
	await get_tree().create_timer(3.0).timeout
	labelLevel.visible = false
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and inRange_exit:
		if scene_changing:
			return
		scene_changing = true
		
		open_door.play()
		fade.play("fade_out")
		await fade.animation_finished
		GLOBAL.back_state = true
		GLOBAL.level2_to_level1 = true
		get_tree().change_scene_to_file("res://src/scenes/Screens/Loading/loading_2.tscn")

func _on_exit_area_body_entered(body: Node3D) -> void:
	if "Player" in body.name:
		exit_label.visible=true
		inRange_exit = true

func _on_exit_area_body_exited(body: Node3D) -> void:
	if "Player" in body.name:
		exit_label.visible=false
		inRange_exit = false

func _on_reactor_disable() -> void:
	mission_list.text = ">REACTORES :  "+str(GLOBAL.reactors_disable)+"/3"
	GLOBAL.reactor1 = true
	
func _on_reactor2_disable() -> void:
	mission_list.text = ">REACTORES :  "+str(GLOBAL.reactors_disable)+"/3"
	GLOBAL.reactor2 = true
