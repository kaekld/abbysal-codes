extends Control

var scene_name
var progress = []
var scene_load_status = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var time_waited := 0.0
var min_wait_time := 3.0
var scene_ready := false

func _ready():
	animation_player.play("loading")
	
	if GLOBAL.selectScreen:
		scene_name = "res://src/scenes/Screens/selection_player.tscn"
		GLOBAL.selectScreen = false
		
	elif GLOBAL.main_to_level0:
		scene_name = "res://src/scenes/Levels/ocean.tscn"
		GLOBAL.main_to_level0 = false
		
	elif GLOBAL.level0_to_level1:
		scene_name = "res://src/scenes/Levels/level1.tscn"
		GLOBAL.level0_to_level1 = false
		
	elif GLOBAL.level1_to_level0:
		scene_name = "res://src/scenes/Levels/ocean.tscn"
		GLOBAL.level1_to_level0 = false
	
	elif GLOBAL.level1_to_level2: 
		scene_name = "res://src/scenes/Levels/level2.tscn"
		GLOBAL.level1_to_level2 = false
		
	elif GLOBAL.level2_to_level1: 
		scene_name = "res://src/scenes/Levels/level1.tscn"
		GLOBAL.level2_to_level1 = false
		
	elif GLOBAL.resultScreen:
		scene_name = "res://src/scenes/Screens/results.tscn"
		GLOBAL.resultScreen = false
		
	ResourceLoader.load_threaded_request(scene_name)

func _process(delta):
	time_waited += delta
	scene_load_status = ResourceLoader.load_threaded_get_status(scene_name, progress)

	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		scene_ready = true

	# Solo cambiamos de escena cuando se cumplen ambas condiciones
	if scene_ready and time_waited >= min_wait_time:
		var new_scene = ResourceLoader.load_threaded_get(scene_name)
		get_tree().change_scene_to_packed(new_scene)
