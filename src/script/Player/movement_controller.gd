extends Node

@export var player : CharacterBody3D
@export var mesh_root : Node3D
@export var camera : Node3D

@export var rotation_speed : float = 8
@export var gravity : float = 9.8 * 8  

var direction : Vector3
var velocity : Vector3
var acceleration : float
var speed : float

func _physics_process(delta):
	velocity.x = speed * direction.normalized().x
	velocity.z = speed * direction.normalized().z

	velocity.y = player.velocity.y

	if not player.is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0  

	player.velocity = player.velocity.lerp(velocity, acceleration * delta)
	player.move_and_slide()

	if direction.length() > 0.1:
		var target_rotation = atan2(direction.x, direction.z)
		mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, target_rotation, rotation_speed * delta)

func _on_set_movement_state(_movement_state : MovementState):
	speed = _movement_state.movement_speed
	acceleration = _movement_state.acceleration

func _on_set_movement_direction(_movement_direction : Vector3):
	direction = _movement_direction.rotated(Vector3.UP, camera.global_rotation.y)
