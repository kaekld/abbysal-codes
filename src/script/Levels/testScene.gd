extends Node

@onready var chest = $Chest2
@onready var reactor: Node3D = $Reactor

func _ready():
	if GLOBAL.reactor1:
		reactor.disable = true
		reactor.mesh_instance_3d.visible = true
	chest.chest_opened.connect(_on_chest_opened)
	reactor.reactor_disable.connect(_on_reactor_disable)
	
func _on_chest_opened():
	print("El cofre fue abierto")
	
func _on_reactor_disable():
	print(GLOBAL.reactors_disable)
	
