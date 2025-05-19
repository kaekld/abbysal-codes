extends Control

var scene_name = "res://src/scenes/Screens/main_menu.tscn"
var progress = []
var scene_load_status = 0

func _ready():
	ResourceLoader.load_threaded_request(scene_name)

func _process(_delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(scene_name, progress)

	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(scene_name)
		get_tree().change_scene_to_packed(new_scene)
