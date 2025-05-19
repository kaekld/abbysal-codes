extends Camera3D

@export var spring_arm: Node3D
@export var lerp_power: float = 1.0

# Con esta función, el rebote de la camara es más suave y de esta manera es menos brusca
# Ajustando el Lerp desde el inspector puedes hacerlo más o menos suave
func _process(delta: float) -> void:
	position = lerp(position, spring_arm.position, delta*lerp_power)
