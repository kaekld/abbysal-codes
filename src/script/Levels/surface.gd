extends Node

@onready var chest = $Chest
@onready var label = $Notification/Label
@onready var labelAnimation = $Notification/AnimationPlayer

@onready var label3d = $Label3D

@onready var fade_transition: Control = $FadeTransition
@onready var fade_player: AnimationPlayer = $FadeTransition/FadePlayer

@onready var labelLevel = $LevelNotification/Level
@onready var labelLevelAnimation = $LevelNotification/AnimationPlayer

@onready var returning_label: Label3D = $ReturningLabel

@onready var playerPosition = $PlayerSpawn
@onready var exit_spawn: Marker3D = $ExitSpawn

@onready var music = $Music
@onready var ambient_surface: AudioStreamPlayer = $AmbientSurface

@onready var mission: Label = $MissionOverlay/Mission
@onready var mission_list: Label = $MissionOverlay/MissionList

@onready var ship_label: Label3D = $ShipArea/ShipLabel

@onready var open_door: AudioStreamPlayer = $Sounds/OpenDoor
@onready var error_door: AudioStreamPlayer = $Sounds/ErrorDoor

var shipArea: bool = false
var player: CharacterBody3D = null
var inRangeAccess := false
var scene_changing := false

func _ready():
	
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
		GLOBALTIMER.start_timer()
		player.transform.origin = playerPosition.transform.origin
	else:
		player.transform.origin = exit_spawn.transform.origin
		GLOBAL.back_state = false
	
	if PLAYERSTATS.key1:
		mission.text = "Misión: Desactiva los\nreactores"
		mission_list.text = ">REACTORES :  "+str(GLOBAL.reactors_disable)+"/3"
	
	label.visible = false
	label3d.visible = false
	returning_label.visible = false
	ship_label.visible = false
	
	labelLevel.visible = false
	fade_transition.visible = true
	
	ambient_surface.play()
	
	fade_player.play("fade_in")
	await get_tree().create_timer(2.0).timeout
	
	labelLevelAnimation.play("fade_in")
	await get_tree().create_timer(0.1).timeout
	labelLevel.visible = true
	
	music.play()
	
	await get_tree().create_timer(4.0).timeout
	labelLevelAnimation.play("fade_out")
	await get_tree().create_timer(3.0).timeout
	labelLevel.visible = false
	
	chest.chest_opened.connect(_on_chest_opened)

func _process(delta):
	if Input.is_action_just_pressed("interact") and inRangeAccess and PLAYERSTATS.key1:
		if scene_changing:
			return
		scene_changing = true
		
		open_door.play()
		fade_player.play("fade_out")
		await fade_player.animation_finished
		GLOBAL.level0_to_level1 = true
		get_tree().change_scene_to_file("res://src/scenes/Screens/Loading/loading_2.tscn")
		
	if Input.is_action_just_pressed("interact") and inRangeAccess and !PLAYERSTATS.key1:
		
		label.text = "Necesitas una llave de acceso"
		error_door.play()
		labelAnimation.play("fade_in")
		
		await get_tree().create_timer(0.1).timeout
		label.visible = true

		await get_tree().create_timer(4.0).timeout
		labelAnimation.play("fade_out")
		await get_tree().create_timer(3.0).timeout
		label.visible = false

	if Input.is_action_just_pressed("interact") and shipArea: 
		GLOBALTIMER.stop_timer()
		fade_player.play("fade_out")
		await fade_player.animation_finished
		GLOBAL.resultScreen = true
		get_tree().change_scene_to_file("res://src/scenes/Screens/Loading/loading_2.tscn")
		
func _on_chest_opened():
	PLAYERSTATS.key1 = true
	mission_list.text = "> LLAVE: TRUE"
	
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
		inRangeAccess = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if "Player" in body.name:
		inRangeAccess = false
		label3d.visible = false

func _on_ship_area_body_entered(body: Node3D) -> void:
	if "Player" in body.name:
		shipArea = true
		ship_label.visible = true
func _on_ship_area_body_exited(body: Node3D) -> void:
	if "Player" in body.name:
		shipArea = false
		ship_label.visible = false
