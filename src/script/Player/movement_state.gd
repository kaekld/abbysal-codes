extends Resource
class_name MovementState

# Variables de cada uno de los estados del jugador, configurables en cada uno de los
# recursos en la carpeta de MovementStates

@export var position: Vector2
@export var movement_speed: float
@export var acceleration: float = 6
@export var camera_fov: float = 75
@export var animation_speed: float = 1
