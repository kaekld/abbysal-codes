extends CharacterBody3D

signal set_movement_state(_movement_state: MovementState)
signal set_movement_direction(_movement_direction: Vector3)

@export var movement_states : Dictionary

var movement_direction : Vector3
var bullet = load("res://src/scenes/Player/bullet.tscn")
var instance

@onready var gun_player: AnimationPlayer = $CharacterSkin/Armature/Skeleton3D/BoneAttachment3D/SpaceGun/AnimationPlayer
@onready var gun_barrel: RayCast3D = $CharacterSkin/Armature/Skeleton3D/BoneAttachment3D/SpaceGun/RayCast3D

@onready var floor_type_ray: RayCast3D = $FloorTypeRay
@onready var grass_steps: AudioStreamPlayer3D = $Sounds/GrassSteps
@onready var metal_steps: AudioStreamPlayer3D = $Sounds/MetalSteps
@onready var damage_sounds: AudioStreamPlayer = $DamageSounds

@onready var damage: ColorRect = $Damage
@onready var damage_player: AnimationPlayer = $Damage/AnimationPlayer

@onready var pause_menu: CanvasLayer = $PauseMenu

func _input(event):
	if event.is_action("movement"):
		movement_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		movement_direction.z = Input.get_action_strength("back") - Input.get_action_strength("walk")
		
		if is_movement_ongoing():
			if Input.is_action_pressed("run") and Input.is_action_pressed("walk"):
				set_movement_state.emit(movement_states["run"])
			elif Input.is_action_pressed("run") and Input.is_action_pressed("left"):
				set_movement_state.emit(movement_states["run"])
			elif Input.is_action_pressed("run") and Input.is_action_pressed("right"):
				set_movement_state.emit(movement_states["run"])
			elif Input.is_action_pressed("run") and Input.is_action_pressed("back"):
				set_movement_state.emit(movement_states["run"])
			else:
				if Input.is_action_pressed("aim"):
					set_movement_state.emit(movement_states["walk_aim"])
					if Input.is_action_pressed("shoot") and !gun_player.is_playing():
						gun_player.play("shoot")
						instance = bullet.instantiate()
						instance.position = gun_barrel.global_position
						instance.transform.basis = gun_barrel.global_transform.basis
						get_parent().add_child(instance)
				else:
					set_movement_state.emit(movement_states["walk"])
		else:
			if Input.is_action_pressed("aim"):
				set_movement_state.emit(movement_states["idle_aim"])
				if Input.is_action_pressed("shoot") and !gun_player.is_playing():
					gun_player.play("shoot")
					instance = bullet.instantiate()
					instance.position = gun_barrel.global_position
					instance.transform.basis = gun_barrel.global_transform.basis
					get_parent().add_child(instance)
			else:
				set_movement_state.emit(movement_states["idle"])
				
func _ready():
	set_movement_state.emit(movement_states["idle"])
	PLAYERSTATS.connect("health_changed", _on_health_changed)
	PLAYERSTATS.connect("player_died", _on_player_died)
	pause_menu.connect("paused", _on_game_paused)
	
func _physics_process(_delta):
	if is_movement_ongoing():
		set_movement_direction.emit(movement_direction)
	move_and_slide()

func is_movement_ongoing() -> bool:
	return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0
	
func play_step_sounds():
	if floor_type_ray.is_colliding():
		var collider = floor_type_ray.get_collider()
		if collider.is_in_group("grass"):
			grass_steps.play()
		if collider.is_in_group("metal"):
			metal_steps.play()
			
func _on_health_changed() -> void:
	damage_sounds.play()
	damage.visible = true
	damage_player.play("hit")
	await damage_player.animation_finished
	damage.visible = false

func _on_player_died() -> void:
	get_tree().change_scene_to_file("res://src/scenes/Screens/lost_screen.tscn")

func _on_game_paused():
	movement_direction = Vector3.ZERO
	set_movement_state.emit(movement_states["idle"])
