extends Node

@onready var anim_player: AnimationPlayer = $AnimationPlayer

@onready var label = $Notification/Label
@onready var labelAnimation = $Notification/AnimationPlayer
@onready var chest = $Chest2

@onready var ambient: AudioStreamPlayer = $ambient

@onready var label3d = $Label3D
@onready var label_exit: Label3D = $LabelExit

@onready var labelLevel = $LevelNotification/Level
@onready var labelLevelAnimation = $LevelNotification/AnimationPlayer

@onready var playerPosition = $PlayerSpawn
@onready var exit_spawn: Marker3D = $ExitSpawn

@onready var mission: Label = $MissionOverlay/Mission
@onready var mission_list: Label = $MissionOverlay/MissionList

@onready var reactor: Node3D = $Reactor

@onready var open_door: AudioStreamPlayer = $Sounds/OpenDoor
@onready var error_door: AudioStreamPlayer = $Sounds/ErrorDoor

var player : CharacterBody3D = null

var inRange := false
var inRange_exit := false
var scene_changing:= false

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
	
	if !GLOBAL.back_state:
		player.transform.origin = playerPosition.transform.origin
	else:
		player.transform.origin = exit_spawn.transform.origin
		
	mission_list.text = ">REACTORES :  "+str(GLOBAL.reactors_disable)+"/3"
	
	label.visible = false
	label3d.visible = false
	label_exit.visible = false
	
	labelLevel.visible = false
	
	anim_player.play("fade_in")
	
	await get_tree().create_timer(4.0).timeout
	
	labelLevelAnimation.play("fade_in")
	await get_tree().create_timer(0.1).timeout
	labelLevel.visible = true
	
	ambient.play()
	
	await get_tree().create_timer(4.0).timeout
	labelLevelAnimation.play("fade_out")
	await get_tree().create_timer(3.0).timeout
	labelLevel.visible = false
	
	chest.chest_opened.connect(_on_chest_2_chest_opened)	
	reactor.reactor_disable.connect(_on_reactor_disable)

func _process(_delta):
	if Input.is_action_just_pressed("interact") and inRange and PLAYERSTATS.key2:
		if scene_changing:
			return
		scene_changing = true
		open_door.play()
		anim_player.play("fade_out")
		await anim_player.animation_finished
		GLOBAL.level1_to_level2 = true
		get_tree().change_scene_to_file("res://src/scenes/Screens/Loading/loading_2.tscn")
	
	if Input.is_action_just_pressed("interact") and inRange and !PLAYERSTATS.key2:
		error_door.play()
		label.text = "Necesitas una llave de acceso"
		label.visible = true
		labelAnimation.play("fade_in")
		await get_tree().create_timer(4.0).timeout
		labelAnimation.play("fade_out")
		await get_tree().create_timer(3.0).timeout
		label.visible = false
		
	if Input.is_action_just_pressed("interact") and inRange_exit:
		if scene_changing:
			return
		scene_changing = true
		
		open_door.play()
		anim_player.play("fade_out")
		GLOBAL.back_state = true
		GLOBAL.level1_to_level0 = true
		await anim_player.animation_finished
		get_tree().change_scene_to_file("res://src/scenes/Screens/Loading/loading_2.tscn")

func _on_chest_2_chest_opened() -> void:
	PLAYERSTATS.key2 = true
	
	label.text = "Llave de acceso obtenida"
	label.visible = true
	labelAnimation.play("fade_in")
	await get_tree().create_timer(4.0).timeout
	labelAnimation.play("fade_out")
	await get_tree().create_timer(3.0).timeout
	label.visible = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if "Player" in body.name:
		label3d.visible = true
		inRange = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if "Player" in body.name:
		label3d.visible = false
		inRange = false

func _on_exit_area_body_entered(body: Node3D) -> void:
	if "Player" in body.name:
		label_exit.visible = true
		inRange_exit = true

func _on_exit_area_body_exited(body: Node3D) -> void:
	if "Player" in body.name:
		label_exit.visible = false
		inRange_exit = false

func _on_reactor_disable() -> void:
	mission_list.text = ">REACTORES :  "+str(GLOBAL.reactors_disable)+"/3"
	GLOBAL.reactor3 = true
